import 'package:flutter/material.dart';
import 'package:online_shop/widget/image_loader.dart';
import 'package:online_shop/screens/home/home.dart';
import 'package:online_shop/screens/profile/profile_screen.dart';
import 'package:online_shop/screens/test/test_screen.dart';
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
    const HomeScreen(
      title: 'home',
    ),
    const TestScreen(title: 'Cart'),
    // const TestScreen(title: 'Orders'),
    const TestScreen(title: 'Wallet'),
    const ProfileScreen(),
  ];

  static Image generateIcon(String path) {
    return Image.asset(
      '${ImageLoader.rootPaht}/tabbar/$path',
      width: 24,
      height: 24,
    );
  }

  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/icons/light/shop_o.png')),
      activeIcon: ImageIcon(AssetImage('assets/icons/bold/shop_f.png')),
      label: 'فروشگاه',
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/icons/light/shopping_cart_o.png')),
      activeIcon:
          ImageIcon(AssetImage('assets/icons/bold/shopping_cart_f.png')),
      label: 'سبد خرید',
    ),
    // BottomNavigationBarItem(
    //   icon: ImageIcon(AssetImage('assets/icons/light/heart@2x.png')),
    //   activeIcon: ImageIcon(AssetImage('assets/icons/bold/heart@2x.png')),
    //   label: 'سفارشات',
    // ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/icons/light/cart_o.png')),
      activeIcon: ImageIcon(AssetImage('assets/icons/bold/cart_f.png')),
      label: 'کیف پول',
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/icons/light/profile_o.png')),
      activeIcon: ImageIcon(AssetImage('assets/icons/bold/profile_f.png')),
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
