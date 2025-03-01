import 'package:flutter/material.dart';
import 'package:online_shop/model/product.dart';
import 'package:online_shop/providers/ProductProvider.dart';
import 'package:online_shop/widget/product/product_card.dart';
import 'package:online_shop/widget/product/most_popular.dart';
import 'package:provider/provider.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  static String route() => '/all_stores';

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  TextEditingController searchController = TextEditingController();
  bool isSearchVisible = false;
  String searchQuery = "";

  void toggleSearch() {
    setState(() {
      isSearchVisible = !isSearchVisible;
      if (!isSearchVisible) {
        searchQuery = "";
        searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(24, 24, 24, 0);
    return Scaffold(
      appBar: AppBar(
        title: isSearchVisible
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: TextStyle(color: Colors.black, fontSize: 16),
                decoration: InputDecoration(
                  hintText: "جستجو بر اساس برند یا نام کالا ها...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  // prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query.toLowerCase();
                  });
                },
              )
            : Text('کالا ها'),
        actions: [
          IconButton(
            icon: Image.asset('assets/icons/search@2x.png', scale: 2.0),
            onPressed: toggleSearch,
          ),
        ],
      ),
      body: CustomScrollView(slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              ((context, index) => const MostPupularCategory()),
              childCount: 1,
            ),
          ),
        ),
        SliverPadding(
          padding: padding,
          sliver: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              final datas = productProvider.product;
              final filteredData = datas.where((product) {
                return product.brand.name.toLowerCase().contains(searchQuery);
              }).toList();

              return SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 185,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 285,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildPopularItem(context, filteredData[index]),
                  childCount: filteredData.length,
                ),
              );
            },
          ),
        ),
        // const SliverAppBar(flexibleSpace: SizedBox(height: 24))
      ]),
    );
  }

  Widget _buildPopularItem(BuildContext context, Product data) {
    return ProductCard(
      data: data,
    );
  }
}
