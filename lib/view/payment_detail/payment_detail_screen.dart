import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constants/app_colors.dart';
import '../../../controller/home_controller.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.bgColor,
      /* appBar: AppBar(
        backgroundColor: ConstHelper.whiteColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Center(
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.secondaryColor,
            ),
          ),
        ),
        title: Text(
          "Payment Details",
          style: GoogleFonts.inter(
            fontSize: Get.height / 45,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),*/
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.05, vertical: Get.height * 0.02),
            decoration: const BoxDecoration(
              color: AppColors.white,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.08,
                ),
                Text(
                  "Payment Details",
                  style: GoogleFonts.inter(
                    fontSize: Get.height / 45,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vikas Kumar Khaitan",
                      style: GoogleFonts.inter(
                          fontSize: Get.height / 35,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Image.asset(
                      "assets/images/scanner.png",
                      height: Get.height * 0.3,
                    ),
                    SizedBox(
                      height: Get.height * 0.06,
                    ),
                    Text(
                      "Scan & Pay With Any UPI App",
                      style: GoogleFonts.inter(
                          fontSize: Get.height / 50,
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
