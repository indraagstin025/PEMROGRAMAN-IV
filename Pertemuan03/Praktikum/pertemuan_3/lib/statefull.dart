import 'package:flutter/material.dart';

class MyStatefull extends StatefulWidget {
  const MyStatefull({super.key});

  @override
  State<MyStatefull> createState() => _MyStatefullState();
}

class _MyStatefullState extends State<MyStatefull> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(child: Text('Hello, Statefull Widget')),
      ),
    );
  }
}
