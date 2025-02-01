import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000"; // Android Emulator

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/addlogin");

    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> body = {"username": username, "password": password};

    log(">> ก่อนส่ง Request:");
    log(">> Headers: ${jsonEncode(headers)}");
    log(">> Body (JSON): ${jsonEncode(body)}");

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      log(">> สถานะการตอบกลับ: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("✅ ข้อมูลที่ได้รับ: $data");
        return data;
      } else {
        try {
          // 🔹 แปลง Error เป็น JSON และดึงข้อความ error
          final errorData = jsonDecode(response.body);
          return {
            "error": errorData["error"] ?? "เกิดข้อผิดพลาด"
          };
        } catch (e) {
          return {
            "error": response.body
          };
        }
      }
    } catch (e) {
      log("❌ Exception Caught: $e");
      return {
        "error": "เชื่อมต่อไม่ได้",
        "message": e.toString()
      };
    }
  }
}
