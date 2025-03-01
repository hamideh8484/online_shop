import 'package:dio/dio.dart';
import 'package:online_shop/model/Stores.dart';
import 'package:online_shop/model/CategoryOfStores.dart';
import 'package:online_shop/model/product.dart';
import 'package:online_shop/model/product_balance.dart';
import 'package:online_shop/model/product_nature.dart';
import 'package:online_shop/screens/login/data/login.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.111:83';

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
            print('Token: $token');
          } else {
            print('No token found');
          }
        }

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

  Future<List<HomeCategoryModel>> fetchCategories() async {
    final response = await dio.get('/api/admin/membership/storeType');

    if (response.statusCode == 200) {
      final List jsonResponse = response.data['data'];
      return jsonResponse.map((e) => HomeCategoryModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<ProductNatureModel>> fetchProductNature() async {
    final response = await dio.get('/api/admin/membership/productNature');

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = response.data['data'];
      return jsonResponse.map((e) => ProductNatureModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load product natures');
    }
  }

  Future<List<Product>> fetchProduct() async {
    final response = await dio.get('/api/admin/membership/product');

    if (response.statusCode == 200) {
      print(response.data);
      final List<dynamic> jsonResponse = response.data['data'];
      return jsonResponse.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<ProductData> fetchProductById(int id) async {
    try {
      final response =
          await dio.get('/api/admin/membership/product/productDetail/$id');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        print('جزییات کالا :$data');
        if (data != null) {
          return ProductData.fromJson(data);
        } else {
          throw Exception('Product data is null');
        }
      } else {
        throw Exception('Failed to load product');
      }
    } catch (error) {
      throw Exception('Failed to fetch product: $error');
    }
  }

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response = await dio.get(
      '/api/admin/membership/product',
      queryParameters: {
        'product_nature_id': categoryId,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = response.data['data'];
      return jsonResponse.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  Future<List<ProductBalance>> fetchProductBalance(int id) async {
    try {
      final response = await dio.get(
        '/api/admin/membership/productBalance/',
        queryParameters: {'product_id': id},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        print('Received data: ${response.data}');

        if (data == null) {
          throw Exception('Response data is null');
        }

        if (data.containsKey('productBalances')) {
          var productBalances = data['productBalances'];

          if (productBalances is List) {
            print('اعلام موجودی مقادیرش');
            print(productBalances);
            return productBalances
                .map((item) => ProductBalance.fromJson(item))
                .toList();
          } else {
            return [];
          }
        } else {
          throw Exception('Product data is not in the expected format');
        }
      } else {
        throw Exception(
            'Failed to load product: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (error) {
      throw Exception('Failed to fetch product: $error');
    }
  }
}
