// model/contact_model.dart
class ContactsModel {
  final String id;
  final String namaKontak;
  final String nomorHp;

  ContactsModel({
    required this.id,
    required this.namaKontak,
    required this.nomorHp,
  });

  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    // support multiple id shapes (id, _id, _id.$oid)
    String idVal = '';
    if (json.containsKey('id') && json['id'] != null) {
      idVal = json['id'].toString();
    } else if (json.containsKey('_id') && json['_id'] != null) {
      final idData = json['_id'];
      if (idData is String) {
        idVal = idData;
      } else if (idData is Map && idData.containsKey('\$oid')) {
        idVal = idData['\$oid'].toString();
      } else {
        idVal = idData.toString();
      }
    }

    return ContactsModel(
      id: idVal,
      namaKontak: (json['nama_kontak'] ?? json['namaKontak'] ?? json['nama'] ?? '') as String,
      nomorHp: (json['nomor_hp'] ?? json['nomorHp'] ?? json['nomor'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_kontak': namaKontak,
      'nomor_hp': nomorHp,
    };
  }
}

class ContactInput {
  final String namaKontak;
  final String nomorHp;

  ContactInput({
    required this.namaKontak,
    required this.nomorHp,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama_kontak': namaKontak,
      'nomor_hp': nomorHp,
    };
  }
}

class ContactResponse {
  final dynamic status;
  final String message;
  final dynamic insertedId;

  ContactResponse({
    required this.status,
    required this.message,
    this.insertedId,
  });

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    // response structure may vary; try robust extraction
    dynamic status = json['status'] ?? json['meta'] ?? 200;
    String message = '';
    
    // Extract message from various possible fields
    if (json.containsKey('message')) {
      message = json['message'].toString();
    } else if (json.containsKey('msg')) {
      message = json['msg'].toString();
    } else if (json.containsKey('data') && json['data'] is Map) {
      final data = json['data'];
      if (data.containsKey('message')) {
        message = data['message'].toString();
      } else if (data.containsKey('msg')) {
        message = data['msg'].toString();
      }
    }
    
    // Default message if none found
    if (message.isEmpty) {
      message = 'Operation completed';
    }
    
    dynamic insertedId;
    if (json.containsKey('insertedId')) {
      insertedId = json['insertedId'];
    } else if (json.containsKey('data')) {
      final d = json['data'];
      if (d is Map && d.containsKey('insertedId')) {
        insertedId = d['insertedId'];
      } else if (d is Map && d.containsKey('id')) {
        insertedId = d['id'];
      }
    }

    return ContactResponse(
      status: status,
      message: message,
      insertedId: insertedId,
    );
  }
}
