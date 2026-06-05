import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v3care/model/assigned_job_detail_model.dart';
import 'package:v3care/model/order_status_model.dart';
import 'package:v3care/view/home_screen/widget/payment_page.dart';

import '../../../Constants/app_colors.dart';
import '../../../Utils/api_helper.dart';
import '../../../Utils/const_helper.dart';
import '../../../controller/home_controller.dart';
import '../../../widget/common_button.dart';
import '../../../widget/custom_app_bar.dart';
import '../../../widget/custom_text_form_field.dart';

class JobDetailPage extends StatefulWidget {
  final String orderRefl;
  final String? history;

  const JobDetailPage({super.key, required this.orderRefl, this.history});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  HomeController homeController = Get.put(HomeController());
  TextEditingController feedbackController = TextEditingController();
  RxBool getData = true.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    getDetailData();
    homeController.getOrderStatusData();
    super.initState();
  }

  Future<void> getDetailData() async {
    getData.value = true;

    await ApiHelper.apiHelper.getJobDetailApi(orderRef: widget.orderRefl).then(
          (listOfDetailList) {

        homeController.detailList.value = listOfDetailList;

        if (homeController.detailList.isNotEmpty &&
            homeController.detailList.first.orderStatus?.toLowerCase() ==
                "on the way" ||
            homeController.detailList.first.orderStatus?.toLowerCase() ==
                "in progress" ||
            homeController.detailList.first.orderStatus?.toLowerCase() ==
                "postponed") {
          homeController.statusSelected.value =
              homeController.detailList.first.orderStatus ?? "";
        } else {
          homeController.statusSelected.value = "";
        }

        getData.value = false;
        setState(() {});
      },
    );
    homeController.getUserData();
  }

  // Helper function (can move to utils if used elsewhere)
  String getShortAddress(AssignedJobData job) {
    if (job.orderServiceDate != null &&
        DateTime.now().isAfter(job.orderServiceDate!.subtract(const Duration(days: 1)))) {
      return job.orderAddress ?? '';
    }

    String locality = job.orderLocality ?? '';
    String subLocality = job.orderSubLocality ?? '';
    String combined = [subLocality, locality]
        .where((e) => e.trim().isNotEmpty)
        .join(', ')
        .trim();

    return combined.isNotEmpty ? combined : (job.orderLandmark ?? '');
  }

  bool getIsClickable(String? orderServiceDate) {
    debugPrint("orderServiceDate: $orderServiceDate");

    if (orderServiceDate == null) return false;

    try {
      final serviceDateTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(orderServiceDate);
      final now = DateTime.now();

      // ❗️If now is before (orderServiceDate - 24 hours), it's too early
      final clickable = now.isAfter(serviceDateTime.subtract(const Duration(hours: 24)));
      debugPrint("orderServiceDate: isClickable: $clickable");

      return clickable;
    } catch (e) {
      debugPrint("Date parse failed: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //EasyLoading.dismiss();

    // getUpcomingClass();
    return Obx(() {
      if (getData.value) {
        return Center(
          child: CircularProgressIndicator(
            color: ConstHelper.darkBlueColor,
          ),
        );
      } else if (homeController.detailList.isEmpty) {
        return Center(
            child: notDataAvailableText(title: "Details Not Available"));
      }

      final job = homeController.detailList.first;
      final isClickable = getIsClickable(job.orderServiceDate?.toString());
      debugPrint("orderServiceDate: isClickable: $isClickable");

      return RefreshIndicator(
        onRefresh: () => getDetailData(),
        color: ConstHelper.darkBlueColor,
        backgroundColor: ConstHelper.whiteColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: CustomAppbar(
              title: widget.history ?? "",
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.02),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Get.height * 0.01),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: homeController.detailList.isNotEmpty &&
                            homeController.detailList.first.serviceImage !=
                                null &&
                            homeController
                                .detailList.first.serviceImage!.isNotEmpty
                            ? ConstHelper.userImagePath +
                            homeController.detailList.first.serviceImage!
                            : ConstHelper.noImage,
                        fit: BoxFit.cover,
                        height: Get.height * 0.22,
                        width: Get.height * 0.22,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: ConstHelper.darkBlueColor,
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          if (kDebugMode) {
                            print("Error loading image: $url, Error: $error");
                          }
                          return Image.network(ConstHelper.noImage,
                              fit: BoxFit.cover);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  if (widget.history != null &&
                      widget.history?.toLowerCase() == "history")
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/images/svg/done_icon.svg",
                          height: Get.height * 0.07,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                width: Get.width * 0.4,
                                heightFactor: 22,
                                buttonText: homeController
                                    .detailList.first.orderStatus ??
                                    "",
                                backgroundColor: AppColors.greenColor,
                                onTap: () async {},
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Get.width * 0.12),
                      ],
                    ),
                  SizedBox(height: Get.height * 0.01),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   (homeController.detailList.first
                              //                       .orderService ??
                              //                   "")
                              //               .toLowerCase() ==
                              //           "custom"
                              //       ? (homeController
                              //               .detailList.first.orderCustom ??
                              //           "")
                              //       : (homeController
                              //               .detailList.first.orderService ??
                              //           ""),
                              //   textAlign: TextAlign.center,
                              //   style: GoogleFonts.inter(
                              //     fontSize: Get.height / 45,
                              //     color: AppColors.primaryColor,
                              //     fontWeight: FontWeight.w600,
                              //     letterSpacing: 1,
                              //   ),
                              // ),
                              Text(
                                (homeController.detailList.first.orderCustomer ?? "Customer"),
                                style: GoogleFonts.inter(
                                  fontSize: Get.height / 60,
                                  color: AppColors.secondaryColor,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: Get.height * 0.005),
                              // Text(
                              //   homeController.detailList.first
                              //           .orderServicePriceFor ??
                              //       "",
                              //   style: GoogleFonts.inter(
                              //     fontSize: Get.height / 60,
                              //     color: AppColors.color80,
                              //     fontWeight: FontWeight.w400,
                              //     letterSpacing: 1,
                              //   ),
                              // ),
                              (
                                  (homeController.detailList.first.orderService ?? "").toLowerCase() == "custom" &&
                                      (homeController.detailList.first.orderServicePriceFor ?? "0") == "0"
                              )
                                  ? const SizedBox.shrink()
                                  : Text(
                                homeController.detailList.first.orderServicePriceFor ?? "",
                                style: GoogleFonts.inter(
                                  fontSize: Get.height / 60,
                                  color: AppColors.color80,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: Get.height * 0.01),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.02,
                                      vertical: Get.height * 0.005,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: AppColors.lightGoldColor,
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/svg/calendar.svg"),
                                        SizedBox(width: Get.width * 0.02),
                                        Text(
                                          DateFormat("dd-MM-yyyy").format(
                                              homeController.detailList.first
                                                  .orderServiceDate!),
                                          style: GoogleFonts.inter(
                                            fontSize: Get.height / 65,
                                            color: AppColors.goldColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: Get.width * 0.02),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.02,
                                      vertical: Get.height * 0.005,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: AppColors.lightGoldColor,
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/svg/clock.svg"),
                                        SizedBox(width: Get.width * 0.02),
                                        Text(
                                          DateFormat("hh:mm").format(
                                              homeController.detailList.first
                                                  .orderServiceDate!),
                                          style: GoogleFonts.inter(
                                            fontSize: Get.height / 65,
                                            color: AppColors.goldColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: Get.width * 0.02),
                                  widget.history != null &&
                                      widget.history?.toLowerCase() ==
                                          "history"
                                      ? Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.02,
                                      vertical: Get.height * 0.005,
                                    ),
                                    decoration: const BoxDecoration(
                                        color: AppColors.greenLightColor),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/svg/coin.svg"),
                                        SizedBox(
                                          width: Get.width * 0.02,
                                        ),
                                        Text(
                                          homeController.detailList.first
                                              .orderVendorAmount
                                              ?.toString() ??
                                              "",
                                          style: GoogleFonts.inter(
                                            fontSize: Get.height / 65,
                                            color: AppColors.greenColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      : const SizedBox()
                                ],
                              ),
                              /* SizedBox(height: Get.height * 0.01),
                              Row(
                                children: [
                                  widget.history != null &&
                                      widget.history?.toLowerCase() ==
                                          "history"
                                      ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.02,
                                        vertical: Get.height * 0.005),
                                    decoration: const BoxDecoration(
                                        color: AppColors.greenLightColor),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/svg/coin.svg"),
                                        SizedBox(
                                          width: Get.width * 0.02,
                                        ),
                                        Text(
                                          homeController.detailList.first
                                              .orderAmount
                                              ?.toString() ??
                                              "",
                                          style: GoogleFonts.inter(
                                            fontSize: Get.height / 70,
                                            color: AppColors.greenColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      : SizedBox() */ /*Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: Get.width * 0.02,
                                            vertical: Get.height * 0.005,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: AppColors.lightBlueColor,
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/images/svg/Call.svg",
                                                height: Get.height * 0.02,
                                                color: AppColors.callBgColor,
                                              ),
                                              SizedBox(width: Get.width * 0.02),
                                              Text(
                                                homeController.detailList.first
                                                        .orderCustomerMobile ??
                                                    "",
                                                style: GoogleFonts.inter(
                                                  fontSize: Get.height / 70,
                                                  color: AppColors.callBgColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),*/ /*
                                ],
                              ),*/
                              SizedBox(height: Get.height * 0.02),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: Get.height * 0.005),
                                      child: SvgPicture.asset(
                                        "assets/images/svg/location.svg",
                                        height: Get.height * 0.025,
                                      )),
                                  SizedBox(width: Get.width * 0.02),
                                  Expanded(
                                    child: Text(
                                      (() {
                                        final job = homeController.detailList.first;

                                        if (job.orderServiceDate != null &&
                                            DateTime.now().isAfter(job.orderServiceDate!.subtract(const Duration(days: 1)))) {
                                          return job.orderAddress ?? '';
                                        } else {
                                          return getShortAddress(job);
                                        }
                                      })(),
                                      textAlign: TextAlign.justify,
                                      style: GoogleFonts.inter(
                                        fontSize: Get.height / 60,
                                        color: AppColors.secondaryColor,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ), /*Text(
                                      homeController
                                              .detailList.first.orderAddress ??
                                          "",
                                      textAlign: TextAlign.justify,
                                      style: GoogleFonts.inter(
                                        fontSize: Get.height / 60,
                                        color: AppColors.secondaryColor,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )*/
                                  ),
                                ],
                              ),
                              SizedBox(height: Get.height * 0.02),
                              if (widget.history != null &&
                                  widget.history?.toLowerCase() != "history")
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [

                                            Expanded(
                                              child: job.orderAddress != null
                                                  ? InkWell(
                                                onTap: isClickable
                                                    ? () {
                                                  launchMap(job.orderAddress!);
                                                }
                                                    : null,
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                child: Card(
                                                  color: isClickable
                                                      ? AppColors.tealColor
                                                      : AppColors.tealColor.withAlpha(128), // visually disabled
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(Get.height * 0.08),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: Get.width * 0.04,
                                                      vertical: Get.height * 0.01,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        const Icon(Icons.location_on, color: AppColors.white),
                                                        SizedBox(width: Get.width * 0.02),
                                                        Expanded(
                                                          child: Text(
                                                            "Google Map",
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts.inter(
                                                              fontSize: Get.height / 55,
                                                              color: AppColors.white,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                                  : const SizedBox(),
                                            ),

                                            Expanded(
                                              child: job.orderCustomerMobile != null
                                                  ? InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onTap: isClickable
                                                    ? () {
                                                  openDialPad(job.orderCustomerMobile!);
                                                }
                                                    : null,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(Get.height * 0.08),
                                                    ),
                                                  ),
                                                  color: isClickable
                                                      ? AppColors.greenColor
                                                      : AppColors.greenColor.withAlpha(128), // dimmed color
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: Get.width * 0.04,
                                                      vertical: Get.height * 0.01,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SvgPicture.asset("assets/images/svg/Call.svg"),
                                                        SizedBox(width: Get.width * 0.02),
                                                        Expanded(
                                                          child: Text(
                                                            "Call",
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts.inter(
                                                              fontSize: Get.height / 55,
                                                              color: AppColors.white,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                                  : const SizedBox(),
                                            ),

                                            // Expanded(
                                            //   child: homeController.detailList
                                            //               .first.orderAddress !=
                                            //           null
                                            //       ? InkWell(
                                            //           splashColor:
                                            //               Colors.transparent,
                                            //           focusColor:
                                            //               Colors.transparent,
                                            //           hoverColor:
                                            //               Colors.transparent,
                                            //           highlightColor:
                                            //               Colors.transparent,
                                            //           radius: 0,
                                            //           onTap: () {
                                            //             if (homeController
                                            //                     .detailList
                                            //                     .first
                                            //                     .orderAddress !=
                                            //                 null) {
                                            //               launchMap(homeController
                                            //                       .detailList
                                            //                       .first
                                            //                       .orderAddress ??
                                            //                   "");
                                            //             }
                                            //             if (homeController
                                            //                     .detailList
                                            //                     .first
                                            //                     .orderAddress ==
                                            //                 null) {
                                            //               Get.snackbar(
                                            //                 "Address",
                                            //                 "Address is not found",
                                            //                 snackPosition:
                                            //                     SnackPosition
                                            //                         .BOTTOM, // Position: TOP or BOTTOM
                                            //               );
                                            //             }
                                            //           },
                                            //           child: Card(
                                            //             color:
                                            //                 AppColors.tealColor,
                                            //             shape:
                                            //                 RoundedRectangleBorder(
                                            //               borderRadius:
                                            //                   BorderRadius.all(
                                            //                 Radius.circular(
                                            //                     Get.height *
                                            //                         0.08),
                                            //               ),
                                            //             ),
                                            //             child: Padding(
                                            //               padding: EdgeInsets
                                            //                   .symmetric(
                                            //                 horizontal:
                                            //                     Get.width *
                                            //                         0.04,
                                            //                 vertical:
                                            //                     Get.height *
                                            //                         0.01,
                                            //               ),
                                            //               child: Row(
                                            //                 mainAxisAlignment:
                                            //                     MainAxisAlignment
                                            //                         .center,
                                            //                 children: [
                                            //                   const Icon(
                                            //                       Icons
                                            //                           .location_on,
                                            //                       color: AppColors
                                            //                           .white),
                                            //                   SizedBox(
                                            //                       width:
                                            //                           Get.width *
                                            //                               0.02),
                                            //                   Expanded(
                                            //                     child: Text(
                                            //                       "Google Map",
                                            //                       textAlign:
                                            //                           TextAlign
                                            //                               .center,
                                            //                       style:
                                            //                           GoogleFonts
                                            //                               .inter(
                                            //                         fontSize:
                                            //                             Get.height /
                                            //                                 55,
                                            //                         color: AppColors
                                            //                             .white,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .w600,
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //             ),
                                            //           ),
                                            //         )
                                            //       : const SizedBox(),
                                            // ),

                                            // Expanded(
                                            //   child: InkWell(
                                            //     splashColor: Colors.transparent,
                                            //     focusColor: Colors.transparent,
                                            //     hoverColor: Colors.transparent,
                                            //     highlightColor:
                                            //     Colors.transparent,
                                            //     onTap: () {
                                            //       if (homeController
                                            //           .detailList
                                            //           .first
                                            //           .orderCustomerMobile !=
                                            //           null) {
                                            //         openDialPad(homeController
                                            //             .detailList
                                            //             .first
                                            //             .orderCustomerMobile ??
                                            //             "");
                                            //       }
                                            //       if (homeController
                                            //           .detailList
                                            //           .first
                                            //           .orderCustomerMobile ==
                                            //           null) {
                                            //         Get.snackbar(
                                            //           "Number not found",
                                            //           "Mobile number not found",
                                            //           snackPosition: SnackPosition
                                            //               .BOTTOM, // Position: TOP or BOTTOM
                                            //         );
                                            //       }
                                            //     },
                                            //     child: Card(
                                            //       shape: RoundedRectangleBorder(
                                            //         borderRadius:
                                            //         BorderRadius.all(
                                            //           Radius.circular(
                                            //               Get.height * 0.08),
                                            //         ),
                                            //       ),
                                            //       color: AppColors.greenColor,
                                            //       child: Padding(
                                            //         padding:
                                            //         EdgeInsets.symmetric(
                                            //             horizontal:
                                            //             Get.width *
                                            //                 0.04,
                                            //             vertical:
                                            //             Get.height *
                                            //                 0.01),
                                            //         child: Row(
                                            //           mainAxisAlignment:
                                            //           MainAxisAlignment
                                            //               .center,
                                            //           children: [
                                            //             SvgPicture.asset(
                                            //                 "assets/images/svg/Call.svg"),
                                            //             SizedBox(
                                            //               width:
                                            //               Get.width * 0.02,
                                            //             ),
                                            //             Expanded(
                                            //               child: Text(
                                            //                 "Call",
                                            //                 textAlign: TextAlign
                                            //                     .center,
                                            //                 style: GoogleFonts
                                            //                     .inter(
                                            //                   fontSize:
                                            //                   Get.height /
                                            //                       55,
                                            //                   color: AppColors
                                            //                       .white,
                                            //                   fontWeight:
                                            //                   FontWeight
                                            //                       .w600,
                                            //                 ),
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),



                                        SizedBox(height: Get.height * 0.02),
                                        Text(
                                          "Change Work Status",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.inter(
                                            fontSize: Get.height / 55,
                                            color: AppColors.secondaryColor,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        SizedBox(height: Get.height * 0.01),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Get.width * 0.04),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Get.height * 0.01)),
                                              border: Border.all(
                                                  color: AppColors.black)),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<OrderStatusDataModel>(
                                              isExpanded: true,
                                              value: homeController.orderStatusDataList
                                                  .where((element) =>
                                              element.orderStatus ==
                                                  homeController.statusSelected.value)
                                                  .isNotEmpty
                                                  ? homeController.orderStatusDataList.firstWhere(
                                                    (element) =>
                                                element.orderStatus ==
                                                    homeController.statusSelected.value,
                                              )
                                                  : null,
                                              hint: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                      EdgeInsets.symmetric(
                                                          vertical:
                                                          Get.height *
                                                              0.01),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.white,
                                                        borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(
                                                              Get.height *
                                                                  0.01),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "Select Work Progress",
                                                        textAlign:
                                                        TextAlign.center,
                                                        style:
                                                        GoogleFonts.inter(
                                                          fontSize:
                                                          Get.height / 55,
                                                          color: AppColors
                                                              .secondaryColor,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              items: homeController.orderStatusDataList.map((status) {
                                                return DropdownMenuItem<OrderStatusDataModel>(
                                                  value: status,
                                                  child: Text(status.orderStatus ?? ""),
                                                );
                                              }).toList(),
                                              onChanged: (value) async {
                                                if (homeController
                                                    .statusSelected
                                                    .value !=
                                                    value!.orderStatus! &&
                                                    value.orderStatus! !=
                                                        "Select Work Progress") {
                                                  homeController.statusSelected
                                                      .value = value.orderStatus!;
                                                  EasyLoading.show(
                                                      status: ConstHelper
                                                          .pleaseWaitMsg);

                                                  await ApiHelper.apiHelper
                                                      .statusChangeOfJOB(
                                                      ref: homeController
                                                          .detailList
                                                          .first
                                                          .orderRef ??
                                                          "",
                                                      status: homeController
                                                          .statusSelected
                                                          .value)
                                                      .then((value) {
                                                    if (value.isNotEmpty) {
                                                      if (value['code'] ==
                                                          200) {
                                                        EasyLoading.dismiss();
                                                        try {
                                                          if (homeController
                                                              .statusSelected
                                                              .value
                                                              .toString()
                                                              .toLowerCase() ==
                                                              "completed") {
                                                            Get.to(() =>
                                                            const PaymentPage());
                                                          }
                                                        } catch (e) {
                                                          EasyLoading.dismiss();
                                                        }
                                                        Get.snackbar(
                                                          "Success",
                                                          "Work status updated successfully",
                                                          snackPosition:
                                                          SnackPosition
                                                              .BOTTOM, // Position: TOP or BOTTOM
                                                        );
                                                      } else {
                                                        EasyLoading.dismiss();
                                                        Get.snackbar(
                                                          "Failed",
                                                          "Status Update Failed",
                                                          snackPosition:
                                                          SnackPosition
                                                              .BOTTOM, // Position: TOP or BOTTOM
                                                        );
                                                      }
                                                    } else {
                                                      EasyLoading.dismiss();
                                                    }
                                                  });
                                                } else {}
                                              },
                                              icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: Get.height * 0.03),
                                        Center(
                                          child: CustomButton(
                                            width: Get.width * 0.6,
                                            heightFactor: Get.height * 0.02,
                                            buttonText: "Go to payment",
                                            backgroundColor:
                                            AppColors.secondaryColor,
                                            onTap: () async {

                                              // if(!isClickable) return;

                                              Get.to(() => const PaymentPage());
                                              debugPrint(
                                                  "selected status ${homeController.statusSelected.value}");
                                              /*   EasyLoading.show(
                                                  status: ConstHelper
                                                      .pleaseWaitMsg);

                                              await ApiHelper.apiHelper
                                                  .statusChangeOfJOB(
                                                      ref: homeController
                                                              .detailList
                                                              .first
                                                              .orderRef ??
                                                          "",
                                                      status: homeController
                                                          .statusSelected.value)
                                                  .then((value) {
                                                if (value.isNotEmpty) {
                                                  if (value['code'] == 200) {
                                                    EasyLoading.dismiss();
                                                    try {
                                                      if (homeController
                                                              .statusSelected
                                                              .value
                                                              .toString()
                                                              .toLowerCase() ==
                                                          "completed") {
                                                        Get.to(() =>
                                                            const PaymentPage());
                                                      }
                                                    } catch (e) {
                                                      EasyLoading.dismiss();
                                                    }
                                                    Get.snackbar(
                                                      "Success",
                                                      "Work status updated successfully",
                                                      snackPosition: SnackPosition
                                                          .BOTTOM, // Position: TOP or BOTTOM
                                                    );
                                                  } else {
                                                    EasyLoading.dismiss();
                                                    Get.snackbar(
                                                      "Failed",
                                                      "Status Update Failed",
                                                      snackPosition: SnackPosition
                                                          .BOTTOM, // Position: TOP or BOTTOM
                                                    );
                                                  }
                                                } else {
                                                  EasyLoading.dismiss();
                                                }
                                              });*/
                                            },
                                          ),
                                        ),
                                        SizedBox(height: Get.height * 0.01),
                                        /*    Center(
                                          child: CustomButton(
                                            width: Get.width * 0.6,
                                            heightFactor: Get.height * 0.025,
                                            buttonText: "Remark/Feedback",
                                            backgroundColor:
                                                AppColors.greenColor,
                                            onTap: () async {
                                              feedbackAlertDialog(
                                                title: 'Job Remarks',
                                                context: context,
                                                onPressed: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    EasyLoading.show(
                                                      status: ConstHelper
                                                          .pleaseWaitMsg,
                                                    );
                                                    try {
                                                      var val = await ApiHelper
                                                          .apiHelper
                                                          .createCommentOfJOB(
                                                        ref: homeController
                                                                .detailList
                                                                .first
                                                                .orderRef ??
                                                            "",
                                                        comment:
                                                            feedbackController
                                                                .text,
                                                      );
                                                      print(val);
                                                      EasyLoading.dismiss();
                                                      if (val["code"] == 200) {
                                                        feedbackController
                                                            .clear();
                                                        Get.back();
                                                        ConstHelper
                                                            .successDialog(
                                                          text: val["msg"],
                                                          seconds: 10,
                                                        );
                                                      } else {
                                                        Get.back();
                                                        ConstHelper.errorDialog(
                                                          text: ConstHelper
                                                              .somethingWantWrongMsg,
                                                          seconds: 10,
                                                        );
                                                      }
                                                    } catch (e) {
                                                      EasyLoading.dismiss();
                                                      ConstHelper.errorDialog(
                                                        text: ConstHelper
                                                            .somethingWantWrongMsg,
                                                        seconds: 10,
                                                      );
                                                      Get.back();
                                                    }
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),
                              if (widget.history != null &&
                                  widget.history?.toLowerCase() == "history")
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Get.width * 0.02,
                                              vertical: Get.height * 0.005),
                                          decoration: const BoxDecoration(
                                              color: AppColors.greenLightColor),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  "assets/images/svg/coin.svg"),
                                              SizedBox(
                                                width: Get.width * 0.02,
                                              ),
                                              Text(
                                                "Payment Details",
                                                style: GoogleFonts.inter(
                                                  fontSize: Get.height / 55,
                                                  color: AppColors.greenColor,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Get.height * 0.01),
                                    Text(
                                      "Payment amount : ${homeController.detailList.first.orderPaymentAmount ?? "N/A"}",
                                      style: GoogleFonts.inter(
                                        fontSize: Get.height / 60,
                                        color: AppColors.secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(height: Get.height * 0.01),
                                    Text(
                                      "Payment Type : ${homeController.detailList.first.orderPaymentType ?? "N/A"}",
                                      style: GoogleFonts.inter(
                                        fontSize: Get.height / 60,
                                        color: AppColors.secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

    });
  }

  void feedbackAlertDialog({
    required String title,
    required BuildContext context,
    required void Function() onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: AppColors.white,
          backgroundColor: AppColors.white,
          title: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: Get.height / 55,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      height: 1.5),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        hintText: "Remarks here..",
                        controller: feedbackController,
                        bgColor: const Color(0xFFFFFFFF),
                        maxLines: 3,
                        maxLength: 150,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Please enter remarks";
                          }
                          return null;
                        },
                        /*prefixIcon: Padding(
                          padding: EdgeInsets.all(Get.height * 0.02),
                          child: const Icon(Icons.feedback,color: AppColors.primaryColor,),
                        ),*/
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6))),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            letterSpacing: 1,
                            fontSize: Get.height / 60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greenColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6))),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: Get.height / 60,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                /*SizedBox(
                  height: Get.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        "Delete My Account ?? ",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ConstHelper.greyColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await ApiHelper.apiHelper
                            .postDeleteProfileApi()
                            .then((value) async {
                          try {
                            if (value.isNotEmpty) {
                              if (value['code'] == 200) {
                                final responseData = json.decode(value.body);
                                debugPrint(responseData);
                                if (responseData['code'] == 200) {
                                  SharedPrefHelper.sharedPreferences.setBool(
                                    'login',
                                    false,
                                  );
                                  Get.offAll(
                                    const LoginPage(),
                                  );
                                  ConstHelper.successDialog(
                                    text: jsonDecode(value)['msg'] ??
                                        ConstHelper
                                            .dataDeletedSuccessfullyMsg,
                                    seconds: 10,
                                  );
                                } else {
                                  ConstHelper.errorDialog(
                                    text: jsonDecode(value)['msg'] ??
                                        ConstHelper.somethingWantWrongMsg,
                                    seconds: 10,
                                  );
                                }
                              } else {
                                ConstHelper.errorDialog(
                                  text: jsonDecode(value)['msg'] ??
                                      ConstHelper.somethingWantWrongMsg,
                                  seconds: 10,
                                );
                              }
                            }
                          } on TimeoutException catch (e) {
                            ConstHelper.errorDialog(
                              text: e.message.toString(),
                              seconds: 10,
                            );
                          }
                        });
                      },
                      child: Text(
                        "Click Here",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ConstHelper.greyColor,
                        ),
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          ],
        );
      },
    );
  }

  Widget notDataAvailableText({required String title}) {
    return Text(
      title,
      style: TextStyle(
        color: ConstHelper.blackColor,
        fontWeight: FontWeight.w600,
        fontSize: Get.width * 0.04,
        letterSpacing: 1,
      ),
    );
  }

}

void launchMap(String address) async {
  String query = Uri.encodeComponent(address);
  String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

  _launchURL(googleUrl);
}

void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw 'Could not launch $url';
  }
}

openDialPad(String phoneNumber) async {
  _launchURL("tel:$phoneNumber");
}
