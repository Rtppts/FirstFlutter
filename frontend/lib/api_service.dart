import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 🔹 เลือก Base URL ให้ถูกต้อง
  // Google กำหนดให้ 10.0.2.2 เป็น alias สำหรับ localhost ของเครื่องแม่ (Host Machine)
  static const String baseUrl = "http://10.0.2.2:8000"; // Android Emulator
  // static const String baseUrl = "http://127.0.0.1:8000"; // iOS Emulator
  // static const String baseUrl = "http://<Your_PC_IP>:8000"; // มือถือจริง

  static Future<String> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/addlogin");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["products"] ?? "ไม่พบข้อมูล";
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "เชื่อมต่อไม่ได้: $e";
    }
  }
}
