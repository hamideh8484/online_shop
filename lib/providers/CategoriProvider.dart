import 'package:flutter/material.dart';
import 'package:online_shop/model/CategoryOfStores.dart';
import 'package:online_shop/services/api_service.dart';

class CategoriesProvider with ChangeNotifier {
  List<HomeCategoryModel> _categories = [];
  bool _isLoading = false;

  List<HomeCategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await ApiService().fetchCategories();
    } catch (e) {
      print("Failed to load categories: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
