import 'package:flutter/material.dart';
import 'package:pertemuan_12/view/screen/home_page.dart';

void main() {
  runApp(const P12App());
}

class P12App extends StatelessWidget {
  const P12App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Pemrograman Mobile - P12',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),

      home: const HomePage(),
    );
  }
}
