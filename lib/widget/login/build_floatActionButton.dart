import 'package:flutter/material.dart';

import 'package:online_shop/widget/login/bg_data.dart';
import 'package:online_shop/widget/login/build_avatar_icon.dart';
import 'package:online_shop/widget/login/build_close_icon.dart';
import 'package:online_shop/widget/login/build_options_list.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final bool showOption;
  final int selectedIndex;
  final VoidCallback onCloseIconTap;
  final VoidCallback onAvatarIconTap;
  final Function(int) onOptionSelect;

  const FloatingActionButtonWidget({
    Key? key,
    required this.showOption,
    required this.selectedIndex,
    required this.onCloseIconTap,
    required this.onAvatarIconTap,
    required this.onOptionSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 49,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: showOption
                ? BuildOptionsList(
                    onSelect: onOptionSelect,
                    selectedIndex: selectedIndex,
                  )
                : const SizedBox(),
          ),
          const SizedBox(width: 20),
          showOption
              ? CloseIcon(onTap: onCloseIconTap)
              : AvatarIcon(
                  onTap: onAvatarIconTap,
                  imagePath: bgList[selectedIndex],
                ),
        ],
      ),
    );
  }
}
