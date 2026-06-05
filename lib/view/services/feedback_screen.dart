import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v3care/Constants/app_colors.dart';

import '../../Constants/app_sizes.dart';
import '../../Utils/api_helper.dart';
import '../../Utils/const_helper.dart';
import '../../controller/feedback_controller.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  FeedBackController feedBackController = Get.put(FeedBackController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode subjectFocusNode = FocusNode();
  FocusNode descriptionNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      /*  appBar: AppBar(
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
          "Feedback",
          style: GoogleFonts.inter(
            fontSize: Get.height / 40,
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
                  "Feedback",
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
            child: Obx(
              () => feedBackController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView(children: [
                            SizedBox(height: height * 0.03),
                            SvgPicture.asset(
                              'assets/images/svg/feedback_logo.svg',
                              height: Get.height * 0.12,
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              "Feedback",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  fontSize: Get.height / 45,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1),
                            ),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            Text(
                              "We value your opinion! Share your feedback with us.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: Get.height / 55,
                                color: AppColors.color80,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: height * 0.06),
                            TextFormField(
                              controller:
                                  feedBackController.subjectController.value,
                              onChanged: (value) {},
                              focusNode: subjectFocusNode,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                fontSize: Get.height / 50,
                                color: ConstHelper.blackColor,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                              maxLength: 50,
                              keyboardType: TextInputType.multiline,
                              cursorColor: ConstHelper.blackColor,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Feedback topic is required";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                fillColor: AppColors.colorF5,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                hintText: "Topic of feedback",
                                hintStyle: GoogleFonts.inter(
                                  fontSize: Get.height / 65,
                                  color: AppColors.color54,
                                  fontWeight: FontWeight.w400,
                                ),
                                counterText: "",
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.displayHeight(context) *
                                            0.015),
                                    borderSide: const BorderSide(
                                        color: AppColors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.displayHeight(context) *
                                            0.015),
                                    borderSide: const BorderSide(
                                        color: AppColors.grey)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.displayHeight(context) *
                                            0.015),
                                    borderSide: const BorderSide(
                                        color: AppColors.grey)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.displayHeight(context) *
                                            0.015),
                                    borderSide: const BorderSide(
                                        color: AppColors.grey)),
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            SizedBox(
                              height: 130,
                              child: TextFormField(
                                controller: feedBackController
                                    .descriptionController.value,
                                onChanged: (value) {},
                                textInputAction: TextInputAction.done,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                focusNode: descriptionNode,
                                maxLines: 5,
                                style: TextStyle(
                                  fontSize: Get.height / 50,
                                  color: ConstHelper.blackColor,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  height: 1.5,
                                ),
                                maxLength: 500,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return "Feedback description is required";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.multiline,
                                cursorColor: ConstHelper.blackColor,
                                decoration: InputDecoration(
                                  fillColor: AppColors.colorF5,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  hintText:
                                      "Detailed feedback description here...",
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: Get.height / 65,
                                    color: AppColors.color54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xffDDDDDD),
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xffDDDDDD),
                                      )),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xffDDDDDD),
                                      )),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xffDDDDDD),
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            GestureDetector(
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  try {
                                    var val = await ApiHelper.apiHelper
                                        .postFeedBackApi(
                                            sub: feedBackController
                                                .subjectController.value.text,
                                            des: feedBackController
                                                .descriptionController
                                                .value
                                                .text);
                                    if (kDebugMode) {
                                      print(val["code"]);
                                      print(val["msg"]);
                                      print(val);
                                    }
                                    if (val["code"].toString() == "200") {
                                      Get.snackbar(
                                        "Success",
                                        val["msg"].toString(),
                                        snackPosition: SnackPosition
                                            .BOTTOM, // Position: TOP or BOTTOM
                                      );
                                      await Future.delayed(
                                        const Duration(seconds: 1),
                                        () {
                                          feedBackController
                                              .subjectController.value
                                              .clear();
                                          feedBackController
                                              .descriptionController.value
                                              .clear();
                                          if(!mounted) return;
                                          Navigator.pop(this.context);
                                        },
                                      );
                                    } else {
                                      Get.snackbar(
                                        "Error!",
                                        val["msg"].toString(),
                                        snackPosition: SnackPosition
                                            .BOTTOM, // Position: TOP or BOTTOM
                                      );
                                    }
                                  } catch (e) {
                                    Get.snackbar(
                                      "Error!",
                                      ConstHelper.somethingWantWrongMsg,
                                      snackPosition: SnackPosition
                                          .BOTTOM, // Position: TOP or BOTTOM
                                    );
                                  }
                                } else {
                                  if (feedBackController
                                      .subjectController.value.text
                                      .trim()
                                      .isEmpty) {
                                    FocusScope.of(context)
                                        .requestFocus(subjectFocusNode);
                                  } else if (feedBackController
                                      .descriptionController.value.text
                                      .trim()
                                      .isEmpty) {
                                    FocusScope.of(context)
                                        .requestFocus(descriptionNode);
                                  }
                                }
                                /*if (feedBackController.subjectController.value.text
                              .trim()
                              .isEmpty) {
                            ConstHelper.errorDialog(
                              text: "Please Enter subject",
                              seconds: 10,
                            );
                          } else if (feedBackController
                              .descriptionController.value.text
                              .trim()
                              .isEmpty) {
                            ConstHelper.errorDialog(
                              text: 'Please Enter Description',
                              seconds: 10,
                            );
                          } else {
                            EasyLoading.show(
                              status: ConstHelper.pleaseWaitMsg,
                            );
                            try {
                              var val = await ApiHelper.apiHelper.postFeedBackApi(
                                  sub: feedBackController
                                      .subjectController.value.text,
                                  des: feedBackController
                                      .descriptionController.value.text);
                              print(val);
                              EasyLoading.dismiss();
                              ConstHelper.successDialog(
                                text: val["msg"],
                                seconds: 10,
                              );
                              feedBackController.subjectController.value.clear();
                              feedBackController.descriptionController.value
                                  .clear();
                            } catch (e) {
                              EasyLoading.dismiss();
                              ConstHelper.errorDialog(
                                text: ConstHelper.somethingWantWrongMsg,
                                seconds: 10,
                              );
                            }
                          }*/
                              },
                              child: Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(Get.height * 0.005),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  vertical: Get.width / 30,
                                ),
                                child: Text(
                                  'Submit Feedback',
                                  style: TextStyle(
                                      color: ConstHelper.whiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: Get.height / 50,
                                      letterSpacing: 1),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                          ]),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    ));
  }
}
