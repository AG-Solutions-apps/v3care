import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/app_colors.dart';
import '../../Utils/api_helper.dart';
import '../../Utils/const_helper.dart';
import '../../controller/home_controller.dart';
import '../../model/about_us_model.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({
    super.key,
  });

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  HomeController homeController = Get.put(HomeController());
  AboutUsModel aboutUsModel = AboutUsModel();
  RxBool loader = true.obs;

  @override
  void initState() {
    getAboutUsData();
    super.initState();
  }

  void getAboutUsData() async {
    await ApiHelper.apiHelper.getAboutUsData().then((value) {
      setState(() {
        aboutUsModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // getUpcomingClass();
    return SafeArea(
      child: Scaffold(
        /* appBar: CustomAppbar(
          title: "About us",
          appBarHeight: Get.height * 0.06,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColors.secondaryColor,
            ),
          ),
        ),*/
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: Get.width * 0.05,
                  right: Get.width * 0.05,
                  top: Get.height * 0.02,
                  bottom: Get.height * 0.01),
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
                    "About us",
                    style: GoogleFonts.inter(
                      fontSize: Get.height / 45,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /* SizedBox(
                height: Get.height * 0.02,
              ),*/
                    Image.asset(
                      "assets/images/v3_logo.png",
                      fit: BoxFit.cover,
                      height: Get.height / 7,
                    ),
                    SizedBox(
                      height: Get.height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Get.height * 0.014,
                                horizontal: Get.width * 0.06),
                            decoration: BoxDecoration(
                                color:
                                AppColors.primaryColor.withAlpha((0.05 * 255).round())),
                            child: Text(
                              "Who we are",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                fontSize: Get.height / 40,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                      child: Column(
                        children: [
                          Text(
                            aboutUsModel.data?.companyAbout ?? "",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.openSans(
                              fontSize: Get.height / 60,
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          IconTextRow(
                            icon: Icons.email,
                            text: aboutUsModel.data?.companyEmail ?? "",
                            iconColor: AppColors.primaryColor,
                            textColor: AppColors.secondaryColor,
                            onTap: () {
                              if (aboutUsModel.data?.companyEmail != null &&
                                  aboutUsModel.data!.companyEmail!.isNotEmpty) {
                                _launchURL(
                                    "mailto:${aboutUsModel.data!.companyEmail!}");
                              }
                            },
                          ),
                          const Divider(),
                          IconTextRow(
                            icon: Icons.call,
                            text: aboutUsModel.data?.companyMobile ?? "",
                            iconColor: AppColors.primaryColor,
                            textColor: AppColors.secondaryColor,
                            onTap: () {
                              if (aboutUsModel.data?.companyMobile != null &&
                                  aboutUsModel
                                      .data!.companyMobile!.isNotEmpty) {
                                _launchURL(
                                    "tel:${aboutUsModel.data!.companyMobile!}");
                              }
                            },
                          ),
                          const Divider(),
                          IconTextRow(
                            icon: Icons.location_on,
                            text: aboutUsModel.data?.companyAddress ?? "",
                            iconColor: AppColors.primaryColor,
                            textColor: AppColors.secondaryColor,
                            onTap: () {
                              if (aboutUsModel.data?.companyAddress != null &&
                                  aboutUsModel
                                      .data!.companyAddress!.isNotEmpty) {
                                _launchURL(
                                    "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(aboutUsModel.data!.companyAddress!)}");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notDataAvailableText({required String title}) {
    return Text(
      title,
      style: TextStyle(
        color: ConstHelper.blackColor,
        fontWeight: FontWeight.w600,
        fontSize: Get.width * 0.045,
      ),
    );
  }
}

Widget commonNetworkImage(
  String url,
  String title,
) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: Get.height * 0.1,
          width: Get.height * 0.1,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                      // Show the upper part of the image
                      placeholder: (context, url) => Container(
                        color: ConstHelper.whiteColor,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: ConstHelper.darkBlueColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: ConstHelper.whiteColor,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.error,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: Get.height * 0.01,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: Get.height / 70,
                  color: AppColors.color2e,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget commonRowProfile({required String title, required String subTitle}) {
  return Visibility(
    visible: subTitle.trim().isNotEmpty,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                fontSize: Get.height / 58,
                color: AppColors.color2e,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(" :  "),
          Expanded(
            flex: 3,
            child: Text(
              subTitle,
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                fontSize: Get.height / 65,
                color: AppColors.color2e,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class IconTextRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final void Function()? onTap;

  const IconTextRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(width: Get.width * 0.06),
            Icon(icon, color: iconColor),
            SizedBox(width: Get.width * 0.03),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                  fontSize: Get.height / 60,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw 'Could not launch $url';
  }
}
