import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyShared extends StatefulWidget {
  const MyShared({super.key});
  @override
  State<MyShared> createState() {
    return _MySharedState();
  }
}

class _MySharedState extends State<MyShared> {
  late SharedPreferences prefs;
  final TextEditingController _dataAja = TextEditingController();
  String name = "";

  @override
  void dispose() {
    _dataAja.dispose();
    super.dispose();
  }

  save() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('Inidata', _dataAja.text);
    _dataAja.text = "";
  }

  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('Inidata') ?? "";
    setState(() {});
  }

  delete() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('Inidata');
    name = "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 🌿 background hijau muda
      appBar: AppBar(
        title: const Text("Shared Preferences"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _dataAja,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
                hintText: "Masukkan sesuatu",
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Simpan"),
              onPressed: save,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: TextEditingController(text: name),
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
                hintText: "Hasil data",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Get Value"),
              onPressed: retrieve,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Delete Value"),
              onPressed: delete,
            ),
          ],
        ),
      ),
    );
  }
}
