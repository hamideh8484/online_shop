import 'package:flutter/material.dart';
import 'package:online_shop/model/product.dart';
import 'package:online_shop/providers/ProductProvider.dart';
import 'package:online_shop/widget/product/product_card.dart';
import 'package:online_shop/screens/product/product_detail_screen.dart';
import 'package:online_shop/widget/product/hearder.dart';
import 'package:online_shop/widget/product/most_popular.dart';
import 'package:online_shop/widget/product/search_field.dart';
import 'package:online_shop/screens/product/all_product.dart';
import 'package:online_shop/screens/stores/all_stores.dart';
import 'package:online_shop/screens/stores/Categories_of_stores.dart';
import 'package:provider/provider.dart';

class StoresScreen extends StatefulWidget {
  final String title;

  static String route() => '/stores';

  const StoresScreen({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(24, 24, 24, 0);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverPadding(
            padding: EdgeInsets.only(top: 24),
            sliver: SliverAppBar(
              pinned: true,
              flexibleSpace: HomeAppBar(),
            ),
          ),
          SliverPadding(
            padding: padding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                ((context, index) => _buildBody(context)),
                childCount: 1,
              ),
            ),
          ),
          SliverPadding(
            padding: padding,
            sliver: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (productProvider.product.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('کالایی موجود نیست')),
                  );
                } else {
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 185,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 16,
                      mainAxisExtent: 285,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildPopularItem(
                          context, productProvider.product[index]),
                      childCount: productProvider.product.length,
                    ),
                  );
                }
              },
            ),
          ),
          const SliverAppBar(flexibleSpace: SizedBox(height: 24))
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        const SearchField(),
        const SizedBox(height: 24),
        CategoriesOfStores(
            onTapSeeAll: () => _onTapSpecialOffersSeeAll(context)),
        const SizedBox(height: 24),
        ConfigurableTitle(
          title: 'فروشگاه‌ها',
          onTapSeeAll: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AllStoresScreen(),
            ));
          },
        ),
        const SizedBox(height: 24),
        const MostPupularCategory(),
      ],
    );
  }

  // Widget _buildPopulars(BuildContext context) {
  //   return FutureBuilder(
  //     future:
  //         Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return SliverToBoxAdapter(
  //           child: Center(child: CircularProgressIndicator()),
  //         );
  //       } else if (snapshot.hasError) {
  //         return SliverToBoxAdapter(
  //           child: Center(child: Text('Error: ${snapshot.error}')),
  //         );
  //       } else {
  //         return Consumer<ProductProvider>(
  //           builder: (context, productProvider, child) {
  //             final datas = productProvider.product;
  //             return SliverPadding(
  //               padding: const EdgeInsets.all(24),
  //               sliver: SliverGrid(
  //                 gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
  //                   maxCrossAxisExtent: 185,
  //                   mainAxisSpacing: 24,
  //                   crossAxisSpacing: 16,
  //                   mainAxisExtent: 285,
  //                 ),
  //                 delegate: SliverChildBuilderDelegate(
  //                   (context, index) =>
  //                       _buildPopularItem(context, datas[index]),
  //                   childCount: datas.length,
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  Widget _buildPopularItem(BuildContext context, Product data) {
    return ProductCard(
      data: data,
      ontap: (data) => Navigator.pushNamed(context, ShopDetailScreen.route()),
    );
  }

  void _onTapMostPopularSeeAll(BuildContext context) {
    Navigator.pushNamed(context, AllProductScreen.route());
  }

  void _onTapSpecialOffersSeeAll(BuildContext context) {
    Navigator.pushNamed(context, AllStoresScreen.route());
  }
}
