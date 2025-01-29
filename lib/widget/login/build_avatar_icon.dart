import 'package:flutter/material.dart';

class AvatarIcon extends StatelessWidget {
  final VoidCallback onTap;
  final String imagePath;

  const AvatarIcon({
    Key? key,
    required this.onTap,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath),
          ),
        ),
      ),
    );
  }
}
