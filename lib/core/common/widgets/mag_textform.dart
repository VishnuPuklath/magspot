import 'package:flutter/material.dart';

class MagTextform extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int? maxLines;
  MagTextform(
      {super.key,
      required this.hintText,
      required this.controller,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return '$hintText is missing';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    );
  }
}
