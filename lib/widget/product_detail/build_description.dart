import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/providers/ProductProvider.dart';
import 'package:provider/provider.dart';

class BuildDescription extends StatefulWidget {
  const BuildDescription({super.key});

  @override
  State<BuildDescription> createState() => _BuildDescriptionState();
}

class _BuildDescriptionState extends State<BuildDescription> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.selectedProduct;

    List<Widget> buildDescription() {
      return [
        ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.description_outlined,
              ),
              const SizedBox(width: 8),
              const Text(
                'معرفی کالا',
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
              child: ExpandableText(
                product?.product.productIntroduction.toString() ??
                    'توضیحاتی موجود نیست',
                expandText: 'نمایش بیشتر',
                collapseText: 'نمایش کمتر',
                maxLines: 5,
                linkStyle: const TextStyle(
                  color: Color(0xFF424242),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ];
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: buildDescription(),
      ),
    );
  }
}
