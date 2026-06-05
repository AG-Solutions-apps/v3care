import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v3care/Constants/app_colors.dart';

import '../Constants/app_defaults.dart';
import '../Constants/app_sizes.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.maxLength,
    this.obscureText,
    this.textAlign,
    this.textInputAction,
    this.onEditingComplete,
    this.textCapitalization,
    this.suffixIcon,
    this.counterText,
    this.label,
    this.bgColor,
    this.enabled,
    this.isSmall,
    this.readOnly,
    this.isBarcode,
    this.inputFormatters,
    this.onChanged,
    this.maxLines,
    this.autoValidateMode,
    this.autofocus,
    this.focusNode,
    this.onTap,
    this.contentPadding,
    this.isCenter,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? counterText;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final int? maxLength;
  final Color? bgColor;
  final int? maxLines;
  final TextCapitalization? textCapitalization;
  final bool? obscureText;
  final bool? enabled;
  final bool? autofocus;
  final bool? isCenter;
  final bool? isSmall;
  final bool? readOnly;
  final bool? isBarcode;
  final EdgeInsetsGeometry? contentPadding;
  final AutovalidateMode? autoValidateMode;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.poppins(
      fontSize: Get.width * 0.045,
      fontWeight: FontWeight.w500,
    );

    return Column(
      crossAxisAlignment: isCenter == true
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (label != null && label!.trim().isNotEmpty) ...[
          Text(label!, style: AppDefaults.textStyleSemiBold12()),
          AppSizes.hGap8,
        ],
        TextFormField(
          controller: controller,
          style: baseStyle,
          autovalidateMode:
              autoValidateMode ?? AutovalidateMode.onUserInteraction,
          autofocus: autofocus ?? false,
          focusNode: focusNode,
          validator: validator,
          keyboardType: keyboardType,
          textAlign: textAlign ?? TextAlign.start,
          maxLength: maxLength,
          readOnly: readOnly ?? false,
          obscureText: obscureText ?? false,
          textInputAction: textInputAction ?? TextInputAction.next,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          onEditingComplete: onEditingComplete,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            labelStyle: baseStyle.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: Get.width * 0.045),
            hintStyle: baseStyle.copyWith(color: Colors.black.withAlpha(128)),
            counterText: counterText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: AppSizes.displayWidth(context) * 0.04,
                  vertical: AppSizes.displayHeight(context) * 0.02,
                ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    AppSizes.displayHeight(context) * 0.015),
                borderSide: const BorderSide(color: AppColors.grey)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    AppSizes.displayHeight(context) * 0.015),
                borderSide: const BorderSide(color: AppColors.grey)),
            filled: true,
            fillColor: bgColor ?? AppColors.lightGrey,
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}

class CustomSearchTextFormField extends StatelessWidget {
  const CustomSearchTextFormField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.maxLength,
    this.obscureText,
    this.textAlign,
    this.textInputAction,
    this.onEditingComplete,
    this.suffixIcon,
    this.counterText,
    this.label,
    this.enabled,
    this.isSmall,
    this.readOnly,
    this.isBarcode,
    this.inputFormatters,
    this.onChanged,
    this.maxLines,
    this.onBarcodeScan,
    this.autoValidateMode,
    this.autofocus,
    this.focusNode,
    this.items,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? counterText;
  final String? label;
  final String? items;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final int? maxLength;
  final int? maxLines;
  final bool? obscureText;
  final bool? enabled;
  final bool? autofocus;
  final bool? isSmall;
  final bool? readOnly;

  final bool? isBarcode;

  final AutovalidateMode? autoValidateMode;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final void Function()? onBarcodeScan;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null
            ? Text(
                label ?? "",
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.displayMedium,
                  fontSize: Get.width * 0.045,
                  fontWeight: FontWeight.w500,
                ),
              )
            : const SizedBox(),
        label != null ? AppSizes.hGap8 : const SizedBox(),
        TextFormField(
          controller: controller,
          autovalidateMode:
              autoValidateMode ?? AutovalidateMode.onUserInteraction,
          autofocus: autofocus ?? false,
          focusNode: focusNode,
          validator: validator,
          keyboardType: keyboardType,
          textAlign: textAlign ?? TextAlign.start,
          maxLength: maxLength,
          readOnly: readOnly ?? false,
          obscureText: obscureText ?? false,
          textInputAction: textInputAction ?? TextInputAction.next,
          onEditingComplete: onEditingComplete,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: maxLines ?? 1,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : inputFormatters ??
                  [
                    FilteringTextInputFormatter.deny(RegExp(r' \s')),
                  ],
          decoration: InputDecoration(
              counterText: counterText ?? "",
              prefixIcon: prefixIcon,
              errorStyle: TextStyle(
                color: Colors.red,
                fontSize: Get.width * 0.03,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.displayWidth(context) * .06,
                  vertical: AppSizes.displayHeight(context) * .01),
              border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppSizes.displayHeight(context) * .04),
                  borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppSizes.displayHeight(context) * .04),
                  borderSide: BorderSide.none),
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppSizes.displayHeight(context) * .04),
                  borderSide: BorderSide.none),
              errorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppSizes.displayHeight(context) * .04),
                  borderSide: const BorderSide(color: Colors.red)),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: suffixIcon),
        ),
      ],
    );
  }
}
