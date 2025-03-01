import 'package:flutter/material.dart';
import 'package:online_shop/providers/CategoriProvider.dart';
import 'package:online_shop/widget/stores/banner_stores_widget.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:online_shop/providers/StoresProvider.dart';
import 'package:online_shop/screens/product/all_product.dart';

typedef SpecialOffersOnTapSeeAll = void Function();

class CategoriesOfStores extends StatefulWidget {
  final SpecialOffersOnTapSeeAll? onTapSeeAll;
  const CategoriesOfStores({super.key, this.onTapSeeAll});

  @override
  State<CategoriesOfStores> createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<CategoriesOfStores> {
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoresProvider>(context, listen: false).fetchStores();
      Provider.of<CategoriesProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StoresProvider, CategoriesProvider>(
      builder: (context, storeProvider, categoryProvider, child) {
        if (storeProvider.isLoading || categoryProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (storeProvider.stores.isEmpty) {
          return Center(child: Text('فروشگاهی موجود نیست'));
        }

        final storesToShow = storeProvider.stores.length > 6
            ? storeProvider.stores.sublist(0, 6)
            : storeProvider.stores;

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildTitle(),
              const SizedBox(height: 24),
              Container(
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
              ),
              Text(
                'دسته بندی ها',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF212121)),
              ),
              const SizedBox(height: 4),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: categoryProvider.categories.length,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: 100,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  maxCrossAxisExtent: 77,
                ),
                itemBuilder: ((context, index) {
                  final data = categoryProvider.categories[index];
                  return GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AllProductScreen.route()),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0x10101014),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child:
                                Image.asset(data.icon, width: 28, height: 28),
                          ),
                        ),
                        const SizedBox(height: 12),
                        FittedBox(
                          child: Text(
                            data.title,
                            style: const TextStyle(
                                color: Color(0xff424242),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
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
        TextButton(
          onPressed: () => widget.onTapSeeAll?.call(),
          child: const Text(
            'نمایش همه',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF212121)),
          ),
        ),
        const Text(
          'فروشگاه ها',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF212121)),
        ),
      ],
    );
  }

  Widget indicator(bool isActive) {
    return SizedBox(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        height: 4.0,
        width: isActive ? 16 : 4.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          color: isActive ? const Color(0XFF101010) : const Color(0xFFBDBDBD),
        ),
      ),
    );
  }
}
