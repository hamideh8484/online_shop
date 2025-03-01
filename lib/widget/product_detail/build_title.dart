import 'package:flutter/material.dart';
import 'package:online_shop/model/product_quantity.dart';
import 'package:online_shop/providers/ProductProvider.dart';
import 'package:provider/provider.dart';

class BuildTitle extends StatefulWidget {
  final int productId;

  const BuildTitle({super.key, required this.productId});

  @override
  State<BuildTitle> createState() => _BuildTitleState();
}

class _BuildTitleState extends State<BuildTitle> {
  final Map<int, ProductQuantity> _productQuantities = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      final productBalances =
          productProvider.getProductBalanceByProductId(widget.productId);

      if (productBalances.isEmpty &&
          !productProvider
              .isProductBalanceLoading(widget.productId.toString())) {
        await productProvider.fetchProductBalance(widget.productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final productBalances =
            productProvider.getProductBalanceByProductId(widget.productId);

        if (productBalances.isEmpty) {
          return const Center(
            child: Text(
              'این محصول در حال حاضر موجودی ندارد',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        }

        final storeTitle =
            productBalances.isNotEmpty ? productBalances[0].store!.title : '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              storeTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...productBalances.expand((balance) {
              final balanceAttributes = balance.productBalanceAttributes;
              if (balanceAttributes.isEmpty) return [];

              return balanceAttributes.expand((attribute) {
                final value = attribute.value is List
                    ? attribute.value
                    : [attribute.value];
                return value.map((option) {
                  if (option is! Map ||
                      !option.containsKey('id') ||
                      !option.containsKey('name')) {
                    return const SizedBox.shrink();
                  }

                  final optionId = option['id'];
                  final parsedId = optionId is int
                      ? optionId
                      : int.tryParse(optionId.toString());
                  final optionName = option['name'];

                  if (parsedId == null || optionName == null)
                    return const SizedBox.shrink();

                  if (!_productQuantities.containsKey(parsedId)) {
                    _productQuantities[parsedId!] = ProductQuantity(0, 0.0);
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        constraints: const BoxConstraints(
                          minHeight: 80,
                        ),
                        color: Colors.grey.shade100,
                        child: Column(
                          children: [
                            RadioListTile<int>(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "  $optionName",
                                      style: const TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  _buildQuantity(parsedId!, balance.price),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    'موجودی: ${balance.number} عدد',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.redAccent),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "  ${balance.price} تومان",
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                              value: parsedId,
                              groupValue: productProvider.selectedOption,
                              activeColor: Colors.blue,
                              onChanged: (int? value) {
                                if (value != null &&
                                    value != productProvider.selectedOption) {
                                  double selectedPrice = balance.price;
                                  productProvider.setSelectedOption(
                                      value.toString(), selectedPrice);
                                  print(selectedPrice);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList();
              });
            }).toList(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildQuantity(int productId, double price) {
    final productQuantity = _productQuantities[productId]!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          child: Image.asset(
            'assets/icons/detail/minus@2x.png',
            scale: 2.5,
          ),
          onTap: () {
            if (productQuantity.quantity > 0) {
              setState(() {
                productQuantity.quantity -= 1;
                productQuantity.totalPrice = productQuantity.quantity * price;
                calculateTotalPrice();
              });
            }
          },
        ),
        const SizedBox(width: 10),
        Text(
          '${productQuantity.quantity}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          child: Image.asset(
            'assets/icons/detail/plus@2x.png',
            scale: 2.5,
          ),
          onTap: () {
            setState(() {
              productQuantity.quantity += 1;
              productQuantity.totalPrice = productQuantity.quantity * price;
              calculateTotalPrice();
              print(calculateTotalPrice());
            });
          },
        ),
      ],
    );
  }

  double calculateTotalPrice() {
    double total = 0.0;
    _productQuantities.forEach((key, value) {
      total += value.totalPrice;
    });
    return total;
  }
}
