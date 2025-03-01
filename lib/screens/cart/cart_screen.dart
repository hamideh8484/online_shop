import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, this.title = ''});

  static String route() => '/cart';

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 180.0),
        child: Column(
          children: [
            Image.asset('assets/empty/cart.jpg'),
            SizedBox(
              height: 10,
            ),
            Text(
              'هیچ کارت اعتباری ثبت نشده است',
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
