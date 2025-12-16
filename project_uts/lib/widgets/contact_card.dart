import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/contact_model.dart';

class ContactCard extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const ContactCard({
    super.key,
    required this.contact,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(contact.date);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),

        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue.shade100,

          backgroundImage:
              (contact.filePath != null && File(contact.filePath!).existsSync())
              ? FileImage(File(contact.filePath!))
              : null,

          child:
              (contact.filePath == null ||
                  !File(contact.filePath!).existsSync())
              ? Text(
                  contact.fullName.isNotEmpty
                      ? contact.fullName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                )
              : null,
        ),

        title: Text(
          contact.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contact.phoneNumber),
            Text(formattedDate),
            const SizedBox(height: 5),
            Container(
              width: 100,
              height: 5,
              decoration: BoxDecoration(
                color: contact.color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: onEditPressed,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDeletePressed,
            ),
          ],
        ),
      ),
    );
  }
}
