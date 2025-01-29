import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_shop/screens/login/data/base_url.dart';

class SendCodeService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> sendCode(String phoneNumber) async {
    try {
      final response = await _apiService.dio.post(
        '/api/auth/sendCode',
        data: {'mobile': phoneNumber},
      );

      print('Server response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200) {
        Map<String, dynamic>? data = response.data['data'];
        String? tempToken = data?['tempToken'];

        if (tempToken != null) {
          // ذخیره توکن موقت
          await saveTempToken(tempToken);
          print('Temporary token saved: $tempToken');
        } else {
          print('Token is null');
        }

        return response.data;
      } else {
        return {
          'status': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error: $e');
      return {'status': false, 'message': 'Error connecting to the server: $e'};
    }
  }
}

Future<void> saveTempToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('tempToken', token); // ذخیره توکن موقت
}

Future<String?> getTempToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('tempToken'); // گرفتن توکن موقت
}

Future<void> removeTempToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('tempToken'); // حذف توکن موقت
}
