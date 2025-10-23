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
      body: Center(child: Text('Hello World')),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Homepage'
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit), 
            label: 'Edit'
            ),
        ],
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.blue,
      ),
    );
  }
}
