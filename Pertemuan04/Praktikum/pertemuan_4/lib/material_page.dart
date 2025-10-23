import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Utama'),
        backgroundColor: Colors.yellowAccent,
        foregroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            ListTile(title: Text('Halaman Utama')),
            ListTile(title: Text('Tentang Halaman')),
          ],
        ),
      ),
      body: const Center(child: BiggestText(text: 'Halo ULBI')),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.yellowAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class Heading extends StatelessWidget {
  final String text;
  const Heading({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
    );
  }
}

class BiggestText extends StatefulWidget {
  final String text;
  const BiggestText({Key? key, required this.text}) : super(key: key);

  @override
  State<BiggestText> createState() => _BiggestTextState();
}

class _BiggestTextState extends State<BiggestText> {
  double _textSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.text, style: TextStyle(fontSize: _textSize)),

        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellowAccent,
            foregroundColor: Colors.black,
          ),
          child: Text(_textSize == 35.0 ? "Perbesar" : "Perkecil"),
          onPressed: () {
            setState(() {
              _textSize = _textSize == 35.0 ? 70.0 : 35.0;
            });
          },
        ),
      ],
    );
  }
}
