import 'package:flutter/material.dart';
import '../../../model/Stores.dart';

class BannerStoresWidget extends StatelessWidget {
  const BannerStoresWidget(
    this.context, {
    super.key,
    required this.data,
    required this.index,
  });

  final StoresModel data;
  final BuildContext context;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: data.banner != null
                  ? Image.network(
                      data.banner!['path'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 140,
                    )
                  : Image.asset(
                      'assets/images/shop_default.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 140,
                    ),
            ),
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 3,
              left: 2,
              right: 10,
              child: Text(
                data.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      blurRadius: 3.0,
                      color: Colors.black54,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
