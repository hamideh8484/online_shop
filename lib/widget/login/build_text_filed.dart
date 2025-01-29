import 'package:flutter/material.dart';

class ConfirmationTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;

  const ConfirmationTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextField(
        controller: controller,
        focusNode: focusNode
          ..addListener(() {
            print('Focus: ${focusNode.hasFocus}');
          }),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          counterText: '',
          hintText: '_',
        ),
        maxLength: 1,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onChanged: (value) {
          print('Value: $value');
          controller.text = value;
          controller.selection = TextSelection.collapsed(offset: value.length);
          onChanged(value);
        },
      ),
    );
  }
}
