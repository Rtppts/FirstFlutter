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
  String _errorMessage = "";

  void _handleLogin() async {
    String username = _username.text;
    String password = _password.text;

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
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(   //Widget ที่ช่วยให้เลื่อน (Scroll) ได้ เมื่อเนื้อหาเยอะเกินขนาดหน้าจอ
          padding: const EdgeInsets.symmetric(horizontal: 32),  //ระยะห่างภายใน (Padding) ด้านซ้าย-ขวา   vertical: บน-ล่าง 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 โลโก้ / ชื่อแอป
              const Text(
                "Sample App",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Login Page",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Sign in",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // 🔹 ช่องใส่ Username
              TextField(
                controller: _username,   //มี _ เพราะเป็นตัวแปร Private ใน Dart ถ้าตัวแปรขึ้นต้นด้วย _ จะ ใช้ได้แค่ภายในไฟล์เดียวกัน
                decoration: InputDecoration(
                  labelText: "UserName",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),

              // 🔹 ช่องใส่ Password
              TextField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),

              // 🔹 Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Add Forgot Password Function
                  },
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(color: Colors.blue),
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
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 แสดง Error ถ้า Login ไม่สำเร็จ
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),

              const SizedBox(height: 20),

              // 🔹 ลิงก์ไปหน้าสมัครสมาชิก
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Does not have account?"),
                  TextButton(
                    onPressed: () {
                      // TODO: Add Sign Up Function
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
