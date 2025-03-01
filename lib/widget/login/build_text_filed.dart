import 'package:flutter/material.dart';

class ConfirmationTextField extends StatefulWidget {
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
  _ConfirmationTextFieldState createState() => _ConfirmationTextFieldState();
}

class _ConfirmationTextFieldState extends State<ConfirmationTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 80,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode
          ..addListener(() {
            print('Focus: ${widget.focusNode.hasFocus}');
          }),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.controller.text,
          hintStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.only(left: 10),
          counterText: '',
        ),
        maxLength: 1,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {
            widget.controller.text = value;
            widget.controller.selection =
                TextSelection.collapsed(offset: value.length);
          });
          print('Value: $value');
          widget.onChanged(value);
        },
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
