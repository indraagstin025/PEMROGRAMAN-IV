import 'package:flutter/material.dart';
import 'package:pertemuan_09/botnav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late SharedPreferences loginData;
  late bool newUser;

  bool rememberMe = false;

  static const Color primaryGreen = Colors.green;
  static const Color lightGreenFill = Color.fromARGB(255, 230, 250, 230);

  @override
  void initState() {
    super.initState();
    checkLogin();
    loadRememberedUsername();
  }

  void loadRememberedUsername() async {
    loginData = await SharedPreferences.getInstance();
    rememberMe = loginData.getBool('rememberMe') ?? false;

    if (rememberMe) {
      _usernameController.text =
          loginData.getString('remembered_username') ?? "";
    }
    setState(() {});
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value != null && value.length < 4) {
      return 'Masukkan minimal 4 karakter';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value != null && value.length < 3) {
      return 'Masukkan minimal 3 karakter';
    }
    return null;
  }

  void checkLogin() async {
    loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('login') ?? true);

    if (newUser == false) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DynamicBottomNavBar()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shared Preference'),
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: _validateUsername,
                      controller: _usernameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.account_circle_rounded,
                          color: primaryGreen,
                        ),
                        hintText: 'Masukkan Username Anda...',
                        labelText: 'Username',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),

                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: primaryGreen, width: 2),
                        ),

                        fillColor: lightGreenFill,
                        filled: true,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      validator: _validatePassword,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.password_rounded,
                          color: primaryGreen,
                        ),
                        hintText: 'Masukkan Password Anda...',
                        labelText: 'Password',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),

                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: primaryGreen, width: 2),
                        ),

                        fillColor: lightGreenFill,
                        filled: true,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                        activeColor: primaryGreen,
                      ),
                      const Text("Ingat Saya"),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        final isValidForm = _formKey.currentState!.validate();

                        String username = _usernameController.text;

                        if (isValidForm) {
                          loginData.setBool('login', false);
                          loginData.setString('username', username);

                          if (rememberMe) {
                            loginData.setBool('rememberMe', true);
                            loginData.setString(
                              'remembered_username',
                              username,
                            );
                          } else {
                            loginData.setBool('rememberMe', false);
                            loginData.remove('remembered_username');
                          }

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DynamicBottomNavBar(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
