import 'package:flutter/material.dart';
import 'package:online_shop/providers/ProductProvider.dart';
import 'package:provider/provider.dart';

class ProductFeaturesDetail extends StatefulWidget {
  const ProductFeaturesDetail({super.key});

  @override
  State<ProductFeaturesDetail> createState() =>
      _BuildAdditionalInformationState();
}

class _BuildAdditionalInformationState extends State<ProductFeaturesDetail> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.selectedProduct;

    List<Widget> productFeatures() {
      debugPrint('Building description');
      return [
        ExpansionTile(
          title: Row(
            children: [
              Icon(Icons.category),
              SizedBox(
                width: 5,
              ),
              const Text(
                'ویژگی‌های کالا',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          collapsedIconColor: Colors.grey,
          iconColor: Colors.blue,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(120, 186, 192, 197),
                borderRadius: BorderRadius.circular(8),
              ),
              child: productProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نام کالا: ${product?.product.name ?? 'نامشخص'}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'ماهیت کالا: ${product?.product.productNature.name ?? 'نامشخص'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'برند کالا: ${product?.product.brand.name ?? 'نامشخص'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Divider(color: Colors.grey),
                      ],
                    ),
            ),
          ],
        ),
      ];
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: productFeatures(),
      ),
    );
  }
}
