import 'package:flutter/material.dart';


class TextWidget extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontStyle? fontStyle;
  final double? lineHeight;
  final bool? softWrap;
  final TextWidthBasis? textWidthBasis;
  final TextDecoration? decoration;

  const TextWidget({
    super.key,
    this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontStyle,
    this.lineHeight,
    this.softWrap,
    this.textWidthBasis,
    this.decoration,
  });

  bool isRTL(String input) {
    final rtlChars = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    return rtlChars.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    final double smartFontSize = _getSmartFontSize(context, fontSize ?? 14);

    return Directionality(
      textDirection: isRTL(text ?? '') ? TextDirection.rtl : TextDirection.ltr,
      child: Text(
        text ?? '',
        style: TextStyle(
          fontSize: smartFontSize,
          color: color ?? DefaultTextStyle.of(context).style.color,
          fontWeight: fontWeight ?? FontWeight.normal,
          fontStyle: fontStyle,
          fontFamily: "SF-Pro",
          height: lineHeight != null ? _getLineHeight(lineHeight!, smartFontSize) : null,
          decoration: decoration,
        ),
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textWidthBasis: textWidthBasis,
      ),
    );
  }

  /// Smart font sizing logic based on device width
  double _getSmartFontSize(BuildContext context, double baseSize) {
    double width = MediaQuery.of(context).size.width;
    double ratio = 1.0;

    if (width < 320) {ratio = 0.85;}
    else if (width < 360) {ratio = 0.90;}
    else if (width < 375) {ratio = 1.0;}
    else if (width < 415) {ratio = 1.01;}
    else if (width < 480) {ratio = 1.1;}
    else if (width < 600) {ratio = 1.2;}
    else if (width < 720) {ratio = 1.3;}
    else if (width < 1080) {ratio = 1.4;}
    else {ratio = 1.5;}

    return (baseSize * ratio);
  }

  /// Converts pixel-based line height to Flutter's TextStyle.height multiplier
  double _getLineHeight(double lineHeightPx, double fontSizePx) {
    return lineHeightPx / fontSizePx;
  }
}


String toTitleCase(String input) {
  return input.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}


