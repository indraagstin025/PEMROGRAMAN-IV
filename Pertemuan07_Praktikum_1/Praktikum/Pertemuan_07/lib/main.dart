import 'package:flutter/material.dart';
import 'bottom_navbar.dart';
import 'input_validation.dart';
import 'advanced_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: false),
      home: const AdvancedForm(),
    );
  }
}

class MyInput extends StatefulWidget {
  const MyInput({super.key});

  @override
  State<MyInput> createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  TextEditingController _controller = TextEditingController();

  bool lightOn = false;

  bool agree = false;

  String? language;

  void showRadioSnackbar() {
    if (language != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You selected: $language'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void showCheckboxSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          agree
              ? 'You agreed to the terms and conditions'
              : 'You disagreed with the terms',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Widget')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Write your name here...',
                labelText: 'Your Name',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Hello ${_controller.text}'),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            Switch(
              value: lightOn,
              onChanged: (bool value) {
                setState(() {
                  lightOn = value;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(lightOn ? 'Light On' : 'Light Off'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('Dart'),
                  value: 'Dart',
                  groupValue: language,
                  onChanged: (String? value) {
                    setState(() {
                      language = value;
                      showRadioSnackbar();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Kotlin'),
                  value: 'Kotlin',
                  groupValue: language,
                  onChanged: (String? value) {
                    setState(() {
                      language = value;
                      showRadioSnackbar();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Swift'),
                  value: 'Swift',
                  groupValue: language,
                  onChanged: (String? value) {
                    setState(() {
                      language = value;
                      showRadioSnackbar();
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            CheckboxListTile(
              title: const Text('I agree to the terms and conditions'),
              value: agree,
              onChanged: (bool? value) {
                setState(() {
                  agree = value ?? false;
                  showCheckboxSnackbar();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicBottomNavbar extends StatefulWidget {
  const DynamicBottomNavbar({super.key});

  @override
  State<DynamicBottomNavbar> createState() => _DynamicBottomNavbarState();
}

class _DynamicBottomNavbarState extends State<DynamicBottomNavbar> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = <Widget>[const MyInput(), const MyInput()];

  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPageIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            label: 'Latihan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.input_outlined),
            label: 'Form Validation',
          ),
        ],
        backgroundColor: Colors.green,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
