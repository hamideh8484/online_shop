import 'package:flutter/material.dart';
import 'package:online_shop/widget/size_config.dart';

class BuildFloatbar extends StatefulWidget {
  const BuildFloatbar({super.key});

  @override
  State<BuildFloatbar> createState() => _BuildFloatbarState();
}

class _BuildFloatbarState extends State<BuildFloatbar> {
  int _quantity = 0;
  double _totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    Widget buildFloatBar() {
      Widget buildAddCard() => Container(
            height: 58,
            width: getProportionateScreenWidth(258),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(29)),
              color: const Color(0xFF101010),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _quantity > 0
                    ? _addToCart
                    : null, // فقط وقتی که تعداد بیشتر از 0 باشد
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/detail/bag@2x.png', scale: 2),
                    const SizedBox(width: 16),
                    const Text(
                      'افزودن به سبد خرید',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 21),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'قیمت کل:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '  $_totalPrice',
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 21),
                  // _buildQuantity(),
                  const SizedBox(height: 25),
                  buildAddCard(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        buildFloatBar(),
      ],
    );
  }

  Widget _buildQuantity() {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'تعداد',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xFFF3F3F3),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  InkWell(
                    child: Image.asset('assets/icons/detail/minus@2x.png',
                        scale: 2),
                    onTap: () {
                      if (_quantity > 0) {
                        setState(() {
                          _quantity -= 1;
                          _updateTotalPrice();
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    child: Image.asset('assets/icons/detail/plus@2x.png',
                        scale: 2),
                    onTap: () {
                      setState(() {
                        _quantity += 1;
                        _updateTotalPrice();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateTotalPrice() {
    const unitPrice = 100.0;
    _totalPrice = _quantity * unitPrice;
  }

  void _addToCart() {
    print('Product added to cart');
  }
}
