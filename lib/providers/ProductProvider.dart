import 'package:flutter/material.dart';
import 'package:online_shop/model/product.dart';
import 'package:online_shop/model/product_balance.dart';
import 'package:online_shop/services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _product = [];
  ProductData? _selectedProduct;
  Map<int, List<ProductBalance>> _productBalances = {};
  final List<String> _inventoryOptions = [];
  bool _isLoading = false;
  int? _selectedOption; // Change this to int?
  double _totalPrice = 0.0;
  double _selectedOptionPrice = 0.0;

  Map<String, bool> _loadingStatus = {};

  double get selectedOptionPrice => _selectedOptionPrice;

  List<Product> get product => _product;
  ProductData? get selectedProduct => _selectedProduct;
  List<String> get inventoryOptions => _inventoryOptions;
  bool get isLoading => _isLoading;
  int? get selectedOption => _selectedOption;
  double get totalPrice => _totalPrice;

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  bool isProductBalanceLoading(String productId) {
    return _loadingStatus[productId] ?? false;
  }

  void clearProducts() {
    _product = [];
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _setLoading(true);
    await _fetchData(() async {
      final fetchedProducts = await ApiService().fetchProduct();
      if (fetchedProducts.isNotEmpty) {
        _product = fetchedProducts;
        notifyListeners();
      }
    });
  }

  List<ProductBalance> getProductBalanceByProductId(int productId) {
    return _productBalances[productId] ?? [];
  }

  Future<void> fetchProductById(int id) async {
    _setLoading(true);
    await _fetchData(() async {
      final fetchedProduct = await ApiService().fetchProductById(id);
      if (fetchedProduct != null) {
        _selectedProduct = fetchedProduct;
        notifyListeners();
      }
    });
  }

  Future<void> fetchProductBalance(int productId) async {
    String productIdStr = productId.toString();

    if (_loadingStatus[productIdStr] == true) return;

    _loadingStatus[productIdStr] = true;
    notifyListeners();

    try {
      final productBalances = await ApiService().fetchProductBalance(productId);
      _productBalances[productId] = productBalances ?? [];

      _updateTotalPrice(productId);
    } catch (error) {
      _productBalances[productId] = [];
      print('Error fetching product balance: $error');
    } finally {
      _loadingStatus[productIdStr] = false;
      notifyListeners();
    }
  }

  void setSelectedOption(String optionId, double price) {
    _selectedOption = int.tryParse(optionId); // Store the value as int
    _selectedOptionPrice = price;
    notifyListeners(); // Update listeners
  }

  void _updateTotalPrice(int productId) {
    List<ProductBalance> balances = _productBalances[productId] ?? [];

    // اگر لیست خالی است، هیچ کاری انجام ندهیم
    if (balances.isEmpty) {
      return;
    }

    // یافتن موجودی که در حال حاضر انتخاب شده است
    final selectedBalance = balances.firstWhere(
      (balance) =>
          balance.id == productId, // فرض بر این است که id همان id محصول است
      orElse: () => ProductBalance(
        id: productId,
        price: 0.0,
        number: '0', // مقدار پیش‌فرض برای تعداد
        product: null, // مقدار پیش‌فرض برای محصول
        store: null, // مقدار پیش‌فرض برای فروشگاه
        productBalanceAttributes: [], // لیست خالی برای ویژگی‌های موجودی
      ), // شیء پیش‌فرض با قیمت 0.0
    );

    // بروزرسانی قیمت با استفاده از موجودی انتخاب شده
    _totalPrice = selectedBalance.price;

    // اطلاع‌رسانی به تغییرات
    notifyListeners();
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    _setLoading(true);
    clearProducts();
    await _fetchData(() async {
      final fetchedProducts =
          await ApiService().fetchProductsByCategory(categoryId);
      if (fetchedProducts.isNotEmpty) {
        _product = fetchedProducts;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchData(Future<void> Function() fetchFunction) async {
    try {
      await fetchFunction();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _setLoading(false);
    }
  }
}
