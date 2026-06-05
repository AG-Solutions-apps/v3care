import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final double heightFactor;
  final double? width;
  final double? fontSize;
  final double? radius;
  final void Function()? onTap;
  final Color backgroundColor;
  final Color textColor;
  final bool isLoading; // Externally controlled loading state

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.width,
    this.fontSize,
    this.heightFactor = 17,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = AppColors.white,
    this.radius,
    this.isLoading = false, // Default: not loading
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        height: Get.height / heightFactor,
        width: width,
        decoration: BoxDecoration(
          color: isLoading ? AppColors.grey : backgroundColor,
          borderRadius: BorderRadius.circular(radius ?? Get.width * 0.2),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                buttonText,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: fontSize ?? Get.height / 55,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }
}
