import 'package:flutter/material.dart';
import 'package:online_shop/screens/cart/cart_screen.dart';
import 'package:online_shop/screens/stores/stores_screen.dart';
import 'package:online_shop/widget/image_loader.dart';
import 'package:online_shop/screens/product/product_screens.dart';
import 'package:online_shop/screens/profile/profile_screen.dart';
import 'package:online_shop/screens/shopping_cart/shopping_cart.dart';
import 'package:online_shop/widget/size_config.dart';

class TabbarItem {
  final String lightIcon;
  final String boldIcon;
  final String label;

  TabbarItem(
      {required this.lightIcon, required this.boldIcon, required this.label});

  BottomNavigationBarItem item(bool isbold) {
    return BottomNavigationBarItem(
      icon: ImageLoader.imageAsset(isbold ? boldIcon : lightIcon),
      label: label,
    );
  }

  BottomNavigationBarItem get light => item(false);
  BottomNavigationBarItem get bold => item(true);
}

class FRTabbarScreen extends StatefulWidget {
  const FRTabbarScreen({super.key});

  @override
  State<FRTabbarScreen> createState() => _FRTabbarScreenState();
}

class _FRTabbarScreenState extends State<FRTabbarScreen> {
  int _select = 0;

  final screens = [
    const GoodsScreen(
      title: 'Goods',
    ),
    const StoresScreen(title: 'stores'),
    const ShoppingCartScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  // static Image generateIcon(String path) {
  //   return Image.asset(
  //     '${ImageLoader.rootPaht}/tabbar/$path',
  //     width: 24,
  //     height: 24,
  //   );
  // }

  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/light/goods_o.png',
        width: 25,
        height: 25,
      ),
      activeIcon: Image.asset(
        'assets/icons/bold/goods_f.png',
        width: 35,
        height: 35,
      ),
      label: 'کالا ها',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/light/shop.png',
        // 'assets/icons/light/shop_o.png',
        width: 25,
        height: 25,
      ),
      activeIcon: Image.asset(
        'assets/icons/bold/shop_bold.png',
        // 'assets/icons/bold/shop_f.png',
        width: 35,
        height: 35,
      ),
      label: 'فروشگاه',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/light/shopping_cart_o.png',
        width: 25,
        height: 25,
      ),
      activeIcon: Image.asset(
        'assets/icons/bold/shopping_cart_f.png',
        width: 35,
        height: 35,
      ),
      label: 'سبد خرید',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/light/cart_o.png',
        width: 25,
        height: 25,
      ),
      activeIcon: Image.asset(
        'assets/icons/bold/cart_f.png',
        width: 35,
        height: 35,
      ),
      label: 'کیف پول',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/light/profile_o.png',
        width: 25,
        height: 25,
      ),
      activeIcon: Image.asset(
        'assets/icons/bold/profile_f.png',
        width: 35,
        height: 35,
      ),
      label: 'پروفایل',
    ),
  ];

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: screens[_select],
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        onTap: ((value) => setState(() => _select = value)),
        currentIndex: _select,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10,
        ),
        selectedItemColor: const Color(0xFF212121),
        unselectedItemColor: const Color(0xFF9E9E9E),
      ),
    );
  }
}
