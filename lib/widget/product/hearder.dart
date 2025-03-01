import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/widget/constants.dart';
import 'package:online_shop/screens/profile/profile_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              onTap: () => Navigator.pushNamed(context, ProfileScreen.route()),
              child: const CircleAvatar(
                backgroundImage: AssetImage('$kIconPath/me.png'),
                radius: 24,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'صبح بخیر👋',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'اقای فلان',
                      style: TextStyle(
                        color: Color(0xFF212121),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              iconSize: 28,
              icon: Icon(Icons.notifications_active),
              // icon: Image.asset('$kIconPath/notification.png'),
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            IconButton(
              iconSize: 28,
              icon: Icon(CupertinoIcons.heart),

              // icon: Image.asset('$kIconPath/light/heart@2x.png'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
