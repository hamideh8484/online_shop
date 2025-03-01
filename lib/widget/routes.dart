import 'package:flutter/material.dart';
import 'package:online_shop/screens/cart/cart_screen.dart';
import 'package:online_shop/screens/product/product_detail_screen.dart';
import 'package:online_shop/screens/product/Products_in_this_category.dart';
import 'package:online_shop/screens/product/product_screens.dart';
import 'package:online_shop/screens/login/login_screen.dart';
import 'package:online_shop/screens/product/all_product.dart';
import 'package:online_shop/screens/profile/profile_screen.dart';
import 'package:online_shop/screens/stores/all_stores.dart';
import 'package:online_shop/screens/shopping_cart/shopping_cart.dart';
import 'package:online_shop/screens/stores/stores_screen.dart';

final Map<String, WidgetBuilder> routes = {
  GoodsScreen.route(): (context) => const GoodsScreen(title: '123'),
  AllProductScreen.route(): (context) => const AllProductScreen(),
  AllStoresScreen.route(): (context) => const AllStoresScreen(),
  ProfileScreen.route(): (context) => const ProfileScreen(),
  ShoppingCartScreen.route(): (context) => const ShoppingCartScreen(),
  LoginScreen.route(): (context) => const LoginScreen(),
  CartScreen.route(): (context) => const CartScreen(),
  StoresScreen.route(): (context) => const StoresScreen(title: '456'),
};

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  if (settings.name == ProductsInThisCategory.route()) {
    final args = settings.arguments as int;
    return MaterialPageRoute(
      builder: (context) => ProductsInThisCategory(categoryId: args),
    );
  } else if (settings.name == ShopDetailScreen.route()) {
    final args = settings.arguments as int;
    return MaterialPageRoute(
      builder: (context) => ShopDetailScreen(productId: args),
    );
  }
  return MaterialPageRoute(
    builder: (context) => Scaffold(
      appBar: AppBar(
        title: Text('Page not found'),
      ),
      body: Center(
        child: Text('Page not found'),
      ),
    ),
  );
}
