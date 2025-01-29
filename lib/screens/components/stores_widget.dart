import 'package:flutter/material.dart';
import '../../model/Stores.dart';

class StoresWidget extends StatelessWidget {
  const StoresWidget(
    this.context, {
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  final StoresModel data;
  final BuildContext context;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: data.logo != null
                            ? Image.network(
                                data.logo!['path'],
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/logo_shop.jpg',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.address,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.phone,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 9.8),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          // بنر فروشگاه
          data.banner != null
              ? Image.network(data.banner!['path'])
              : Image.asset(
                  'assets/images/shop_default.jpg',
                ),
        ],
      ),
    );
  }
}
