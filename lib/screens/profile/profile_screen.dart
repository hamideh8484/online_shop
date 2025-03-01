import 'package:flutter/material.dart';
import 'package:online_shop/providers/themeProvider.dart';
import 'package:online_shop/screens/login/data/login.dart';
import 'package:online_shop/widget/profile/header.dart';
import 'package:online_shop/widget/shoDialog_logout.dart';
import 'package:online_shop/widget/theme.dart';
import 'package:provider/provider.dart';

typedef ProfileOptionTap = void Function();

class ProfileOption {
  String title;
  String icon;
  Color? titleColor;
  ProfileOptionTap? onClick;
  Widget? trailing;

  ProfileOption({
    required this.title,
    required this.icon,
    this.onClick,
    this.titleColor,
    this.trailing,
  });

  ProfileOption.arrow({
    required this.title,
    required this.icon,
    this.onClick,
    this.titleColor = const Color(0xFF212121),
    this.trailing = const Image(
        image: AssetImage('assets/icons/profile/arrow_right@2x.png'),
        width: 24,
        height: 24),
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static String route() => '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static _profileIcon(String last) => 'assets/icons/profile/$last';

  void logout(BuildContext context) async {
    await removeToken();
    Navigator.pushReplacementNamed(context, '/login');
  }

  _languageOption() => ProfileOption(
      title: 'Language',
      icon: _profileIcon('more_circle@2x.png'),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'English (US)',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xFF212121)),
            ),
            const SizedBox(width: 16),
            Image.asset(arrow, scale: 2)
          ],
        ),
      ));
  _darkModel(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return ProfileOption(
      title: 'Dark Mode',
      icon: _profileIcon('show@2x.png'),
      trailing: Switch(
        value: themeNotifier.isDark,
        activeColor: const Color(0xFF212121),
        onChanged: (value) {
          themeNotifier.toggleTheme();
        },
      ),
    );
  }

  get datas => <ProfileOption>[
        ProfileOption.arrow(
            title: 'Edit Profile', icon: _profileIcon('user@2x.png')),
        ProfileOption.arrow(
            title: 'Address', icon: _profileIcon('location@2x.png')),
        ProfileOption.arrow(
            title: 'Notification', icon: _profileIcon('notification@2x.png')),
        ProfileOption.arrow(
            title: 'Payment', icon: _profileIcon('wallet@2x.png')),
        ProfileOption.arrow(
            title: 'Security', icon: _profileIcon('shield_done@2x.png')),
        _languageOption(),
        _darkModel(context),
        ProfileOption.arrow(
            title: 'Help Center', icon: _profileIcon('info_square@2x.png')),
        ProfileOption.arrow(
            title: 'Invite Friends', icon: _profileIcon('user@2x.png')),
        ProfileOption(
          title: 'Logout',
          icon: _profileIcon('logout@2x.png'),
          titleColor: const Color(0xFFF75555),
          onClick: () => showLogoutDialog(context),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    Color titleColor =
        themeNotifier.isDark ? Colors.white : const Color(0xFF212121);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverList(
            delegate: SliverChildListDelegate.fixed([
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: ProfileHeader(),
              ),
            ]),
          ),
          _buildBody(titleColor),
        ],
      ),
    );
  }

  Widget _buildBody(Color titleColor) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 10.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final data = datas[index];
            return _buildOption(context, index, data, titleColor);
          },
          childCount: datas.length,
        ),
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, int index, ProfileOption data, Color titleColor) {
    return ListTile(
      leading: Image.asset(
        data.icon,
        scale: 2,
        color: titleColor,
      ),
      title: Text(
        data.title,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 18, color: titleColor),
      ),
      trailing: data.trailing,
      onTap: data.onClick,
    );
  }
}
