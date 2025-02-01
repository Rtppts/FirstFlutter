import 'package:flutter/material.dart';
import '/api_service.dart';
import '/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = "";

  void _handleLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    String responseMessage = await ApiService.login(username, password);

    if (responseMessage != "เชื่อมต่อไม่ได้") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(message: responseMessage),
        ),
      );
    } else {
      setState(() {
        _errorMessage = "เชื่อมต่อ Backend ไม่ได้!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text("Login"),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
