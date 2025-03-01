import 'package:flutter/material.dart';
import 'package:online_shop/providers/CategoriProvider.dart';
import 'package:online_shop/providers/ProductNatureProvider.dart';
import 'package:online_shop/providers/ProductProvider.dart';
import 'package:online_shop/providers/TotalPriceProvider.dart';
import 'package:online_shop/providers/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:online_shop/providers/StoresProvider.dart';
import 'package:online_shop/screens/login/data/login.dart';
import 'package:online_shop/screens/tabbar/tabbar.dart';
import 'package:online_shop/widget/routes.dart';
import 'package:online_shop/screens/login/login_screen.dart';
import 'package:online_shop/widget/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await getToken();
  print(token);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ProductNatureProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => StoresProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        // ChangeNotifierProvider(create: (_) => TotalPriceProvider()),
      ],
      child: FreshBuyerApp(token: token),
    ),
  );
}

class FreshBuyerApp extends StatelessWidget {
  final String? token;
  const FreshBuyerApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'فروشگاه آنلاین',
            theme: appTheme(),
            darkTheme: darkTheme(),
            themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
            routes: routes,
            onGenerateRoute: onGenerateRoute,
            home: token != null ? FRTabbarScreen() : const LoginScreen(),
          );
        },
      ),
    );
  }
}
