import 'package:flutter/material.dart';

class ContactModel {
  String fullName;
  String phoneNumber;
  DateTime date;
  Color color;
  String? filePath;

  ContactModel({
    required this.fullName,
    required this.phoneNumber,
    required this.date,
    required this.color,
    this.filePath,
  });
}
