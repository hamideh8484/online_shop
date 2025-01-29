import 'package:flutter/material.dart';
import 'package:online_shop/screens/login/data/base_url.dart';
import 'package:online_shop/model/Stores.dart';

class StoresProvider with ChangeNotifier {
  List<StoresModel> _stores = [];
  bool _isLoading = false;

  List<StoresModel> get stores => _stores;
  bool get isLoading => _isLoading;

  Future<void> fetchStores() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stores = await ApiService().fetchIndexShop();
    } catch (e) {
      print('Error fetching stores: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
