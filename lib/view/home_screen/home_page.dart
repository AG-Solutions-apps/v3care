import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:v3care/view/home_screen/widget/assigned_job_detail_page.dart';

import '../../Constants/app_colors.dart';
import '../../Utils/api_helper.dart';
import '../../Utils/const_helper.dart';
import '../../controller/home_controller.dart';
import '../../model/booking_job_model.dart';
import '../../widget/common_button.dart';
import '../../widget/common_done_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = Get.put(HomeController());

  RxBool getData = true.obs;

  @override
  void initState() {
    homeController.getUserData();
    getAllData();
    super.initState();
  }

  Future<void> getAllData() async {
    getData.value = true;
    await getUserData();
  }

  Future<void> getUserData() async {
    getData.value = true;
    try {
      await ApiHelper.apiHelper.getAllJobsApi().then(
            (listOfJobList) {
          debugPrint("listOfJobList data: $listOfJobList");
          homeController.listOfJobList.value = listOfJobList;
          getData.value = false;
          setState(() {});
        },
      );
      await ApiHelper.apiHelper.getAllAssignedJobsApi().then(
            (job) {
          debugPrint("listOfAssignedJobList data: $job");
          homeController.listOfAssignedJobList.value = job;
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
      }
      return DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          body: RefreshIndicator(
            onRefresh: () => getAllData(),
            color: ConstHelper.darkBlueColor,
            backgroundColor: ConstHelper.whiteColor,
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.002,
                ),
                Container(
                  color: AppColors.white,
                  child: TabBar(
                    controller: homeController.tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    overlayColor:
                    const WidgetStatePropertyAll(AppColors.white),
                    dividerColor: AppColors.white,
                    indicatorColor: AppColors.primaryColor,
                    labelStyle: GoogleFonts.inter(
                      fontSize: Get.height / 50,
                      letterSpacing: 1,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    // Highlight color
                    tabs: const [
                      Tab(text: "Jobs"), // First Tab
                      Tab(text: "Assigned Jobs"), // Second Tab
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: homeController.tabController,
                    children: [
                      /// ------------------ Jobs Tab ------------------
                      Obx(() {
                        return RefreshIndicator(
                          onRefresh: getAllData,
                          color: ConstHelper.darkBlueColor,
                          backgroundColor: ConstHelper.whiteColor,
                          child: homeController.listOfJobList.isEmpty
                              ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: Get.height * 0.3),
                              Center(
                                child: notDataAvailableText(
                                  title: "New bookings coming soon! \nCome back later.",
                                ),
                              ),
                            ],
                          )
                              : /*ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                             */ commonListView(
                                jobList: homeController.listOfJobList,
                                onTap: (val) async {
                                  await ApiHelper.apiHelper
                                      .statusChangeOfJOB(
                                    ref: val.orderRef ?? "",
                                    status: 'Confirmed',
                                  )
                                      .then((value) {
                                    if (value["code"] == 200) {
                                      if (!mounted) return;
                                      showDialog(
                                        context: this.context,
                                        barrierDismissible: false,
                                        builder: (_) {
                                          return AlertDialog(
                                            insetPadding: EdgeInsets.zero,
                                            backgroundColor: AppColors.white,
                                            surfaceTintColor: AppColors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(Get.height * 0.005),
                                              ),
                                            ),
                                            // title: CommonDoneWidget(
                                            //   title: (val.orderService ?? "").toLowerCase() == "custom"
                                            //       ? (val.orderCustom ?? "")
                                            //       : (val.orderService ?? ""),
                                            //   subTitle: val.orderServicePriceFor,
                                            //   time: DateFormat("hh:mm")
                                            //       .format(val.orderServiceDate!),
                                            //   date: DateFormat("dd-MM-yyyy")
                                            //       .format(val.orderServiceDate!),
                                            //   address: val.orderAddress,
                                            //   rs: val.orderAmount.toString(),
                                            // ),
                                            title: CommonDoneWidget(
                                              title: (val.orderService ?? "").toLowerCase() == "custom"
                                                  ? (val.orderCustom ?? "")
                                                  : (val.orderService ?? ""),
                                              subTitle: ((val.orderService ?? "").toLowerCase() == "custom" &&
                                                  (val.orderServicePriceFor ?? "0") == "0")
                                                  ? ""
                                                  : val.orderServicePriceFor,
                                              time: DateFormat("hh:mm").format(val.orderServiceDate!),
                                              date: DateFormat("dd-MM-yyyy").format(val.orderServiceDate!),
                                              address: val.orderServiceDate != null &&
                                                  DateTime.now().isAfter(val.orderServiceDate!.subtract(const Duration(days: 1)))
                                                  ? val.orderAddress
                                                  : [val.orderSubLocality, val.orderLocality]
                                                  .where((e) => e != null && e.trim().isNotEmpty)
                                                  .join(", "),
                                              rs: val.orderAmount.toString(),
                                            ),
                                          );
                                        },
                                      ).then((_) => getAllData());
                                    }
                                  });
                                },
                              ),
                            // ],
                          // ),

                        );
                      }),

                      /// ------------------ Assigned Jobs Tab ------------------
                      Obx(() {
                        return RefreshIndicator(
                          onRefresh: getAllData,
                          color: ConstHelper.darkBlueColor,
                          backgroundColor: ConstHelper.whiteColor,
                          child: homeController.listOfAssignedJobList.isEmpty
                              ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: Get.height * 0.3),
                              Center(
                                child: notDataAvailableText(
                                  title: "No service assigned. \nBrowse inquiries and apply!",
                                ),
                              ),
                            ],
                          )
                              : commonListView(
                            jobList: homeController.listOfAssignedJobList,
                            bgColor: AppColors.greenColor,
                            buttonTitle: "View",
                            onTap: (val) {
                              Get.to(
                                JobDetailPage(
                                  orderRefl: val.orderRef ?? "",
                                  history: "Assigned Job",
                                ),
                              )?.then((_) => getUserData());
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                // Expanded(
                //   child: TabBarView(
                //     controller: homeController.tabController,
                //     children: [
                //       homeController.listOfJobList.isEmpty
                //           ? Center(
                //               child: notDataAvailableText(
                //                 title:
                //                     "New bookings coming soon! \nCome back later.",
                //               ),
                //             )
                //           : commonListView(
                //               jobList: homeController.listOfJobList,
                //               onTap: (val) async {
                //                 await ApiHelper.apiHelper
                //                     .statusChangeOfJOB(
                //                         ref: val.orderRef ?? "",
                //                         status: 'Confirmed')
                //                     .then((value) {
                //                   if (kDebugMode) {
                //                     print(value);
                //                   }
                //
                //                   if (value["code"] == 200) {
                //                     if(!mounted) return;
                //                     showDialog(
                //                       context: this.context,
                //                       barrierDismissible: false,
                //                       builder: (context) {
                //                         return AlertDialog(
                //                           insetPadding: EdgeInsets.zero,
                //                           backgroundColor: AppColors.white,
                //                           surfaceTintColor: AppColors.white,
                //                           shape: RoundedRectangleBorder(
                //                             borderRadius: BorderRadius.all(
                //                               Radius.circular(
                //                                   Get.height * 0.005),
                //                             ),
                //                           ),
                //                           title: CommonDoneWidget(
                //                             title: (val.orderService ?? "")
                //                                         .toLowerCase() ==
                //                                     "custom"
                //                                 ? (val.orderCustom ?? "")
                //                                 : (val.orderService ?? ""),
                //                             subTitle: val.orderServicePriceFor,
                //                             time: DateFormat("hh:mm")
                //                                 .format(val.orderServiceDate!),
                //                             date: DateFormat("dd-MM-yyyy")
                //                                 .format(val.orderServiceDate!),
                //                             address: val.orderAddress,
                //                             rs: val.orderAmount.toString(),
                //                           ),
                //                         );
                //                       },
                //                     ).then((value) {
                //                       getAllData();
                //                     });
                //                   }
                //                 });
                //               },
                //             ),
                //       homeController.listOfAssignedJobList.isEmpty
                //           ? Center(
                //               child: notDataAvailableText(
                //                 title:
                //                     "No service assigned. \nBrowse inquiries and apply!",
                //               ),
                //             )
                //           : commonListView(
                //               jobList: homeController.listOfAssignedJobList,
                //               bgColor: AppColors.greenColor,
                //               buttonTitle: "View",
                //               onTap: (val) {
                //                 Get.to(
                //                   JobDetailPage(
                //                     orderRefl: val.orderRef ?? "",
                //                     history: "Assigned Job",
                //                   ),
                //                 )?.then((value) => getUserData());
                //               },
                //             ),
                //     ],
                //   ),
                // )
              ],
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
        color: ConstHelper.blackColor,
        fontWeight: FontWeight.w500,
        fontSize: Get.height / 50,
        letterSpacing: 1,
      ),
      textAlign: TextAlign.center,
    );
  }

}

