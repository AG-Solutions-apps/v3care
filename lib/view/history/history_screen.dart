import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Constants/app_colors.dart';
import '../../Utils/api_helper.dart';
import '../../Utils/const_helper.dart';
import '../../controller/home_controller.dart';
import '../../model/job_history_model.dart';
import '../home_screen/widget/assigned_job_detail_page.dart';

class JobHistoryPage extends StatefulWidget {
  const JobHistoryPage({super.key});

  @override
  State<JobHistoryPage> createState() => _JobHistoryPageState();
}

class _JobHistoryPageState extends State<JobHistoryPage> {
  HomeController homeController = Get.put(HomeController());

  RxBool getData = true.obs;

  @override
  void initState() {
    // TODO: implement initState
    homeController.getUserData();
    getAllData();
    super.initState();
  }

  Future<void> getAllData() async {
    getData.value = true;
    await getHistoryData();
  }

  Future<void> getHistoryData() async {
    getData.value = true;
    try {
      await ApiHelper.apiHelper.getAllHistoryJobsApi().then(
            (listOfHistory) {
          homeController.listOfJobHistoryJobList.value = listOfHistory;
          getData.value = false;
          setState(() {});
        },
      );
    } catch (error) {
      getData.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {

    // getUpcomingClass();
    return Obx(() {

      log(homeController.userDataWithToken.value.data?.token ?? "");

      if (getData.value) {
        return Center(
          child: CircularProgressIndicator(
            color: ConstHelper.darkBlueColor,
          ),
        );
      } else if (homeController.listOfJobHistoryJobList.isEmpty) {
        // return Center(
        //   child: notDataAvailableText(
        //     title: ConstHelper.noUpcomingClassMsg,
        //   ),
        // );
        return Scaffold(
          backgroundColor: AppColors.bgColor,
          body: RefreshIndicator(
            onRefresh: () => getAllData(),
            color: ConstHelper.darkBlueColor,
            backgroundColor: ConstHelper.whiteColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: Get.height * 0.3),
                Center(
                  child: notDataAvailableText(
                    title: ConstHelper.noUpcomingClassMsg,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          body: RefreshIndicator(
            onRefresh: () => getAllData(),
            color: ConstHelper.darkBlueColor,
            backgroundColor: ConstHelper.whiteColor,
            child: commonListView(
              jobList: homeController.listOfJobHistoryJobList,
              bgColor: AppColors.greenColor,
              buttonTitle: "View",
              onTap: (val) {
                Get.to(
                  JobDetailPage(
                    orderRefl: val.orderRef ?? "",
                    history: "History",
                  ),
                );
              },
            ),
          ),
        ),
      );

    });
  }

  Widget notDataAvailableText({required String title}) {
    return Text(
      title,
      style: TextStyle(
          color: ConstHelper.blackColor.withAlpha(230),
          fontWeight: FontWeight.w500,
          fontSize: Get.height / 50,
          letterSpacing: 1),
      textAlign: TextAlign.center,
    );
  }

}

Widget commonListView(
    {required RxList<JobHistoryData> jobList,
      void Function(JobHistoryData val)? onTap,
      Color? bgColor,
      String? buttonTitle}) {
  return ListView.separated(
    shrinkWrap: true,
    itemCount: jobList.length,
    padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
    itemBuilder: (context, index) {
      // Check to insert the slider after every 5th item

      // Container item for user data
      return InkWell(
        onTap: () {
          if (onTap != null) onTap(jobList[index]);
        },
        child: Container(
          color: AppColors.white,
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (jobList[index].orderService ?? "").toLowerCase() ==
                          "custom"
                          ? (jobList[index].orderCustom ?? "")
                          : (jobList[index].orderService ?? ""),
                      style: GoogleFonts.inter(
                        fontSize: Get.height / 50,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.005,
                    ),
                    // Text(
                    //   jobList[index].orderServicePriceFor ?? "",
                    //   style: GoogleFonts.inter(
                    //     fontSize: Get.height / 65,
                    //     color: AppColors.secondaryColor,
                    //     fontWeight: FontWeight.w400,
                    //     letterSpacing: 1,
                    //   ),
                    // ),
                    ((jobList[index].orderService ?? "").toLowerCase() == "custom" &&
                        (jobList[index].orderServicePriceFor ?? "0") == "0")
                        ? const SizedBox.shrink()
                        : Text(
                      jobList[index].orderServicePriceFor ?? "",
                      style: GoogleFonts.inter(
                        fontSize: Get.height / 65,
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.005,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.02,
                              vertical: Get.height * 0.005),
                          decoration: const BoxDecoration(
                              color: AppColors.lightGoldColor),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  "assets/images/svg/calendar.svg"),
                              SizedBox(
                                width: Get.width * 0.02,
                              ),
                              Text(
                                DateFormat("dd-MM-yyyy")
                                    .format(jobList[index].orderServiceDate!),
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
                          decoration: const BoxDecoration(
                              color: AppColors.lightGoldColor),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/images/svg/clock.svg"),
                              SizedBox(
                                width: Get.width * 0.02,
                              ),
                              Text(
                                DateFormat("hh:mm")
                                    .format(jobList[index].orderServiceDate!),
                                style: GoogleFonts.inter(
                                  fontSize: Get.height / 70,
                                  color: AppColors.goldColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.01),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: Get.height * 0.005),
                            child: SvgPicture.asset(
                              "assets/images/svg/location.svg",
                              height: Get.height * 0.025,
                            )),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        Expanded(
                          child: Text(
                            jobList[index].orderAddress ?? "",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                              fontSize: Get.height / 70,
                              color: AppColors.secondaryColor,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: Get.width * 0.04),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.all(Radius.circular(Get.height * 0.01)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 0), // Shadow position
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.all(Radius.circular(Get.height * 0.01)),
                  child: CachedNetworkImage(
                    imageUrl: ConstHelper.userImagePath +
                        (jobList[index].serviceImage ?? ""),
                    fit: BoxFit.cover,
                    height: Get.height * 0.12,
                    width: Get.height * 0.12,
                    placeholder: (context, url) => Container(
                      color: ConstHelper.whiteColor,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: ConstHelper.darkBlueColor,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        Image.network(ConstHelper.noImage, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(width: Get.width * 0.02),
            ],
          ),
        ),
      );
    },
    separatorBuilder: (context, index) => SizedBox(height: Get.height * 0.01),
  );

}
