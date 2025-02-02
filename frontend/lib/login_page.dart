import 'dart:convert';
import 'package:flutter/material.dart';
import '/api_service.dart';
import '/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isPasswordVisible = false;

  void _handleLogin() async {
    String username = _username.text;
    String password = _password.text;

    Map<String, dynamic> response = await ApiService.login(username, password);

    if (response.containsKey("message")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePage(message: response["message"].toString()),
        ),
      );
    } else {
      try {
        // 🔹 ตรวจสอบว่า response["error"] เป็น JSON หรือไม่
        final errorData = jsonDecode(response["error"]);
        String errorMessage =
            errorData is Map<String, dynamic> && errorData.containsKey("error")
                ? errorData["error"]
                : response["error"];

        showErrorDialog(errorMessage); // 🔹 แสดง Popup แจ้งเตือน
      } catch (e) {
        showErrorDialog(response["error"] ?? "เกิดข้อผิดพลาด");
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("แจ้งเตือน"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Popup
              },
              child: const Text("ตกลง"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // จัดให้อยู่ตรงกลาง
                children: [
                    const Text(
                    "Mini",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 50,
                      fontWeight: FontWeight.w700, // น้ำหนักเป็นเลข
                      color: Color(0xFF000000),
                    ),
                    ),

                  const SizedBox(width: 12),

                  const Text(
                    "Shop",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontWeight: FontWeight.w700,
                      fontSize: 50,
                      color: Color.fromARGB(255, 255, 198, 0),
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 50),

              // 🔹 ช่องใส่ Username
                TextField(
                controller: _username,
                decoration: InputDecoration(
                  labelText: "UserName",
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Prompt',
                  fontWeight: FontWeight.w400), // ปรับขนาดตัวอักษรและฟอนต์
                ),

              const SizedBox(height: 25),

              // 🔹 ช่องใส่ Password พร้อมปุ่มแสดง/ซ่อนรหัสผ่าน
              TextField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,

                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Prompt',
                  fontWeight: FontWeight.w400,
                ), // ปรับขนาดตัวอักษรและฟอนต์
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Add Forgot Password Function
                  },
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 ปุ่ม Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 198, 0),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 23, 
                      color: Colors.black,
                      fontFamily: 'Prompt',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              
                GestureDetector(
                onTap: () {
                  // TODO: Add Google Sign-In Function
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10), // ขนาด padding
                  decoration: BoxDecoration(
                    color: Colors.white, // พื้นหลังสีขาว
                    borderRadius: BorderRadius.circular(20), // มุมมน
                    border: Border.all(
                        color: Colors.black, width: 1), // เส้นขอบสีดำ
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // ให้ขนาดพอดีกับเนื้อหา
                    children: [
                      Image.asset('assets/google.png',
                          width: 28), // ไอคอน Google
                      SizedBox(width: 10), // ระยะห่างระหว่างไอคอนกับข้อความ
                      Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Prompt',
                          fontWeight: FontWeight.w500,
                        ), // ข้อความ
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