Widget commonListView(
    {required RxList<BookingJobData> jobList,
      void Function(BookingJobData)? onTap,
      Color? bgColor,
      String? buttonTitle}) {
  return ListView.separated(
    shrinkWrap: true,
    itemCount: jobList.length,
    itemBuilder: (context, index) {
      if (kDebugMode) {
        print(jobList[index].orderRef);
      }
      // Check to insert the slider after every 5th item

      // Container item for user data
      return InkWell(
        onTap: () {
          // if (onTap != null) onTap(jobList[index]);
          /*debugPrint(homeController
                                .listOfJobList[index].id
                                .toString());*/
          /*Get.to(
                              () => ProfileDetailScreen(
                                companyName: homeController
                                        .listOfJobList[index]
                                        .companyShort ??
                                    "",
                                id: homeController
                                        .listOfJobList[index].id
                                        ?.toString() ??
                                    '',
                              ),
                            );*/
          /* Get.to(
            JobDetailPage(
              orderRefl: jobList[index].orderRef ?? "",
              history: "Jobs",
            ),
          );*/
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
                      jobList[index].orderCustomerName ?? "Customer",
                      style: GoogleFonts.inter(
                        fontSize: Get.height / 60,
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    // SizedBox(height: Get.height * 0.004),
                    // Text(
                    //   (jobList[index].orderService ?? "").toLowerCase() ==
                    //       "custom"
                    //       ? (jobList[index].orderCustom ?? "")
                    //       : (jobList[index].orderService ?? ""),
                    //   style: GoogleFonts.inter(
                    //     fontSize: Get.height / 50,
                    //     color: AppColors.primaryColor,
                    //     fontWeight: FontWeight.w600,
                    //     letterSpacing: 1,
                    //   ),
                    // ),
                    // Text(
                    //   (jobList[index].orderService ?? "").toLowerCase() ==
                    //       "custom"
                    //       ? (jobList[index].orderCustom ?? "")
                    //       : (jobList[index].orderService ?? ""),
                    //   style: GoogleFonts.inter(
                    //     fontSize: Get.height / 50,
                    //     color: AppColors.primaryColor,
                    //     fontWeight: FontWeight.w600,
                    //     letterSpacing: 1,
                    //   ),
                    // ),
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
                            height: Get.height * 0.02,
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        Expanded(
                          child: /*Text(
                            (jobList[index].orderLocality?.isNotEmpty ?? false) ||
                                (jobList[index].orderSubLocality?.isNotEmpty ?? false)
                                ? "${jobList[index].orderLocality ?? ''}, ${jobList[index].orderSubLocality ?? ''}"
                                .replaceAll(RegExp(r',\s*$'), '')
                                : jobList[index].orderAddress ?? '',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                              fontSize: Get.height / 70,
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          )*/
                          // Text(
                          //   jobList[index].orderAddress ?? "",
                          //   textAlign: TextAlign.justify,
                          //   style: GoogleFonts.inter(
                          //     fontSize: Get.height / 70,
                          //     color: AppColors.secondaryColor,
                          //     fontWeight: FontWeight.w500,
                          //     letterSpacing: 1,
                          //   ),
                          // ),
                          Text(
                            DateTime.now().isAfter(jobList[index].orderServiceDate!.subtract(const Duration(days: 1)))
                                ? (jobList[index].orderAddress ?? "")
                                : [jobList[index].orderSubLocality, jobList[index].orderLocality]
                                .where((e) => e != null && e.trim().isNotEmpty)
                                .join(", "),
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                              fontSize: Get.height / 70,
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.01),
                    CustomButton(
                      width: Get.width * 0.25,
                      fontSize: Get.height / 60,
                      heightFactor: Get.height * 0.025,
                      radius: Get.height * 0.005,
                      buttonText: buttonTitle ?? 'Accept',
                      backgroundColor: bgColor ?? AppColors.greenColor,
                      onTap: () {
                        if (onTap != null) onTap(jobList[index]);
                      },
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