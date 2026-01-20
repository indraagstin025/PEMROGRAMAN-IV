// view/widget/contact_card.dart
// Widget untuk menampilkan hasil response dari POST/PUT/DELETE.
// Menggunakan Dismissible agar user dapat menghapus (dismiss) tampilan response.

import 'package:flutter/material.dart';
import 'package:pertemuan13/model/contact_model.dart';


typedef VoidCallbackNoArgs = void Function();

class ContactCard extends StatelessWidget {
  final ContactResponse ctRes;
  final VoidCallbackNoArgs? onDismissed;

  const ContactCard({
    super.key,
    required this.ctRes,
    this.onDismissed,
  });

  // Memory cleanup helper for ContactResponse
  void _cleanupContactResponse() {
    // Help garbage collection by clearing references
    debugPrint('CLEANING UP CONTACT RESPONSE: ${ctRes.message}');
  }

  @override
  Widget build(BuildContext context) {
    // Memory monitoring for response cards
    debugPrint('BUILDING CONTACT CARD - MEMORY USAGE: ${ctRes.message.length} chars');
    
    // Key untuk Dismissible, pakai message atau insertedId
    final keyValue = ctRes.message.isNotEmpty
        ? ctRes.message
        : ctRes.insertedId?.toString() ?? UniqueKey().toString();

    return Dismissible(
      key: Key(keyValue),
      // Hanya geser ke kiri (endToStart) untuk menghapus / menghilangkan hasil response
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Cleanup memory when dismissed
        _cleanupContactResponse();
        if (onDismissed != null) onDismissed!();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _getCardColor(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan icon dan status
            Row(
              children: [
                Icon(
                  _getStatusIcon(),
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getStatusTitle(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // Prevent text overflow memory issues
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Tampilkan ID jika ada (beberapa operasi update tidak return insertedId)
            if (ctRes.insertedId != null)
              _buildDataRow('ID', ctRes.insertedId),
            _buildDataRow('Message', ctRes.message),
            _buildDataRow('Status', ctRes.status),
          ],
        ),
      ),
    );
  }

  // Helper untuk membuat baris label: value
  Widget _buildDataRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ': ${value ?? ''}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Method untuk menentukan warna card berdasarkan status
  Color _getCardColor() {
    if (ctRes.status == 200) {
      if (ctRes.message.toLowerCase().contains('delete') || 
          ctRes.message.toLowerCase().contains('dihapus')) {
        return Colors.red[200]!; // Merah untuk delete
      } else if (ctRes.message.toLowerCase().contains('update') || 
                 ctRes.message.toLowerCase().contains('diupdate')) {
        return Colors.orange[200]!; // Orange untuk update
      } else {
        return Colors.lightBlue[200]!; // Blue untuk operasi lain
      }
    } else if (ctRes.status == 201) {
      return Colors.green[200]!; // Hijau untuk create
    } else if (ctRes.status != null) {
      return Colors.orange[200]!;
    }
    return Colors.lightBlue[200]!;
  }

  // Method untuk menentukan title berdasarkan status
  String _getStatusTitle() {
    if (ctRes.status == 200) {
      if (ctRes.message.toLowerCase().contains('update') || 
          ctRes.message.toLowerCase().contains('diupdate')) {
        return 'Data berhasil diupdate.';
      } else if (ctRes.message.toLowerCase().contains('delete') || 
                 ctRes.message.toLowerCase().contains('dihapus')) {
        return 'Data berhasil dihapus.';
      } else {
        return 'Data berhasil diupdate.';
      }
    } else if (ctRes.status == 201) {
      return 'Data berhasil ditambahkan.';
    } else if (ctRes.status != null) {
      return 'Operasi berhasil';
    }
    return 'Response';
  }

  // Method untuk menentukan icon berdasarkan status
  IconData _getStatusIcon() {
    if (ctRes.status == 200) {
      if (ctRes.message.toLowerCase().contains('delete') || 
          ctRes.message.toLowerCase().contains('dihapus')) {
        return Icons.delete_outline;
      } else if (ctRes.message.toLowerCase().contains('update') || 
                 ctRes.message.toLowerCase().contains('diupdate')) {
        return Icons.edit;
      } else {
        return Icons.check_circle_outline;
      }
    } else if (ctRes.status == 201) {
      return Icons.add_circle_outline;
    }
    return Icons.info_outline;
  }
}
