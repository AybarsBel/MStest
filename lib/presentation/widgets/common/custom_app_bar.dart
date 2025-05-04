import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

/// Özelleştirilmiş AppBar widget'ı
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? leading;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.leading,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? ColorConstants.textWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: backgroundColor ?? ColorConstants.backgroundBlack,
      elevation: 0,
      leading: showBackButton
          ? leading ??
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}