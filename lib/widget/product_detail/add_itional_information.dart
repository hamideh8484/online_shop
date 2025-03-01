import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/model/product.dart';
import 'package:online_shop/providers/ProductProvider.dart';
import 'package:provider/provider.dart';

class AddItionalInformation extends StatefulWidget {
  const AddItionalInformation({super.key});

  @override
  State<AddItionalInformation> createState() => _ProductFeaturesDetailState();
}

class _ProductFeaturesDetailState extends State<AddItionalInformation> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.selectedProduct;

    List<Widget> buildAddItionalInformation() {
      if (product == null || product.product.productFeatureValues.isEmpty) {
        return [
          const Center(
            child: Text('اطلاعات تکمیلی محصول موجود نیست'),
          ),
        ];
      }

      return [
        ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
              ),
              SizedBox(
                width: 5,
              ), // آیکون اطلاعات
              const Text(
                'اطلاعات تکمیلی کالا',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          collapsedIconColor: Colors.grey,
          iconColor: Colors.blue,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(120, 186, 192, 197),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ExpandableText(
                _buildProductFeatureText(product.product.productFeatureValues),
                expandText: 'مشاهده بیشتر',
                maxLines: 10,
                linkStyle: const TextStyle(
                  color: Color(0xFF424242),
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ];
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: buildAddItionalInformation(),
      ),
    );
  }

  String _buildProductFeatureText(List<ProductFeatureValue> featureValues) {
    return featureValues.map((feature) {
      String featureName = feature.productNatureAttribute.name; // نام ویژگی

      String featureValue;
      if (feature.value is List) {
        featureValue = (feature.value as List)
            .map((val) {
              if (val is Map && val.containsKey('name')) {
                return val['name'].toString();
              } else if (val is FeatureValue && val.name is Map) {
                return (val.name as Map)['name'].toString();
              } else if (val is FeatureValue) {
                return val.name.toString();
              }
              return '';
            })
            .where((name) => name.isNotEmpty)
            .join(', ');
      } else if (feature.value is Map &&
          (feature.value as Map).containsKey('name')) {
        featureValue = (feature.value as Map)['name'].toString();
      } else if (feature.value != null) {
        featureValue = feature.value.toString();
      } else {
        featureValue = 'نامشخص';
      }

      return '$featureName: $featureValue';
    }).join('\n\n');
  }
}
