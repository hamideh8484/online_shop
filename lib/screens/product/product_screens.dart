import 'package:flutter/material.dart';
import 'package:online_shop/model/product.dart';
import 'package:online_shop/providers/ProductProvider.dart';
import 'package:online_shop/widget/product/product_card.dart';
import 'package:online_shop/screens/product/product_detail_screen.dart';
import 'package:online_shop/widget/product/goods.dart';
import 'package:online_shop/widget/product/hearder.dart';
import 'package:online_shop/widget/product/most_popular.dart';
import 'package:online_shop/widget/product/search_field.dart';
import 'package:online_shop/screens/product/all_product.dart';

import 'package:provider/provider.dart';

class GoodsScreen extends StatefulWidget {
  final String title;

  static String route() => '/goods';

  const GoodsScreen({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _GoodsScreenState();
}

class _GoodsScreenState extends State<GoodsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProductProvider>(context, listen: false).fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(24, 24, 24, 0);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverPadding(
            padding: EdgeInsets.only(top: 24),
            sliver: SliverAppBar(
              automaticallyImplyLeading: false,
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
        SpecialOffers(),
        const SizedBox(height: 24),
        ConfigurableTitle(
          title: 'محصولات',
          onTapSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllProductScreen()),
            );
          },
        ),
        const SizedBox(height: 24),
        const MostPupularCategory(),
      ],
    );
  }

  Widget _buildPopularItem(BuildContext context, Product data) {
    return ProductCard(
      data: data,
      ontap: (data) => Navigator.pushNamed(context, ShopDetailScreen.route()),
    );
  }

  void _onTapMostPopularSeeAll(BuildContext context) {
    Navigator.pushNamed(context, AllProductScreen.route());
  }
}
