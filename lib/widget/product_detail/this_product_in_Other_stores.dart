import 'package:flutter/material.dart';
import 'package:online_shop/model/product.dart';
import 'package:online_shop/providers/ProductProvider.dart';
import 'package:online_shop/widget/build_widget_cart.dart';
import 'package:provider/provider.dart';

class ThisProductInOtherStores extends StatefulWidget {
  const ThisProductInOtherStores({super.key});

  @override
  State<ThisProductInOtherStores> createState() =>
      _ThisProductInOtherStoresState();
}

class _ThisProductInOtherStoresState extends State<ThisProductInOtherStores> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      if (productProvider.product.isEmpty) {
        productProvider.fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FullWidthBox(
      color: Colors.white,
      child: SizedBox(
        height: 80.0,
        child: Selector<ProductProvider, bool>(
          selector: (_, provider) => provider.isLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Selector<ProductProvider, List<Product>>(
              selector: (_, provider) => provider.product,
              builder: (context, products, child) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Container(
                      width: 130,
                      height: 40,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          '${product.minPrice} تومان',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

Widget buildLine() {
  return Container(height: 1, color: const Color.fromARGB(255, 206, 203, 203));
}
