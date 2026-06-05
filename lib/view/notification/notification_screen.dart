import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:v3care/Constants/app_colors.dart';

import '../../Utils/const_helper.dart';
import '../../controller/fetch_notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.bgColor,
      body: RefreshIndicator(
        onRefresh: () async => controller.getNotificationData(),
        color: ConstHelper.darkBlueColor,
        backgroundColor: ConstHelper.whiteColor,
        child: controller.isLoading.value
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: Get.height * 0.4),
            Center(
              child: CircularProgressIndicator(
                color: ConstHelper.darkBlueColor,
              ),
            ),
          ],
        )
            : controller.notificationList.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: Get.height * 0.4),
            Center(
              child: Text(
                "No Notifications Available",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * 0.045,
                ),
              ),
            ),
          ],
        )
            : ListView.builder(
          itemCount: controller.notificationList.length,
          padding: EdgeInsets.symmetric(
              vertical: Get.height * 0.015),
          itemBuilder: (context, index) {
            final notification = controller.notificationList[index];
            return ListTile(
              tileColor: AppColors.white,
              title: Text(
                notification.notificationHeading ?? "",
                style: GoogleFonts.inter(
                  fontSize: Get.height / 50,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.notificationSubHeading ?? "",
                          style: TextStyle(
                            fontSize: Get.width * 0.035,
                            letterSpacing: 1,
                            fontWeight: FontWeight.normal,
                            color: ConstHelper.blackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.015),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      DateFormat('dd-MM-yyyy').format(
                          notification.notificationCreateDate!),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: Get.width * 0.035,
                        fontWeight: FontWeight.normal,
                        color: AppColors.greenColor,
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            );
          },
        ),
      ),
    ));
  }

// @override
  // Widget build(BuildContext context) {
  //   return Obx(() => Scaffold(
  //         backgroundColor: AppColors.bgColor,
  //         body: Container(
  //           child: controller.isLoading.value
  //               ? Center(
  //                   child: CircularProgressIndicator(
  //                     color: ConstHelper.darkBlueColor,
  //                   ),
  //                 )
  //               : controller.notificationList.isEmpty
  //                   ? Center(
  //                       child: Text(
  //                         "No Notifications Available",
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: Get.width * 0.045),
  //                       ),
  //                     )
  //                   : ListView.builder(
  //                       itemCount: controller.notificationList.length,
  //                       padding:
  //                           EdgeInsets.symmetric(vertical: Get.height * 0.015),
  //                       itemBuilder: (context, index) {
  //                         return ListTile(
  //                           tileColor: AppColors.white,
  //                           title: Text(
  //                             controller
  //                                 .notificationList[index].notificationHeading
  //                                 .toString(),
  //                             style: GoogleFonts.inter(
  //                               fontSize: Get.height / 50,
  //                               color: AppColors.primaryColor,
  //                               fontWeight: FontWeight.w600,
  //                               letterSpacing: 1,
  //                             ),
  //                           ),
  //                           subtitle: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               SizedBox(
  //                                 height: Get.height * 0.01,
  //                               ),
  //                               Row(
  //                                 children: [
  //                                   Expanded(
  //                                     child: Text(
  //                                         controller.notificationList[index]
  //                                             .notificationSubHeading
  //                                             .toString(),
  //                                         style: TextStyle(
  //                                             fontSize: Get.width * 0.035,
  //                                             letterSpacing: 1,
  //                                             fontWeight: FontWeight.normal,
  //                                             color: ConstHelper.blackColor)),
  //                                   ),
  //                                 ],
  //                               ),
  //                               SizedBox(
  //                                 height: Get.height * 0.015,
  //                               ),
  //                               Align(
  //                                 alignment: Alignment.centerRight,
  //                                 child: Text(
  //                                     DateFormat('dd-MM-yyyy').format(controller
  //                                         .notificationList[index]
  //                                         .notificationCreateDate!),
  //                                     textAlign: TextAlign.end,
  //                                     style: TextStyle(
  //                                         fontSize: Get.width * 0.035,
  //                                         fontWeight: FontWeight.normal,
  //                                         color: AppColors.greenColor)),
  //                               ),
  //                               const Divider(),
  //                             ],
  //                           ),
  //                         );
  //                       },
  //                     ),
  //         ),
  //       ));
  // }

}
