import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v3care/Constants/app_colors.dart';

import '../Utils/const_helper.dart';
import 'common_button.dart';

class CommonDoneWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? image;
  final String? date;
  final String? time;
  final String? rs;
  final String? address;
  final String? isAssigned;
  final List<String>? statusList;
  final dynamic Function()? onTap;

  const CommonDoneWidget(
      {super.key,
      this.title,
      this.subTitle,
      this.date,
      this.time,
      this.rs,
      this.address,
      this.isAssigned,
      this.onTap,
      this.image,
      this.statusList});

  @override
  Widget build(BuildContext context) {
    if (isAssigned == "Assigned") {
      return Container(
        color: AppColors.white,
        width: Get.width * 0.8,
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child:
                        SvgPicture.asset("assets/images/svg/close_icon.svg"))),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(Get.height * 0.01),
                ),
                child: CachedNetworkImage(
                  imageUrl: image ?? "",
                  fit: BoxFit.cover,
                  height: Get.height * 0.2,
                  width: Get.height * 0.2,
                  placeholder: (context, url) => CircularProgressIndicator(
                    color: ConstHelper.darkBlueColor,
                  ),
                  errorWidget: (context, url, error) =>
                      Image.network(ConstHelper.noImage, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Text(
              "Update Status",
              style: GoogleFonts.inter(
                fontSize: Get.height / 40,
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.01,
                    ),
                    padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
                    decoration: BoxDecoration(
                      color: index == 0
                          ? AppColors.lightBlueColor
                          : index == 1
                              ? AppColors.lightGoldColor
                              : AppColors.greenLightColor,
                      border: Border.all(
                        color: index == 0
                            ? AppColors.blueColor
                            : index == 1
                                ? AppColors.goldColor
                                : AppColors.greenColor,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(Get.height * 0.02),
                      ),
                    ),
                    child: Text(
                      index == 0
                          ? "On the way"
                          : index == 1
                              ? "In Progress"
                              : "Completed",
                      style: GoogleFonts.inter(
                        fontSize: Get.height / 70,
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            const Divider(),
            SizedBox(height: Get.height * 0.01),
            Text(
              title ?? "",
              style: GoogleFonts.inter(
                fontSize: Get.height / 52,
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            Text(
              subTitle ?? "",
              style: GoogleFonts.inter(
                fontSize: Get.height / 60,
                color: AppColors.color54,
                fontWeight: FontWeight.w400,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: Get.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.02,
                      vertical: Get.height * 0.005),
                  decoration:
                      const BoxDecoration(color: AppColors.lightGoldColor),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/svg/calendar.svg"),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      Text(
                        date ?? "",
                        style: GoogleFonts.inter(
                          fontSize: Get.height / 70,
                          color: AppColors.goldColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.02,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.02,
                      vertical: Get.height * 0.005),
                  decoration:
                      const BoxDecoration(color: AppColors.lightGoldColor),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/svg/clock.svg"),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      Text(
                        time ?? "",
                        style: GoogleFonts.inter(
                          fontSize: Get.height / 70,
                          color: AppColors.goldColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.02,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.02,
                      vertical: Get.height * 0.005),
                  decoration:
                      const BoxDecoration(color: AppColors.greenLightColor),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/svg/coin.svg"),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      Text(
                        rs ?? "",
                        style: GoogleFonts.inter(
                          fontSize: Get.height / 70,
                          color: AppColors.greenColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.01),
            Text(
              address ?? "",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: Get.height / 60,
                color: AppColors.color70,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: Get.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  width: Get.width * 0.3,
                  heightFactor: 19,
                  buttonText: isAssigned == "Assigned" ? "Save" : "Done",
                  backgroundColor: AppColors.color80,
                  onTap: () async {
                    Get.back();
                    if (onTap != null) onTap!();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container(
      color: AppColors.white,
      width: Get.width * 0.8,
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: SvgPicture.asset("assets/images/svg/close_icon.svg"))),
          SvgPicture.asset("assets/images/svg/done_icon.svg"),
          SizedBox(
            height: Get.height * 0.03,
          ),
          Text(
            "Accepted".toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: Get.height / 35,
              color: AppColors.greenColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          Text(
            "Accepted the work to do",
            style: GoogleFonts.inter(
              fontSize: Get.height / 60,
              color: AppColors.black,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          const Divider(),
          SizedBox(height: Get.height * 0.01),
          Text(
            title ?? "",
            style: GoogleFonts.inter(
              fontSize: Get.height / 50,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          Text(
            subTitle ?? "",
            style: GoogleFonts.inter(
              fontSize: Get.height / 60,
              color: AppColors.black,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: Get.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.02, vertical: Get.height * 0.005),
                decoration:
                    const BoxDecoration(color: AppColors.lightGoldColor),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/images/svg/calendar.svg"),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    Text(
                      date ?? "",
                      style: GoogleFonts.inter(
                        fontSize: Get.height / 70,
                        color: AppColors.goldColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Get.width * 0.02,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.02, vertical: Get.height * 0.005),
                decoration:
                    const BoxDecoration(color: AppColors.lightGoldColor),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/images/svg/clock.svg"),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    Text(
                      time ?? "",
                      style: GoogleFonts.inter(
                        fontSize: Get.height / 70,
                        color: AppColors.goldColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Get.width * 0.02,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.02, vertical: Get.height * 0.005),
                decoration:
                    const BoxDecoration(color: AppColors.greenLightColor),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/images/svg/coin.svg"),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    Text(
                      rs ?? "",
                      style: GoogleFonts.inter(
                        fontSize: Get.height / 70,
                        color: AppColors.greenColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.03),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.005),
                  child: SvgPicture.asset(
                    "assets/images/svg/location.svg",
                    height: Get.height * 0.025,
                  )),
              SizedBox(width: Get.width * 0.02),
              Expanded(
                child: Text(
                  address ?? "",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.inter(
                    fontSize: Get.height / 60,
                    color: AppColors.secondaryColor,
                    letterSpacing: 1,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                width: Get.width * 0.35,
                heightFactor: Get.height * 0.02,
                buttonText: isAssigned == "Assigned" ? "Save" : "Done",
                backgroundColor: AppColors.greenColor,
                onTap: () async {
                  Get.back();
                  if (onTap != null) onTap!();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
