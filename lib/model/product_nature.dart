class ProductNatureAttribute {
  final int id;
  final String name;
  final String description;
  final ProductNatureAttributeType productNatureAttributeType;
  final List<ProductNatureAttributeItem> productNatureAttributeItems;
  final String status;

  ProductNatureAttribute({
    required this.id,
    required this.name,
    required this.description,
    required this.productNatureAttributeType,
    required this.productNatureAttributeItems,
    required this.status,
  });

  factory ProductNatureAttribute.fromJson(Map<String, dynamic> json) {
    return ProductNatureAttribute(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      productNatureAttributeType: json['productNatureAttributeType'] != null
          ? ProductNatureAttributeType.fromJson(
              json['productNatureAttributeType'])
          : ProductNatureAttributeType(
              id: 0, name: '', status: ''), // مقدار پیش‌فرض در صورت `null`
      productNatureAttributeItems:
          (json['productNatureAttributeItems'] as List<dynamic>? ?? [])
              .map((item) => ProductNatureAttributeItem.fromJson(item))
              .toList(),
      status: json['status'] ?? '',
    );
  }
}

class ProductNatureAttributeItem {
  final int id;
  final String name;

  ProductNatureAttributeItem({
    required this.id,
    required this.name,
  });

  factory ProductNatureAttributeItem.fromJson(Map<String, dynamic> json) {
    return ProductNatureAttributeItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class ProductBalanceAttribute {
  final int id;
  final List<dynamic> value;
  final ProductNatureAttribute productNatureAttribute;
  final String status;

  ProductBalanceAttribute({
    required this.id,
    required this.value,
    required this.productNatureAttribute,
    required this.status,
  });

  factory ProductBalanceAttribute.fromJson(Map<String, dynamic> json) {
    return ProductBalanceAttribute(
      id: json['id'] ?? 0, // Default to 0 if id is null
      value: json['value'] != null
          ? List<dynamic>.from(json['value'])
          : [], // Default to an empty list if value is null
      productNatureAttribute:
          ProductNatureAttribute.fromJson(json['productNatureAttribute'] ?? {}),
      status:
          json['status'] ?? '', // Default to an empty string if status is null
    );
  }
}

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'status': status,
//     };
//   }
// }

// }
class ProductNatureAttributeType {
  final int id;
  final String name;
  final String status;

  ProductNatureAttributeType({
    required this.id,
    required this.name,
    required this.status,
  });

  factory ProductNatureAttributeType.fromJson(Map<String, dynamic> json) {
    return ProductNatureAttributeType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class StoreType {
  final int id;
  final String name;
  final String? status;

  StoreType({
    required this.id,
    required this.name,
    this.status,
  });

  factory StoreType.fromJson(Map<String, dynamic> json) {
    return StoreType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status']?.toString(),
    );
  }
}

class ProductNatureModel {
  final int id;
  final String name;
  final String? logo;
  final List<ProductNatureAttribute> productNatureAttributes;
  final StoreType storeType;
  final String status;

  ProductNatureModel({
    required this.id,
    required this.name,
    this.logo,
    required this.productNatureAttributes,
    required this.storeType,
    required this.status,
  });

  factory ProductNatureModel.fromJson(Map<String, dynamic> json) {
    var attributesFromJson = json['productNatureAttributes'] ?? [];
    List<ProductNatureAttribute> attributesList = (attributesFromJson as List)
        .map((i) => ProductNatureAttribute.fromJson(i))
        .toList();

    return ProductNatureModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logo: json['logo']?['path'], // Ensure logo is being correctly parsed
      productNatureAttributes: attributesList,
      storeType: StoreType.fromJson(json['storeType'] ?? {}),
      status: json['status']?.toString() ?? '',
    );
  }
}
