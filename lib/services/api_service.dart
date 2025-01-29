import 'package:dio/dio.dart';
import 'package:online_shop/model/Stores.dart';
import 'package:online_shop/screens/login/data/login.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.201:83';

  final Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 50),
    receiveTimeout: const Duration(seconds: 50),
  ));

  ApiService() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        const noAuthEndpoints = [
          '/api/auth/sendCode',
          '/api/auth/verifyCode',
        ];

        bool requiresAuth =
            !noAuthEndpoints.any((endpoint) => options.path.endsWith(endpoint));

        if (requiresAuth) {
          final token = await getToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print('Token: $token'); // چاپ توکن
          } else {
            print('No token found');
          }
        }

        print('Request Headers: ${options.headers}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        return handler.next(e);
      },
    ));
  }

  Future<List<StoresModel>> fetchIndexShop() async {
    final response = await dio.get('/api/admin/membership/store');

    if (response.statusCode == 200) {
      List jsonResponse = response.data['data'];
      return jsonResponse.map((offer) => StoresModel.fromJson(offer)).toList();
    } else {
      throw Exception('Failed to load special offers');
    }
  }
}
