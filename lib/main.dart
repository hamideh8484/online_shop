import 'package:flutter/material.dart';
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
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => StoresProvider()),
  ], child: FreshBuyerApp(token: token)));
}

class FreshBuyerApp extends StatelessWidget {
  final String? token;
  const FreshBuyerApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // راست‌چین کردن متن‌ها
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fresh-Buyer',
        theme:
            appTheme(), // اطمینان از اینکه تم اپلیکیشن از راست‌چین پشتیبانی می‌کند
        routes: routes,
        home: token != null ? FRTabbarScreen() : const LoginScreen(),
      ),
    );
  }
}
