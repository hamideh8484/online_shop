class HomeCategoryModel {
  const HomeCategoryModel({
    required this.icon,
    required this.title,
    required this.id,
    required this.productGroupTypes,
  });

  final String icon;
  final String title;
  final String id;
  final List<dynamic> productGroupTypes;

  static const Map<String, String> categoryIcons = {
    'پوشاک': 'assets/icons/clothes.png',
    'موبایل': 'assets/icons/mobile.png',
    'سوپر مارکت': 'assets/icons/market.png',
    'لوازم خانگی': 'assets/icons/home-appliance.png',
  };

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    final title = json['name'] ?? '';
    final icon = categoryIcons[title] ?? 'assets/icons/default.png';
    return HomeCategoryModel(
      icon: icon,
      title: title,
      id: json['id'].toString(),
      productGroupTypes: json['productGroupTypes'] ?? [],
    );
  }
}

List<HomeCategoryModel> parseHomeCategories(Map<String, dynamic> json) {
  final List<Map<String, dynamic>> data =
      List<Map<String, dynamic>>.from(json['data'] ?? []);
  return data.map((item) => HomeCategoryModel.fromJson(item)).toList();
}
