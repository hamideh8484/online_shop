import 'package:flutter/material.dart';
import 'package:online_shop/model/product_nature.dart';
import 'package:online_shop/services/api_service.dart';

class ProductNatureProvider with ChangeNotifier {
  List<ProductNatureModel> _productNature = [];
  bool _isLoading = false;

  List<ProductNatureModel> get productNature => _productNature;
  bool get isLoading => _isLoading;

  Future<void> fetchProductNature() async {
    _isLoading = true;
    notifyListeners();

    try {
      _productNature = await ApiService().fetchProductNature();
    } catch (e) {
      print("Failed to load product nature: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
