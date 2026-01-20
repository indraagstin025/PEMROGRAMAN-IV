import 'package:flutter/material.dart';
import 'package:pertemuan13/model/login_model.dart';
import 'package:pertemuan13/services/api_services.dart';
import 'package:pertemuan13/services/auth_manager.dart';
import 'package:pertemuan13/view/screen/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiServices _dataService = ApiServices();

  @override
  void initState() {
    super.initState();
    checkLogin(); // [cite: 260]
  }

  void checkLogin() async {
    bool isLoggedIn = await AuthManager.isLoggedIn(); // [cite: 261]
    if (isLoggedIn) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()), // [cite: 262]
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose(); // [cite: 133]
    _passwordController.dispose(); // [cite: 134]
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value != null && value.length < 4) {
      return 'Masukkan minimal 4 Karakter'; // [cite: 136]
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value != null && value.length < 3) {
      return 'Masukkan minimal 3 Karakter'; // [cite: 142]
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // [cite: 151]
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login Page')), // [cite: 155]
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // [cite: 161]
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      validator: _validateUsername,
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        hintText: 'Write username here...',
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        fillColor: Color.fromARGB(255, 242, 254, 255),
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      validator: _validatePassword,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password_rounded),
                        hintText: 'Write your password here...',
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        fillColor: Color.fromARGB(255, 242, 254, 255),
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final isValidForm = _formKey.currentState!.validate(); // [cite: 268]
                        if (isValidForm) {
                          final postModel = LoginInput(
                            username: _usernameController.text,
                            password: _passwordController.text,
                          );

                          LoginResponse? res = await _dataService.login(postModel); // [cite: 276]

                          if (res != null && res.status == 200) {
                            // --- BAGIAN CHALLENGE: Mengirim username dan token ---
                            await AuthManager.login(
                              _usernameController.text, 
                              res.token ?? "" // Mengambil token dari response API [cite: 467, 490]
                            );

                            if (!mounted) return;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()), // [cite: 286]
                              (route) => false,
                            );
                          } else {
                            displaySnackBar(res?.message ?? "Login Gagal"); // [cite: 288]
                          }
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

  dynamic displaySnackBar(String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)), // [cite: 216]
    );
  }
}