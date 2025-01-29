import 'package:flutter/material.dart';
import 'package:online_shop/screens/detail/detail_screen.dart';
import 'package:online_shop/screens/home/home.dart';
import 'package:online_shop/screens/login/login_screen.dart';
import 'package:online_shop/screens/mostpopular/most_popular_screen.dart';
import 'package:online_shop/screens/profile/profile_screen.dart';
import 'package:online_shop/screens/stores/stores_screen.dart';
import 'package:online_shop/screens/test/test_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.route(): (context) => const HomeScreen(title: '123'),
  MostPopularScreen.route(): (context) => const MostPopularScreen(),
  SpecialOfferScreen.route(): (context) => const SpecialOfferScreen(),
  ProfileScreen.route(): (context) => const ProfileScreen(),
  ShopDetailScreen.route(): (context) => const ShopDetailScreen(),
  TestScreen.route(): (context) => const TestScreen(),
  LoginScreen.route(): (context) => const LoginScreen(),
};
