import 'package:flutter/material.dart';
import '/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //ใช้เพื่อ ปิดแถบ Debug Banner ที่มุมขวาบนของแอป
      title: 'TestLogin',  //กำหนดชื่อของแอป (อาจแสดงใน Task Manager ของมือถือ)
      home: const LoginPage(),
    );
  }
}
  