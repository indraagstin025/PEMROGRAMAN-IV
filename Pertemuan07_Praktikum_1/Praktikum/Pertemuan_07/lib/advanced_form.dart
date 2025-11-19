import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AdvancedForm extends StatefulWidget {
  const AdvancedForm({super.key});

  @override
  State<AdvancedForm> createState() => _AdvancedFormState();
}

class _AdvancedFormState extends State<AdvancedForm> {
  DateTime _selectedDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('d MMMM yyyy');

  Color _selectedColor = Colors.greenAccent;
  String _pickerType = "BlockPicker";

  String? _dataFile;
  String? _dataFilePath;

  int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Widget Interaktif"), backgroundColor: Colors.green,),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildDatePicker(context),
            const Divider(height: 40),
            buildColorPicker(context),
            const Divider(height: 40),
            buildFilePicker(context),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Gallery'),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Form Validation',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.input), label: 'Form Input'),
          BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Advanced'),
        ],
      ),
    );
  }

  Widget buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date Picker",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Text(
              _dateFormat.format(_selectedDate),
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green
              ),
              child: const Text("Pilih Tanggal"),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pick = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2026),
    );

    if (pick != null) {
      setState(() => _selectedDate = pick);
    }
  }

  Widget buildColorPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Color Picker",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: _selectedColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
        ),

        const SizedBox(height: 12),

        DropdownButton<String>(
          value: _pickerType,
          items: const [
            DropdownMenuItem(value: "BlockPicker", child: Text("Block Picker")),
            DropdownMenuItem(value: "ColorPicker", child: Text("Color Picker")),
            DropdownMenuItem(value: "SlidePicker", child: Text("Slide Picker")),
          ],
          onChanged: (value) {
            setState(() => _pickerType = value!);
          },
        ),

        const SizedBox(height: 10),

        ElevatedButton(
          onPressed: _showColorDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green
          ),
          child: const Text("Pick Color"),
        ),
      ],
    );
  }

  void _showColorDialog() {
    Widget pickerWidget;

    switch (_pickerType) {
      case "ColorPicker":
        pickerWidget = ColorPicker(
          pickerColor: _selectedColor,
          onColorChanged: (c) => setState(() => _selectedColor = c),
        );
        break;

      case "SlidePicker":
        pickerWidget = SlidePicker(
          pickerColor: _selectedColor,
          onColorChanged: (c) => setState(() => _selectedColor = c),
        );
        break;

      default:
        pickerWidget = BlockPicker(
          pickerColor: _selectedColor,
          onColorChanged: (c) => setState(() => _selectedColor = c),
        );
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Choose Color ($_pickerType)"),
        content: pickerWidget,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget buildFilePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pilih File",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),
        Center(
      
          child: ElevatedButton(

            onPressed: _pickFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green
            ),
            child: const Text("Pilih dan buka File"),
          ),
        ),

        if (_dataFile != null) ...[
          const SizedBox(height: 12),
          Text("File Name: $_dataFile"),

          const SizedBox(height: 12),

          if (_dataFilePath != null &&
              (_dataFilePath!.endsWith(".jpg") ||
                  _dataFilePath!.endsWith(".jpeg") ||
                  _dataFilePath!.endsWith(".png")))
            Image.file(
              File(_dataFilePath!),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported, size: 80),
            ),
        ],
      ],
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null) {
      final file = result.files.single;

      setState(() {
        _dataFile = file.name;
        _dataFilePath = file.path;
      });

      if (_dataFilePath != null) {
        _openFile(_dataFilePath!);
      }
    }
  }

  Future<void> _openFile(String path) async {
    await OpenFile.open(path);
  }
}
