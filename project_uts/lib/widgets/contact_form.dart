import 'package:flutter/material.dart';
import '../utils/validators.dart';

class ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController dateController;
  final Color selectedColor;
  final String? pickedFileName;
  final VoidCallback onPickDate;
  final VoidCallback onPickColor;
  final VoidCallback onPickFile;
  final VoidCallback onSubmit;
  final bool isEditing;
  final VoidCallback? onCancelEdit;

  const ContactForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.dateController,
    required this.selectedColor,
    this.pickedFileName,
    required this.onPickDate,
    required this.onPickColor,
    required this.onPickFile,
    required this.onSubmit,
    required this.isEditing,
    this.onCancelEdit,
  });

  static const double buttonRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Nama",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: Validators.validateName,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: "Nomor Telepon",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            validator: Validators.validatePhoneNumber,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: dateController,
            readOnly: true,
            onTap: onPickDate,
            decoration: const InputDecoration(
              labelText: "Tanggal",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
            validator: Validators.validateDate,
          ),
          const SizedBox(height: 16),

          const Text("Color", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(height: 50, color: selectedColor),
          ElevatedButton(
            onPressed: onPickColor,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonRadius),
              ),
            ),
            child: const Text("Pilih Warna"),
          ),
          const SizedBox(height: 16),
          const Text(
            "Pilih File",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: onPickFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonRadius),
                  ),
                ),
                child: const Text("Pilih dan Buka File"),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  pickedFileName ?? "tidak ada file yang dipilih",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonRadius),
                    ),
                  ),
                  child: Text(
                    isEditing ? "Simpan Perubahan" : "Simpan",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              if (isEditing) ...[
                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: onCancelEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black87,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonRadius),
                    ),
                  ),
                  child: const Text("Batal"),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
