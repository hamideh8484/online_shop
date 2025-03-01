import 'package:online_shop/model/product_nature.dart';

final homePopularCategories = [
  PopularCategory(category: 'All', id: '1'),
  PopularCategory(category: 'Chair', id: '2'),
  PopularCategory(category: 'Kitchen', id: '3'),
  PopularCategory(category: 'Table', id: '4'),
  PopularCategory(category: 'Lamp', id: '5'),
  PopularCategory(category: 'Cupboard', id: '6'),
  PopularCategory(category: 'Vase', id: '7'),
  PopularCategory(category: 'Others', id: '8'),
];

class PopularCategory {
  final String category;
  final String id;

  PopularCategory({this.category = '', this.id = ''});
}

class ProductFeatureValue {
  final int id;
  final List<FeatureValue> value;
  final ProductNatureAttribute productNatureAttribute;
  final String status;

  ProductFeatureValue({
    required this.id,
    required this.value,
    required this.productNatureAttribute,
    required this.status,
  });

  factory ProductFeatureValue.fromJson(Map<String, dynamic> json) {
    return ProductFeatureValue(
      id: json['id'] ?? 0,
      value: (json['value'] as List<dynamic>?)
              ?.map((item) => FeatureValue.fromJson(item))
              .toList() ??
          [],
      productNatureAttribute:
          ProductNatureAttribute.fromJson(json['productNatureAttribute'] ?? {}),
      status: json['status'] ?? '',
    );
  }
}

class FeatureValue {
  final int id;
  final String name;

  FeatureValue({required this.id, required this.name});

  factory FeatureValue.fromJson(Map<String, dynamic> json) {
    return FeatureValue(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Product {
  int id;
  String name;
  String? productIntroduction;
  String? minPrice;
  ProductNature productNature;
  BrandProduct brand;
  List<ProductFeatureValue> productFeatureValues;
  List<FileModel> files;
  final String? status;

  Product({
    required this.id,
    required this.name,
    this.productIntroduction,
    this.minPrice,
    required this.productNature,
    required this.brand,
    required this.productFeatureValues,
    required this.files,
    this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      productIntroduction: json['product_introduction'] ?? '',
      minPrice: json['minPrice'] ?? '',
      productNature: ProductNature.fromJson(json['productNature'] ?? {}),
      brand: BrandProduct.fromJson(json['brand'] ?? {}),
      productFeatureValues: (json['productFeatureValues'] as List<dynamic>?)
              ?.map((item) => ProductFeatureValue.fromJson(item))
              .toList() ??
          [],
      files: (json['files'] as List)
          .map((item) => FileModel.fromJson(item))
          .toList(),
      status: json['status'] ?? '',
    );
  }
}

class FileModel {
  final int id;
  final String path;
  final int size;
  final String mimeType;
  final String type;

  FileModel({
    required this.id,
    required this.path,
    required this.size,
    required this.mimeType,
    required this.type,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      path: json['path'] ?? '',
      size: json['size'] is int
          ? json['size']
          : int.tryParse(json['size'].toString()) ?? 0,
      mimeType: json['mime_type'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class ProductNature {
  final int id;
  final String name;
  final String? status;

  ProductNature({
    required this.id,
    required this.name,
    this.status,
  });

  factory ProductNature.fromJson(Map<String, dynamic> json) {
    return ProductNature(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}

class BrandProduct {
  final int id;
  final String name;
  final String? status;

  BrandProduct({
    required this.id,
    required this.name,
    this.status,
  });

  factory BrandProduct.fromJson(Map<String, dynamic> json) {
    return BrandProduct(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}

class AttributeSet {
  final int id;
  final List<String> values;

  AttributeSet({required this.id, required this.values});

  factory AttributeSet.fromJson(Map<String, dynamic> json) {
    List<String> extractedValues = [];

    if (json['value'] is List) {
      extractedValues = (json['value'] as List)
          .map((item) => item['name'].toString())
          .toList();
    }

    return AttributeSet(
      id: json['id'] ?? 0,
      values: extractedValues,
    );
  }
}

class AttributeValue {
  final int id;
  final String value;

  AttributeValue({required this.id, required this.value});

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    List<dynamic>? valueList = json['value'];

    return AttributeValue(
      id: json['id'] ?? 0,
      value: (valueList != null && valueList.isNotEmpty)
          ? valueList[0]['name'].toString()
          : '',
    );
  }
}

dynamic parseProductFeature(Map<String, dynamic> json) {
  if (json['productNatureAttribute'] == null ||
      json['productNatureAttribute']['productNatureAttributeType'] == null) {
    return null; // جلوگیری از کرش شدن برنامه در صورت نبودن اطلاعات
  }

  int typeId =
      json['productNatureAttribute']['productNatureAttributeType']['id'];

  if (typeId == 2) {
    // نوع مجموعه
    return AttributeSet.fromJson(json);
  } else if (typeId == 1) {
    // نوع مقدار
    return AttributeValue.fromJson(json);
  }
  return null; // در صورتی که نوع معتبر نباشد، مقدار null باز می‌گرداند
}
