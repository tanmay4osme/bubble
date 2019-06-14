import 'package:flutter/material.dart';

class GrayInput extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final TextInputType type;
  final bool obscureText;

  GrayInput(
      {this.controller,
      this.placeholder,
      this.type,
      this.obscureText = false,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        color: Colors.grey[100],
        padding: EdgeInsets.all(8),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: placeholder,
          ),
        ),
      ),
    );
  }
}
