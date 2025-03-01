import 'package:flutter/material.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({
    super.key,
  });

  static String route() => '/shoppingCart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 180.0),
      child: Column(children: [
        // Image.asset('assets/images/banner/banner_2.jpg'),
        Image.asset('assets/empty/shop.jpg'),

        Text(
          'سبد خرید خالی است',
          style: TextStyle(fontSize: 25),
        ),
      ]),
    ));
  }
}
