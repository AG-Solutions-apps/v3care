import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v3care/Constants/app_colors.dart';

import '../../Utils/shared_pref_helper.dart';
import '../../controller/home_controller.dart';
import '../../widget/common_button.dart';
import '../bottom_menu_screen/bottom_menu_page.dart';
import '../login_screen/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    bool login = false;
    try {
      login = SharedPrefHelper.sharedPreferences.getBool('login') ?? false;
    } catch (error) {
      login = false;
    }
    Timer(
      Duration(
        seconds: login ? 1 : 5,
      ),
      () {
        EasyLoading.dismiss();

        if (login) {
          Get.offAll(
            () => const BottomMenuPage(),
            transition: Transition.fadeIn,
          );
        } else {
          Get.offAll(
            () => const LoginPage(),
            transition: Transition.fadeIn,
          );
        }
      },
    );

    // FirebaseHelper.firebaseHelper.initializeFirebaseMessaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.4,
            child: Image.asset(
              'assets/images/v3_bg.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  'assets/images/v3_logo.png',
                  fit: BoxFit.fill,
                  height: Get.width / 1.8,
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Text(
                  "Welcome to V3 Care",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.dmSans(
                    fontSize: Get.width * 0.075,
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                Text(
                  "South India's leading cleaning service, trusted for reliability and excellence. Our expert team delivers tailored solutions for homes, businesses, and industries. Experience unmatched cleanliness, exceptional service, and competitive pricing. ",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.inter(
                    fontSize: Get.height / 50,
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        buttonText: "Let's Get Started",
                        onTap: () async {
                          EasyLoading.show(status: "Please wait...");

                          await Future.delayed(
                              const Duration(milliseconds: 100));
                          bool login = false;

                          try {
                            login = SharedPrefHelper.sharedPreferences
                                    .getBool('login') ??
                                false;
                          } catch (error) {
                            login = false;
                          }

                          EasyLoading.dismiss();

                          if (login) {
                            Get.offAll(
                              () => const BottomMenuPage(),
                              transition: Transition.fadeIn,
                            );
                          } else {
                            Get.offAll(
                              () => const LoginPage(),
                              transition: Transition.fadeIn,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.07,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
