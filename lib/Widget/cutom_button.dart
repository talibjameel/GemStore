import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double width;
  final double height;
  final Color backgroundColor;
  final double borderRadius;
  final Color? borderColor;
  final VoidCallback onPressed;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.borderRadius,
    required this.onPressed,
    this.borderColor,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor ?? Colors.white, fontSize: fontSize ?? 16),
        ),
      ),
    );
  }
}
