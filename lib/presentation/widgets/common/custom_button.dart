import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

/// Özelleştirilmiş buton widget'ı
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isOutlined;
  final bool isFullWidth;
  final double height;
  final double? width;
  final double borderRadius;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isOutlined = false,
    this.isFullWidth = true,
    this.height = 48.0,
    this.width,
    this.borderRadius = 10.0,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: textColor ?? ColorConstants.primaryRed,
            side: BorderSide(
              color: backgroundColor ?? ColorConstants.primaryRed,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            minimumSize: Size(isFullWidth ? double.infinity : width ?? 120, height),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? ColorConstants.primaryRed,
            foregroundColor: textColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            minimumSize: Size(isFullWidth ? double.infinity : width ?? 120, height),
          );

    final buttonContent = isLoading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: isOutlined
                  ? (backgroundColor ?? ColorConstants.primaryRed)
                  : (textColor ?? Colors.white),
              strokeWidth: 2.0,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          );

    return isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonContent,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonContent,
          );
  }
}