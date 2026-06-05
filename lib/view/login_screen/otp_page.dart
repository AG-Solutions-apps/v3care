import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:another_telephony/telephony.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../Constants/app_colors.dart';
import '../../Utils/api_helper.dart';
import '../../Utils/const_helper.dart';
import '../../Utils/firebase_helper.dart';
import '../../Utils/shared_pref_helper.dart';
import '../../controller/home_controller.dart';
import '../../model/user_model.dart';
import '../../widget/common_bg_widget.dart';
import '../../widget/common_button.dart';
import '../bottom_menu_screen/bottom_menu_page.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  HomeController homeController = Get.put(HomeController());
  TextEditingController otpController = TextEditingController();
  final otp = "".obs;
  RxString verify = ''.obs;
  RxInt resendToken = 0.obs;
  final start = 60.obs;
  FocusNode otpFocusNode = FocusNode();
  final isResending = false.obs;

  Timer? _timer;

  void startTimer() {
    _timer?.cancel(); // Cancel previous timer if any
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start.value == 0) {
        timer.cancel();
      } else {
        start.value--;
      }
      setState(() {});
    });
  }

  final telephony = Telephony.instance;

  int backspaceCount = 0;

  @override
  void initState() {
    startOtpTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /* void listenToIncomingSMS(BuildContext context) {
    otpController.clear();

    debugPrint("Listening to sms.");
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          // Handle message
          debugPrint("sms received : ${message.body}");
          // verify if we are reading the correct sms or not

          if (message.body!.contains("aiagroup-3cd93.firebaseapp.com")) {
            String otpCode = message.body!.substring(0, 6);
            // List<String> otpCharacters = otpCode.split('');
            debugPrint("OTP::::::$otpCode");
            setState(() {
              otpController.text = otpCode.substring(0, 6).toString();
              // for (var char in otpCharacters) {}
              // wait for 1 sec and then press handle submit
              // Future.delayed(Duration(seconds: 1), () {
              //   handleSubmit(context);
              // });
            });
          }
        },
        listenInBackground: false);
  }*/

  // void _listenForOtp() {
  //   SmsAutoFill().listenForCode();
  //   SmsAutoFill().code.listen((code) {
  //     print("SMS Autofill Code: $code"); // Debug print
  //     setState(() {
  //       _otp = code;
  //     });
  //   });
  // }
  startOtpTimer() {
    start.value = 60;
    startTimer();
    setState(() {});
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> sendOTP() async {
    startOtpTimer();
    EasyLoading.show(
      status: ConstHelper.pleaseWaitMsg,
    );
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91 ${homeController.mobileNo.value}',
      verificationCompleted: (PhoneAuthCredential credential) {
        if (kDebugMode) {
          print('verificationId: ${credential.verificationId}~~${credential.smsCode}');
          print('smsCode: ${credential.smsCode}~~${credential.token}');
          print('accessToken: ${credential.accessToken}~~${credential.providerId}');
          print('signInMethod: ${credential.signInMethod}');
        }
        EasyLoading.dismiss();
      },
      verificationFailed: (FirebaseAuthException e) async {
        // EasyLoading.dismiss();
        if (kDebugMode) {
          print('Error~~ : ${e.code}~${e.message}');
        }
        if (e.code == 'invalid-phone-number') {
          EasyLoading.dismiss();
          ConstHelper.errorDialog(
            text: ConstHelper.invalidPhoneNumberErrorMsg,
            seconds: 10,
          );
        } else if (e.code == 'too-many-requests') {
          EasyLoading.dismiss();
          ConstHelper.errorDialog(
            text: ConstHelper.manyRequestErrorMsg,
            seconds: 10,
          );
        } else if (e.code == 'unknown') {
          EasyLoading.dismiss();
          ConstHelper.errorDialog(
            text: ConstHelper.unknownErrorMsg,
            seconds: 10,
          );
        } else {
          EasyLoading.dismiss();
          ConstHelper.errorDialog(
            text: ConstHelper.somethingErrorMsg,
            seconds: 10,
          );
        }
        // print('Error~~ : ${e.credential ?? {}}~${e.email}');
        // print('Error~~ : ${e.tenantId}~${e.plugin}');
        // print('Error~~ : ${jsonEncode(e.stackTrace ??{})}~${e.phoneNumber}');
        // print('Error~~ : ${jsonEncode(e)}');
        log(e.toString());
      },
      codeSent: (String verificationId, int? resendToken) {
        otpController.clear();
        EasyLoading.dismiss();

        if (kDebugMode) {
          print('Success : $verificationId $resendToken');
        }
        homeController.otpResendCode.value = resendToken ?? 0;
        homeController.otpVerificationId.value = verificationId;
        Get.snackbar(
          "Success",
          "Otp Sent Successfully",
          snackPosition: SnackPosition.BOTTOM, // Position: TOP or BOTTOM
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('TimeoutError : $verificationId');
        }
        // EasyLoading.dismiss();
      },
    );
  }

  //
  // @override
  // void dispose() {
  //   SmsAutoFill().unregisterListener(); // Stop listening when the widget is disposed
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        // appBar: AppBar(
        //   title: Text('OTP'.tr,),
        // ),
        backgroundColor: ConstHelper.whiteColor, //726323
        body: CommonBgWidget(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.04,
            ),
            child: Form(
              key: formKey,
              child: SizedBox(
                width: Get.width,
                height: Get.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Get.width / 2.9,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "OTP ",
                            style: GoogleFonts.roboto(
                              fontSize: Get.height / 22,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: "Confirmation",
                            style: GoogleFonts.roboto(
                              fontSize: Get.height / 22,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Text(
                      "Enter the SMS code sent to your phone",
                      style: GoogleFonts.roboto(
                        fontSize: Get.height / 55,
                        color: Colors.black.withAlpha(204),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: homeController.txtUsername.text,
                            style: GoogleFonts.roboto(
                              fontSize: Get.height / 40,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: " Edit Number",
                            style: GoogleFonts.roboto(
                              fontSize: Get.height / 60,
                              color: AppColors.colorB0,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.back();
                                // Add your action here, like opening a dialog or navigating
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height / 6,
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        length: 6,
                        controller: otpController,
                        focusNode: otpFocusNode,
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter otp";
                          } else if (value.isNotEmpty && value.length != 6) {
                            return "Please enter valid otp";
                          }
                          return null;
                        },
                        followingPinTheme: PinTheme(
                          width: Get.width * 0.12,
                          height: Get.width * 0.12,
                          textStyle: TextStyle(
                              fontSize: Get.width * 0.055, color: Colors.black),
                          decoration: BoxDecoration(
                            color: AppColors.rockColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(51),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 3), // Shadow position
                              ),
                            ],
                          ),
                        ),
                        disabledPinTheme: PinTheme(
                          width: Get.width * 0.12,
                          height: Get.width * 0.12,
                          textStyle: TextStyle(
                              fontSize: Get.width * 0.055, color: Colors.black),
                          decoration: BoxDecoration(
                            color: AppColors.rockColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(51),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 3), // Shadow position
                              ),
                            ],
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: Get.width * 0.12,
                          height: Get.width * 0.12,
                          textStyle: TextStyle(
                              fontSize: Get.width * 0.055, color: Colors.black),
                          decoration: BoxDecoration(
                            color: AppColors.rockColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(51),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 3), // Shadow position
                              ),
                            ],
                          ),
                        ),
                        defaultPinTheme: PinTheme(
                          width: Get.width * 0.12,
                          height: Get.width * 0.12,
                          textStyle: TextStyle(
                              fontSize: Get.width * 0.055, color: Colors.black),
                          decoration: BoxDecoration(
                            color: AppColors.rockColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(51),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 3), // Shadow position
                              ),
                            ],
                          ),
                        ),
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 0),
                              width: 1,
                              height: 22,
                              color: AppColors.black,
                            ),
                          ],
                        ),
                        onCompleted: (String verificationCode) {
                          FocusScope.of(context).unfocus();
                          debugPrint('Entered OTP: $verificationCode');
                        },
                        onChanged: (code) {
                          debugPrint('OTP Changed: $code');
                        },
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: Get.width * 0.045),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            start.value == 0
                                ? "Didn't receive OTP ? "
                                : "Resend OTP in ",
                            style: GoogleFonts.dmSans(
                              fontSize: Get.height / 55,
                              color: Colors.black.withAlpha(204),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          start.value != 0
                              ? Text(
                                  "00:${start.value.toString().padLeft(2, '0')}",
                                  style: GoogleFonts.dmSans(
                                    fontSize: Get.height / 55,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    if (!(await ConstHelper.checkInternet())) {
                                      EasyLoading.dismiss();
                                      Get.snackbar(
                                        "No Internet",
                                        'Please check your internet connection',
                                        snackPosition: SnackPosition
                                            .BOTTOM, // Position: TOP or BOTTOM
                                      );
                                      return;
                                    }
                                    if (isResending.value) return;
                                    isResending.value = true;
                                    await sendOTP();
                                    isResending.value = false;
                                  },
                                  child: Text(
                                    " Resend NOW!",
                                    style: GoogleFonts.dmSans(
                                      fontSize: Get.height / 50,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.07,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          width: Get.width * 0.65,
                          buttonText: "Confirm OTP",
                          onTap: () async {
                            otpFocusNode.unfocus();

                            if (!formKey.currentState!.validate()) {
                              if (otpController.text.isEmpty) {
                                otpFocusNode.requestFocus();
                                Get.snackbar(
                                  "OTP",
                                  "Please enter otp",
                                  snackPosition: SnackPosition
                                      .BOTTOM, // Position: TOP or BOTTOM
                                );
                              }
                              if (otpController.text.isNotEmpty &&
                                  otpController.text.length != 6) {
                                otpFocusNode.requestFocus();
                                Get.snackbar(
                                  "OTP",
                                  "Please enter valid otp",
                                  snackPosition: SnackPosition
                                      .BOTTOM, // Position: TOP or BOTTOM
                                );
                              }
                            } else {
                              if (!(await ConstHelper.checkInternet())) {
                                EasyLoading.dismiss();
                                Get.snackbar(
                                  "No Internet",
                                  'Please check your internet connection',
                                  snackPosition: SnackPosition
                                      .BOTTOM, // Position: TOP or BOTTOM
                                );
                                return;
                              }
                              /*EasyLoading.show(
                                status: ConstHelper.pleaseWaitMsg,
                              );
                              await Future.delayed(
                                const Duration(
                                  milliseconds: 100,
                                ),
                              );

                              print(homeController.mobileNo);
                              print(homeController.password);
                              await ApiHelper.apiHelper
                                  .loginUser(
                                mobileNo: homeController.mobileNo.trim(),
                                password: otpController.text.trim(),
                                deviceId: homeController.firebaseFCMToken.value,
                              )
                                  .then((userData) async {
                                print(userData);
                                if (userData['code'] == 200) {
                                  UserDataModel userDataModel =
                                      UserDataModel.fromJson(userData);
                                  SharedPrefHelper.sharedPreferences.setString(
                                    'userData',
                                    jsonEncode(userDataModel),
                                  );
                                  SharedPrefHelper.sharedPreferences.setBool(
                                    'login',
                                    true,
                                  );
                                  await homeController.getUserData();
                                  EasyLoading.dismiss();
                                  homeController.bottomIndex.value = 0;
                                  Get.offAll(
                                    const BottomMenuPage(),
                                  );
                                  Get.snackbar(
                                    "Success",
                                    "Successfully login",
                                    snackPosition: SnackPosition
                                        .BOTTOM, // Position: TOP or BOTTOM
                                  );
                                } else {
                                  EasyLoading.dismiss();
                                  ConstHelper.errorDialog(
                                    text: userData['msg'] ??
                                        ConstHelper.unauthorizedMsg,
                                    seconds: 10,
                                  );
                                }
                              });*/
                              try {
                                EasyLoading.show(
                                  status: ConstHelper.pleaseWaitMsg,
                                );
                                FirebaseAuth firebaseAuth =
                                    FirebaseAuth.instance;
                                String otp = otpController.text;
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                  verificationId:
                                      homeController.otpVerificationId.value,
                                  smsCode: otp,
                                );
                                // Sign the user in (or link) with the credential

                                await firebaseAuth
                                    .signInWithCredential(credential)
                                    .then(
                                  (value) async {
                                    homeController.firebaseFCMToken.value =
                                        await FirebaseHelper.firebaseHelper
                                            .getFirebaseToken();

                                    await Future.delayed(
                                      const Duration(
                                        milliseconds: 100,
                                      ),
                                    );
                                    if (kDebugMode) {
                                      print(homeController.mobileNo);
                                      print(homeController.password);
                                    }
                                    await ApiHelper.apiHelper
                                        .loginUser(
                                      mobileNo: homeController.mobileNo.trim(),
                                      password: homeController.password.value,
                                      deviceId:
                                          homeController.firebaseFCMToken.value,
                                    )
                                        .then((userData) async {
                                      if (kDebugMode) {
                                        print(userData);
                                      }
                                      if (userData['code'] == 200) {
                                        UserDataModel userDataModel =
                                            UserDataModel.fromJson(userData);
                                        SharedPrefHelper.sharedPreferences
                                            .setString(
                                          'userData',
                                          jsonEncode(userDataModel),
                                        );
                                        SharedPrefHelper.sharedPreferences
                                            .setBool(
                                          'login',
                                          true,
                                        );
                                        await homeController.getUserData();
                                        EasyLoading.dismiss();
                                        homeController.bottomIndex.value = 0;
                                        Get.offAll(
                                          const BottomMenuPage(),
                                        );
                                        Get.snackbar(
                                          "Success",
                                          "Login Successful ✅",
                                          snackPosition: SnackPosition
                                              .BOTTOM, // Position: TOP or BOTTOM
                                        );
                                      } else {
                                        EasyLoading.dismiss();
                                        ConstHelper.errorDialog(
                                          text: userData['msg'] ??
                                              ConstHelper.unauthorizedMsg,
                                          seconds: 10,
                                        );
                                      }
                                    });
                                  },
                                );
                              } on FirebaseAuthException catch (error) {
                                if (kDebugMode) {
                                  print(
                                    'Error~~ : ${error.code},${error.message}');
                                }
                                if (error.code == 'invalid-verification-code') {
                                  EasyLoading.dismiss();
                                  Get.snackbar(
                                    "Invalid Otp",
                                    ConstHelper.invalidOTPErrorMsg,
                                    snackPosition: SnackPosition
                                        .BOTTOM, // Position: TOP or BOTTOM
                                  );
                                } else {
                                  EasyLoading.dismiss();
                                  Get.snackbar(
                                    "Error!",
                                    ConstHelper.somethingErrorMsg,
                                    snackPosition: SnackPosition
                                        .BOTTOM, // Position: TOP or BOTTOM
                                  );
                                }
                              } catch (error) {
                                if (kDebugMode) {
                                  print('Error : $error');
                                }
                                EasyLoading.dismiss();
                                Get.snackbar(
                                  "Error!",
                                  ConstHelper.somethingErrorMsg,
                                  snackPosition: SnackPosition
                                      .BOTTOM, // Position: TOP or BOTTOM
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkAllOTPFill() {
    // if (txtOTP1.text.trim().isNotEmpty &&
    //     txtOTP2.text.trim().isNotEmpty &&
    //     txtOTP3.text.trim().isNotEmpty &&
    //     txtOTP4.text.trim().isNotEmpty &&
    //     txtOTP5.text.trim().isNotEmpty &&
    //     txtOTP6.text.trim().isNotEmpty) {
    //   otp1FocusNode.unfocus();
    //   otp2FocusNode.unfocus();
    //   otp3FocusNode.unfocus();
    //   otp4FocusNode.unfocus();
    //   otp5FocusNode.unfocus();
    //   otp6FocusNode.unfocus();
    // }
  }

  InputDecoration otpInputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: ConstHelper.darkBlueColor,
        width: 1.8,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: ConstHelper.darkBlueColor,
        width: 1.8,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: ConstHelper.darkBlueColor,
        width: 1.8,
      ),
    ),
    contentPadding: EdgeInsets.symmetric(
        horizontal: Get.width / 30, vertical: Get.width / 60),
    counterText: '',
    // hintText: "OTP",
    // hintStyle: TextStyle(color: ConstHelper.greyFigmaColor,),
  );
}
