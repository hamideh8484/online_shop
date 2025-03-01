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
      final List<dynamic> jsonResponse = response.data['data'];
      print(jsonResponse);
      return jsonResponse.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load product natures');
    }
  }

  Future<ProductData> fetchProductById(int id) async {
    final response =
        await dio.get('/api/admin/membership/product/productDetail/$id');

    if (response.statusCode == 200) {
      return ProductData.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response = await dio.get(
      '/api/admin/membership/product/product/',
      queryParameters: {
        'product_nature_id': categoryId,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = response.data['data'];
      print(categoryId);
      print(jsonResponse);
      return jsonResponse.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  Future<ProductData> fetchDeclarationOfInventory(int id) async {
    final response =
        await dio.get('/api/admin/membership/productBalance/show/$id');

    if (response.statusCode == 200) {
      return ProductData.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<ProductBalance> fetchProductBalance(int id) async {
    try {
      final response = await dio.get(
        '/api/admin/membership/productBalance/productBalanceAttribute/',
        queryParameters: {'product_id': id},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        print('اعلام موجودی: ${data.toString()}');

        if (data != null && data.containsKey('productBalances')) {
          var productBalances = data['productBalances'];

          // بررسی اینکه آیا مقدار productBalances یک لیست است یا خیر
          if (productBalances is List) {
            print('ProductBalances is a List: $productBalances');
            return ProductBalance.fromJson(
                {'productBalances': productBalances});
          }
          // بررسی اینکه آیا مقدار یک String است
          else if (productBalances is String) {
            print('ProductBalances is a String: $productBalances');
            return ProductBalance.fromJson(
                {'productBalances': []}); // مقدار پیش‌فرض
          }
          // اگر مقدار نه لیست باشد و نه رشته، خطا بدهد
          else {
            throw Exception(
                'Unexpected type for productBalances: ${productBalances.runtimeType}');
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
