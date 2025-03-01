import 'package:online_shop/model/product.dart';
import 'package:online_shop/model/product_nature.dart';

class ProductBalanceAttribute {
  final int id;
  final List<dynamic> value;
  final ProductNatureAttribute productNatureAttribute;
  final String? status;

  ProductBalanceAttribute({
    required this.id,
    required this.value,
    required this.productNatureAttribute,
    this.status,
  });

  factory ProductBalanceAttribute.fromJson(Map<String, dynamic> json) {
    var typeId =
        json['productNatureAttribute']['productNatureAttributeType']['id'];

    List<dynamic> parsedValue;
    if (typeId == 1) {
      // اگر نوع مقدار `1` باشد، `value` فقط شامل `name` خواهد بود.
      parsedValue = List<Map<String, dynamic>>.from(json['value'])
          .map((e) => {"name": e["name"]})
          .toList();
    } else if (typeId == 2) {
      // اگر نوع مقدار `2` باشد، `value` شامل `id` و `name` خواهد بود.
      parsedValue = List<Map<String, dynamic>>.from(json['value'])
          .map((e) => {"id": e["id"], "name": e["name"]})
          .toList();
    } else {
      parsedValue = [];
    }

    return ProductBalanceAttribute(
      id: json['id'],
      value: parsedValue,
      productNatureAttribute:
          ProductNatureAttribute.fromJson(json['productNatureAttribute']),
      status: json['status'],
    );
  }
}

class ProductData {
  final Product product;
  final List<ProductBalanceAttribute> productBalanceAttributes;
  final List<Product> relatedProducts;
  final List<Product> similarProducts;

  ProductData({
    required this.product,
    required this.productBalanceAttributes,
    required this.relatedProducts,
    required this.similarProducts,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      product: Product.fromJson(json['product']),
      productBalanceAttributes:
          (json['productBalanceAttributes'] as List<dynamic>?)
                  ?.map((item) => ProductBalanceAttribute.fromJson(item))
                  .toList() ??
              [],
      relatedProducts: (json['relatedProducts'] as List<dynamic>?)
              ?.map((item) => Product.fromJson(item))
              .toList() ??
          [],
      similarProducts: (json['similarProducts'] as List<dynamic>?)
              ?.map((item) => Product.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ProductBalance {
  int id;
  double price;
  String number;
  ProductModel? product;
  Store? store;
  List<ProductBalanceAttribute> productBalanceAttributes;

  ProductBalance({
    required this.id,
    required this.price,
    required this.number,
    required this.product,
    required this.store,
    required this.productBalanceAttributes,
  });

  factory ProductBalance.fromJson(Map<String, dynamic> json) {
    return ProductBalance(
      id: json['id'] ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      number: json['number'] ?? '',
      product: ProductModel.fromJson(json['product'] ?? {}),
      store: Store.fromJson(json['store'] ?? {}),
      productBalanceAttributes: (json['productBalanceAttributes'] as List?)
              ?.map((item) => ProductBalanceAttribute.fromJson(item))
              .toList() ??
          [], // Place this line here
    );
  }
}

class Store {
  final int id;
  final String title;
  final String? address;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final String? mobile;
  final String? phone;
  final String? owner;
  final String? status;

  Store({
    required this.id,
    required this.title,
    this.address,
    this.postalCode, // Nullable
    this.latitude,
    this.longitude,
    this.mobile,
    this.phone,
    this.owner,
    this.status, // Nullable
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      title: json['title'],
      address: json['address'] ?? '',
      postalCode: json['postal_code'] ?? '',
      latitude: (json['latitude'] != null)
          ? double.parse(json['latitude'].toString())
          : 0.0,
      longitude: (json['longitude'] != null)
          ? double.parse(json['longitude'].toString())
          : 0.0,
      mobile: json['mobile'] ?? '',
      phone: json['phone'] ?? '',
      owner: json['owner'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class ProductModel {
  final int? id;
  final String? name;
  final String? productIntroduction;
  final String? minPrice;
  final String? status;

  ProductModel(
      {this.id,
      this.name,
      this.productIntroduction,
      this.minPrice,
      this.status});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      productIntroduction: json['product_introduction'] ?? '',
      minPrice: json['minPrice'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
