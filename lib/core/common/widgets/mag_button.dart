import 'package:flutter/material.dart';
import 'package:magspot/core/theme/app_pallete.dart';

class MagButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const MagButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color.fromARGB(255, 128, 11, 160),
            Color.fromARGB(255, 161, 23, 81)
          ], begin: Alignment.bottomLeft, end: Alignment.topRight),
          borderRadius: BorderRadius.circular(7)),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
          fixedSize: const Size(395, 55),
        ),
        child: Text(buttonText,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
