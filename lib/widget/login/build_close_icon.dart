import 'package:flutter/material.dart';

class CloseIcon extends StatelessWidget {
  final VoidCallback onTap;

  const CloseIcon({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.close,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
