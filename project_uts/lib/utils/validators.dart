class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama wajib diisi';
    }

    final nameExp = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Nama tidak boleh mengandung angka atau simbol';
    }

    List<String> words = value.trim().split(' ');
    if (words.length < 2) {
      return 'Nama harus terdiri dari minimal 2 kata';
    }

    for (String word in words) {
      if (word.isNotEmpty && word[0] != word[0].toUpperCase()) {
        return 'Setiap kata harus diawali dengan huruf Kapital';
      }
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon wajib diisi';
    }

    final phoneExp = RegExp(r'^[0-9]+$');
    if (!phoneExp.hasMatch(value)) {
      return 'Nomor telepon harus berupa angka saja';
    }

    if (!value.startsWith('62')) {
      return 'Nomor telepon harus diawali dengan 62';
    }

    if (value.length < 8 || value.length > 13) {
      return 'Nomor telepon harus antara 8 hingga 13 digit';
    }

    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal wajib diisi';
    }
    return null;
  }
}
