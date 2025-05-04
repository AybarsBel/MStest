import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/color_constants.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorConstants.textWhite,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          readOnly: readOnly,
          onTap: onTap,
          focusNode: focusNode,
          autofocus: autofocus,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            fillColor: ColorConstants.surfaceBlack,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: ColorConstants.primaryRed,
                width: 2,
              ),
            ),
          ),
          style: const TextStyle(
            color: ColorConstants.textWhite,
          ),
          cursorColor: ColorConstants.primaryRed,
        ),
      ],
    );
  }
}
