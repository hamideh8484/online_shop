import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_shop/screens/login/data/send_code.dart';

Future<bool> sendCodeAndLogin(String tempToken, String code) async {
  final uri = Uri.parse('http://192.168.1.111:83/api/auth/verifyCode');

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': tempToken, 'code': code}),
    );
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      bool status = responseData['status'].toString() == 'true';

      if (status) {
        Map<String, dynamic>? data = responseData['data'];
        String? authToken = data?['token'];

        if (authToken != null) {
          await saveToken(authToken);
          await removeTempToken();
        } else {
          print('Token is null');
        }
      }

      return status;
    } else {
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> removeToken() async {
  print(getToken());
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}
