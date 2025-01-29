// import 'package:shop/screens/login/data/base_url.dart';

// class ConfirmationService {
//   final ApiService _apiService = ApiService();

//   Future<bool> confirmation(String phoneNumber, String confirmationCode) async {
//     try {
//       final response = await _apiService.dio.post(
//         '/api/auth/verifyCode',
//         data: {'mobile': phoneNumber, 'code': confirmationCode},
//       );
//       print(response);
//       if (response.statusCode == 200) {
//         return response.data['status'].toString() == 'true';
//       } else {
//         return false;
//       }
//     } catch (e) {
//       print('Error: $e');
//       throw 'Error connecting to the server: $e';
//     }
//   }
// }
