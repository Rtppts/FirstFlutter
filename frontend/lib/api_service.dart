import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer'; // ต้อง Import เพิ่ม

class ApiService {
  // 🔹 เลือก Base URL ให้ถูกต้อง
  // Google กำหนดให้ 10.0.2.2 เป็น alias สำหรับ localhost ของเครื่องแม่ (Host Machine)
  static const String baseUrl = "http://10.0.2.2:8000"; // Android Emulator
  // static const String baseUrl = "http://127.0.0.1:8000"; // iOS Emulator
  // static const String baseUrl = "http://<Your_PC_IP>:8000"; // มือถือจริง

  static Future<String> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/addlogin");

    // 🔹 สร้าง Object ที่จะถูกส่งไป
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> body = {"username": username, "password": password};

    // 🔹 แสดง Object ทั้งก้อนก่อนส่ง (Request)
    log(">>ก่อนส่ง:");
    log(">>Headers: ${jsonEncode(headers)}");
    log(">>Body (JSON): ${jsonEncode(body)}");

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body), // 🔹 แปลงเป็น JSON ก่อนส่ง
      );

      // 🔹 แสดง Response ที่ได้รับ
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("ข้อมูลที่รับมา  $data");
        return data["products"] ?? "ไม่พบข้อมูล";
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      log("❌ Error: $e");
      return "เชื่อมต่อไม่ได้: $e";
    }
  }
}
