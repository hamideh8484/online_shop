import 'package:flutter/material.dart';

import 'package:online_shop/providers/ProductProvider.dart';
import 'package:online_shop/widget/product/product_card.dart';
import 'package:provider/provider.dart';

class ProductsInThisCategory extends StatefulWidget {
  final int categoryId;
  const ProductsInThisCategory({super.key, required this.categoryId});

  static String route() => '/ProductsInThisCategory';

  @override
  State<ProductsInThisCategory> createState() => _ProductsInThisCategoryState();
}

class _ProductsInThisCategoryState extends State<ProductsInThisCategory> {
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProductsByCategory(widget.categoryId);
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
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final products = productProvider.product.where((product) {
            return product.productNature != null &&
                product.productNature!.id == widget.categoryId;
          }).toList();

          final filteredData = products.where((product) {
            return product.brand.name.toLowerCase().contains(searchQuery) ||
                product.name.toLowerCase().contains(searchQuery);
          }).toList();

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: padding,
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 185,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 285,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCard(data: filteredData[index]),
                    childCount: filteredData.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
