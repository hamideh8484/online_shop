import 'package:flutter/material.dart';
import 'package:online_shop/providers/ProductNatureProvider.dart';
import 'package:online_shop/widget/stores/banner_stores_widget.dart';
import 'package:online_shop/screens/product/Products_in_this_category.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:online_shop/providers/StoresProvider.dart';

typedef SpecialOffersOnTapSeeAll = void Function();

class SpecialOffers extends StatefulWidget {
  final SpecialOffersOnTapSeeAll? onTapSeeAll;
  const SpecialOffers({super.key, this.onTapSeeAll});
  static String route() => '/specialOffTapSeeAll';

  @override
  State<SpecialOffers> createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers> {
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    Provider.of<StoresProvider>(context, listen: false).fetchStores();
    Provider.of<ProductNatureProvider>(context, listen: false)
        .fetchProductNature();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StoresProvider, ProductNatureProvider>(
      builder: (context, storeProvider, productNature, child) {
        if (storeProvider.isLoading || productNature.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (storeProvider.stores.isEmpty) {
          return const Center(child: Text('فروشگاهی موجود نیست'));
        }

        final storesToShow = storeProvider.stores.length > 6
            ? storeProvider.stores.sublist(0, 6)
            : storeProvider.stores;

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildTitle(),
              const SizedBox(height: 24),
              _buildCarouselSlider(storesToShow),
              const SizedBox(height: 24),
              Text(
                'دسته بندی ها',
                style: TextStyle(fontSize: 20),
              ),
              _buildProductNatureGrid(productNature),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'نمایش همه',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF212121),
          ),
        ),
        TextButton(
          onPressed: () => widget.onTapSeeAll?.call(),
          child: const Text(
            'فروشگاه ها',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF212121),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselSlider(List<dynamic> storesToShow) {
    return Container(
      height: 181,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 181.0,
          autoPlay: true,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            setState(() {
              selectIndex = index;
            });
          },
        ),
        items: storesToShow.map((data) {
          return Builder(
            builder: (BuildContext context) {
              return BannerStoresWidget(
                context,
                data: data,
                index: storesToShow.indexOf(data),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductNatureGrid(ProductNatureProvider productNature) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: productNature.productNature.length,
        scrollDirection: Axis.vertical,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisExtent: 100,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          maxCrossAxisExtent: 77,
        ),
        itemBuilder: (context, index) {
          final data = productNature.productNature[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              ProductsInThisCategory.route(),
              arguments: data.id,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x10101014),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: _buildProductLogo(data.logo),
                  ),
                ),
                const SizedBox(height: 12),
                FittedBox(
                  child: Text(
                    data.name,
                    style: const TextStyle(
                      color: Color(0xff424242),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildProductLogo(String? logoPath) {
  if (logoPath != null && logoPath.isNotEmpty) {
    return Image.network(
      logoPath,
      width: 60,
      height: 60,
      fit: BoxFit.fill,
    );
  } else {
    return const SizedBox(
      width: 60,
      height: 60,
      child: Icon(Icons.image_not_supported),
    );
  }
}
