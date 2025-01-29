import 'package:flutter/material.dart';
import 'package:online_shop/widget/login/bg_data.dart';

class BuildOptionsList extends StatelessWidget {
  final Function(int) onSelect;
  final int selectedIndex;

  const BuildOptionsList({
    Key? key,
    required this.onSelect,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: bgList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onSelect(index),
          child: CircleAvatar(
            radius: 30,
            backgroundColor:
                selectedIndex == index ? Colors.white : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(bgList[index]),
              ),
            ),
          ),
        );
      },
    );
  }
}
