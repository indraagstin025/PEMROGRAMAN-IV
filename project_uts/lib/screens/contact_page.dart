import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../models/contact_model.dart';
import '../widgets/contact_form.dart';
import '../widgets/contact_card.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<ContactModel> contactList = [];
  int? _editingIndex;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();

  Color _selectedColor = Colors.green;
  DateTime? _selectedDate;
  String? _pickedFilePath;
  String? _pickedFileName;

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pilih Warna"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() => _selectedColor = color);
            },

            displayThumbColor: true,
            enableAlpha: false,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          ElevatedButton(
            child: const Text('Pilih'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _pickedFilePath = result.files.single.path;
        _pickedFileName = result.files.single.name;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final contactData = ContactModel(
        fullName: _nameController.text,
        phoneNumber: _phoneController.text,
        date: _selectedDate!,
        color: _selectedColor,
        filePath: _pickedFilePath,
      );

      setState(() {
        if (_editingIndex == null) {
          contactList.add(contactData);
        } else {
          contactList[_editingIndex!] = contactData;
          _editingIndex = null;
        }
        _resetForm();
      });
    }
  }

  void _resetForm() {
    _nameController.clear();
    _phoneController.clear();
    _dateController.clear();
    setState(() {
      _selectedDate = null;
      _selectedColor = Colors.blue;
      _pickedFilePath = null;
      _pickedFileName = null;
      _editingIndex = null;
    });
  }

  void _onEditPressed(int index) {
    final contact = contactList[index];
    setState(() {
      _editingIndex = index;
      _nameController.text = contact.fullName;
      _phoneController.text = contact.phoneNumber;
      _dateController.text = DateFormat('dd-MM-yyyy').format(contact.date);
      _selectedDate = contact.date;
      _selectedColor = contact.color;
      _pickedFilePath = contact.filePath;

      if (contact.filePath != null) {
        _pickedFileName = contact.filePath!.split('/').last;
      }
    });
  }

  void _deleteContact(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Penghapusan"),
          content: const Text("Apakah Anda yakin ingin menghapus kontak ini?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  contactList.removeAt(index);
                  if (_editingIndex == index) {
                    _resetForm();
                  }
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(16),

          color: Colors.green,

          child: Row(
            children: [
              const Icon(Icons.person_add, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                _editingIndex == null ? "Buat Kontak Baru" : "Edit Kontak",

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ContactForm(
            formKey: _formKey,
            nameController: _nameController,
            phoneController: _phoneController,
            dateController: _dateController,
            selectedColor: _selectedColor,
            pickedFileName: _pickedFileName,
            onPickDate: _pickDate,
            onPickColor: _pickColor,
            onPickFile: _pickFile,
            onSubmit: _submitForm,
            isEditing: _editingIndex != null,
            onCancelEdit: _editingIndex != null ? _resetForm : null,
          ),
        ),

        const Divider(thickness: 4, color: Colors.grey),

        if (contactList.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Text("Tidak Ada Kontak.", textAlign: TextAlign.center),
          )
        else
          ...contactList.asMap().entries.map((entry) {
            int index = entry.key;
            ContactModel data = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ContactCard(
                contact: data,
                onEditPressed: () => _onEditPressed(index),
                onDeletePressed: () => _deleteContact(index),
              ),
            );
          }).toList(),

        const SizedBox(height: 50),
      ],
    );
  }
}
