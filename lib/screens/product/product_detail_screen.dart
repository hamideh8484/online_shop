import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:online_shop/model/product_balance.dart';
import 'package:online_shop/providers/ProductProvider.dart';
import 'package:online_shop/widget/product_detail/product_features.dart';
import 'package:online_shop/widget/product_detail/build_description.dart';
import 'package:online_shop/widget/product_detail/build_floatBar.dart';
import 'package:online_shop/widget/product_detail/build_title.dart';
import 'package:online_shop/widget/product_detail/add_itional_information.dart';
import 'package:online_shop/widget/product_detail/this_product_in_Other_stores.dart';
import 'package:online_shop/widget/size_config.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShopDetailScreen extends StatefulWidget {
  final int productId;

  const ShopDetailScreen({super.key, required this.productId});

  static String route() => '/shop_detail';

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  String? selectedColor;
  String? selectedPrice;
  int _current = 0;
  bool isHeartSelected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = getProportionateScreenHeight(428);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Selector<ProductProvider, bool>(
            selector: (_, provider) => provider.isLoading,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.selectedProduct == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'کالایی موجود نیست',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Provider.of<ProductProvider>(context,
                                      listen: false)
                                  .fetchProductById(widget.productId);
                            },
                            child: const Text('تلاش مجدد'),
                          ),
                        ],
                      ),
                    );
                  }

                  final product = productProvider.selectedProduct!;

                  return Stack(
                    children: [
                      CustomScrollView(
                        slivers: [
                          sliverAppBar(appBarHeight, product),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BuildTitle(productId: product.product.id),
                                  const SizedBox(height: 16),
                                  buildLine(),
                                  SizedBox(
                                      height: 150,
                                      child: ThisProductInOtherStores()),
                                  ProductFeaturesDetail(),
                                  const SizedBox(height: 24),
                                  BuildDescription(),
                                  const SizedBox(height: 24),
                                  AddItionalInformation(),
                                  const SizedBox(height: 215),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Image.asset(
                            'assets/icons/back@2x.png',
                            color: const Color.fromARGB(255, 147, 145, 145),
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isHeartSelected = !isHeartSelected;
                          });
                        },
                        icon: isHeartSelected
                            ? Image.asset(
                                'assets/icons/bold/heart@2x.png',
                                color: const Color.fromARGB(255, 147, 145, 145),
                                width: 35,
                                height: 35,
                              )
                            : Image.asset(
                                'assets/icons/light/heart@2x.png',
                                color: const Color.fromARGB(255, 147, 145, 145),
                                width: 35,
                                height: 35,
                              ),
                      ),
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: BuildFloatbar(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  SliverAppBar sliverAppBar(double appBarHeight, ProductData product) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: false,
      expandedHeight: appBarHeight,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: product.product.files.isNotEmpty
            ? Stack(
                children: [
                  CarouselSlider.builder(
                    key: ValueKey(product.product.files.length),
                    itemCount: product.product.files.length,
                    itemBuilder: (context, index, _) {
                      return CachedNetworkImage(
                        imageUrl: product.product.files[index].path,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: appBarHeight,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: appBarHeight,
                      enlargeCenterPage: true,
                      autoPlay: product.product.files.length > 1,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: product.product.files.length > 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10.0,
                    left: 0.0,
                    right: 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List.generate(product.product.files.length, (index) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 2.0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _current == index ? Colors.white : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              )
            : Container(
                height: appBarHeight,
                color: const Color(0xFFeeeeee),
                child: const Center(
                  child: Text('تصویری موجود نیست'),
                ),
              ),
      ),
    );
  }
}
