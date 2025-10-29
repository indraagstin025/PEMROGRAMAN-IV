import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      backgroundColor: Colors.black,
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(title: Text('Homepage')),
            ListTile(title: Text('Settings')),
            ListTile(title: Text('Edit App')),
            ListTile(title: Text('About')),
          ],
        ),
      ),
      body: MyColumn(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Homepage'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.blue,
      ),
    );
  }
}

class MyContainer extends StatelessWidget {
  const MyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.yellowAccent,
        shape: BoxShape.circle,
      ),
      // color: Colors.blueAccent,
      // width: 200,
      // height: 100,
      padding: EdgeInsets.only(top: 20, left: 20),
      margin: EdgeInsets.all(20),
      child: Text('Hai', style: TextStyle(fontSize: 30)),
    );
  }
}

class MyPadding extends StatelessWidget {
  const MyPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(40), child: Text('Ini Padding'));
  }
}

class MySizedBox extends StatelessWidget {
  const MySizedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halaman',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 20),
        Text(
          'Universitas Logistik dan Bisnis Internasional',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class MyRow extends StatelessWidget {
  const MyRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.share),
            Icon(Icons.thumb_up),
            Icon(Icons.thumb_down),
          ],
        ),
      ],
    );
  }
}

class MyColumn extends StatelessWidget {
  const MyColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('MainAxisAlignment.spaceEvenly'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.share),
            Icon(Icons.thumb_up),
            Icon(Icons.thumb_down),
          ],
        ),
        SizedBox(height: 40),
        Text('MainAxisAligment.spaceArround'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.share),
            Icon(Icons.thumb_up),
            Icon(Icons.thumb_down),
          ],
        ),
        SizedBox(height: 40),
        Text('MainAxisAlignment.spaceBetween'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.share),
            Icon(Icons.thumb_up),
            Icon(Icons.thumb_down),
          ],
        ),
        SizedBox(height: 40),
        Text('MainAxisAlignment.start'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.share),
            Icon(Icons.thumb_up),
            Icon(Icons.thumb_down),
          ],
        ),
        SizedBox(height: 40),
        Text('MainAxisAlignment.center'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.share),
            Icon(Icons.thumb_up),
            Icon(Icons.thumb_down),
          ],
        ),
        SizedBox(height: 40),
        Text('MainAxisAlignment.end'),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.share),
            Icon(Icons.thumb_up),
            Icon(Icons.thumb_down),
          ],
        ),
      ],
    );
  }
}
