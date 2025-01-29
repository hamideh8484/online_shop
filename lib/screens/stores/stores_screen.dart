import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_shop/providers/StoresProvider.dart';
import 'package:online_shop/screens/components/stores_widget.dart';

class SpecialOfferScreen extends StatefulWidget {
  const SpecialOfferScreen({super.key});

  @override
  State<SpecialOfferScreen> createState() => _SpecialOfferScreenState();

  static String route() => '/special_offers';
}

class _SpecialOfferScreenState extends State<SpecialOfferScreen> {
  bool isSearchVisible = false;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoresProvider>(context, listen: false).fetchStores();
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
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(32),
                  //   borderSide: BorderSide.none,
                  // ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(32),
                  //   borderSide:
                  //       BorderSide(color: Colors.blueAccent, width: 1.5),
                  // ),
                ),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query.toLowerCase();
                  });
                },
              )
            : Text('فروشگاه ها'),
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
