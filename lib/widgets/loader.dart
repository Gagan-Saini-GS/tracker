import 'package:flutter/material.dart';
import 'package:tracker/utils/constants.dart';

class Loader extends StatelessWidget {
  final String title;
  final bool showText;
  final double loaderSize;
  final double? stroke;
  final double? containerWidth;
  final double? containerPadding;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool transparent;
  final bool isCenter;
  final TextStyle? textStyle;
  final double borderRadius;

  const Loader({
    super.key,
    this.title = "Loading...",
    this.showText = true,
    this.loaderSize = 40.0,
    this.stroke = 5.0,
    this.containerWidth = double.infinity,
    this.containerPadding = 20.0,
    this.foregroundColor,
    this.backgroundColor,
    this.transparent = false,
    this.isCenter = true,
    this.textStyle,
    this.borderRadius = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    final Color fgColor = foregroundColor ?? whiteColor;
    final Color bgColor = backgroundColor ?? greenColor;
    return Container(
      padding: EdgeInsets.all(containerPadding ?? 20.0),
      width: containerWidth,
      decoration: BoxDecoration(
        color: transparent ? Colors.transparent : whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: isCenter
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: loaderSize,
            height: loaderSize,
            child: CircularProgressIndicator(
              backgroundColor: bgColor,
              color: fgColor,
              strokeWidth: stroke,
            ),
          ),
          if (showText) ...[
            const SizedBox(height: 16),
            Text(title, style: textStyle ?? const TextStyle(fontSize: 18)),
          ],
        ],
      ),
    );
  }
}
