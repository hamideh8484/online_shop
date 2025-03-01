import 'package:flutter/material.dart';
import 'package:online_shop/providers/CategoriProvider.dart';
import 'package:provider/provider.dart';
import 'package:online_shop/providers/StoresProvider.dart';
import 'package:online_shop/widget/stores/stores_widget.dart';

class AllStoresScreen extends StatefulWidget {
  const AllStoresScreen({super.key});

  @override
  State<AllStoresScreen> createState() => _SpecialOfferScreenState();

  static String route() => '/all_stores';
}

class _SpecialOfferScreenState extends State<AllStoresScreen> {
  bool isSearchVisible = false;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  List<int> selectedCategoryIds = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoresProvider>(context, listen: false).fetchStores();
      Provider.of<CategoriesProvider>(context, listen: false).fetchCategories();
    });
  }

  void toggleSearch() {
    setState(() {
      isSearchVisible = !isSearchVisible;
      if (!isSearchVisible) {
        searchQuery = "";
        searchController.clear();
      }
    });
  }

  void toggleCategorySelection(int id) {
    setState(() {
      if (selectedCategoryIds.contains(id)) {
        selectedCategoryIds.remove(id);
      } else {
        selectedCategoryIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearchVisible
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: TextStyle(color: Colors.black, fontSize: 16),
                decoration: InputDecoration(
                  hintText: "جستجو بر اساس نام فروشگاه...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey.shade200, // پس‌زمینه نرم و روشن
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query.toLowerCase();
                  });
                },
              )
            : Row(
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Consumer<CategoriesProvider>(
                                builder: (context, categoryProvider, child) {
                                  if (categoryProvider.isLoading) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 5),
                                    child: Column(
                                      children: [
                                        GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: categoryProvider
                                              .categories.length,
                                          scrollDirection: Axis.vertical,
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                            mainAxisExtent: 100,
                                            mainAxisSpacing: 24,
                                            crossAxisSpacing: 24,
                                            maxCrossAxisExtent: 77,
                                          ),
                                          itemBuilder: (context, index) {
                                            final data = categoryProvider
                                                .categories[index];
                                            final isSelected =
                                                selectedCategoryIds.contains(
                                                    int.parse(data.id));
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  toggleCategorySelection(
                                                      int.parse(data.id));
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? Colors.blue
                                                              .withOpacity(0.2)
                                                          : const Color(
                                                              0x10101014),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          child: Image.asset(
                                                              data.icon,
                                                              width: 28,
                                                              height: 28),
                                                        ),
                                                        if (isSelected)
                                                          const Positioned(
                                                            top: 0,
                                                            right: 0,
                                                            child: Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  FittedBox(
                                                    child: Text(
                                                      data.title,
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xff424242),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(height: 30),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      Colors.black)),
                                          onPressed: () {
                                            print(
                                                'Selected Category IDs: $selectedCategoryIds');
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'تایید',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Image.asset(
                      'assets/icons/light/filter@2x.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text('فروشگاه ها'),
                ],
              ),
        actions: [
          IconButton(
            icon: Image.asset('assets/icons/search@2x.png', scale: 2.0),
            onPressed: toggleSearch,
          ),
        ],
      ),
      body: Consumer<StoresProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final filteredStores = provider.stores
              .where((store) => store.title.toLowerCase().contains(searchQuery))
              .toList();

          if (filteredStores.isEmpty) {
            return Center(child: Text('No special offers available'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemBuilder: (context, index) {
              final data = filteredStores[index];
              return Container(
                height: 181,
                decoration: const BoxDecoration(
                  color: Color(0xFFE7E7E7),
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                child: StoresWidget(context, data: data, index: index),
              );
            },
            itemCount: filteredStores.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 24);
            },
          );
        },
      ),
    );
  }
}
