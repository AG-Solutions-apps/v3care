import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v3care/Constants/app_colors.dart';
import 'package:v3care/Utils/const_helper.dart';
import 'package:v3care/model/order_status_model.dart';

import '../Utils/api_helper.dart';
import '../Utils/shared_pref_helper.dart';
import '../model/about_us_model.dart';
import '../model/assigned_job_detail_model.dart';
import '../model/booking_job_model.dart';
import '../model/job_history_model.dart';
import '../model/profile_model.dart';
import '../model/slider_model.dart';
import '../model/user_detail_by_id_model.dart';
import '../model/user_detail_model.dart';
import '../model/user_model.dart';
import '../view/home_screen/home_page.dart';
import '../view/history/history_screen.dart';
import '../view/notification/notification_screen.dart';
import '../view/profile/profile_screen.dart';

class HomeController extends GetxController
    with GetTickerProviderStateMixin {
  RxBool check = false.obs;
  RxBool isLoading = false.obs;
  RxBool isMenuOpen = false.obs;
  RxBool isProfileLoading = false.obs;
  late TabController tabController;

  RxInt otpResendCode = 0.obs;
  RxInt bottomIndex = 0.obs;

  RxString mobileNo = "".obs;
  RxString password = "".obs;
  RxString otpVerificationId = "".obs;
  RxString statusSelected = "".obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxString firebaseFCMToken = "".obs;
  Rx<UserDataModel> userDataWithToken = UserDataModel().obs;
  Rx<UserDetailModel> userDetailModel = UserDetailModel().obs;
  Rx<UserDetailByIdModel> userDetailByIdModel = UserDetailByIdModel().obs;
  Rx<ProfileModel> profileModel = ProfileModel().obs;
  Rx<AboutUsModel> aboutUsModel = AboutUsModel().obs;
  Rx<User> userData = User().obs;
  TextEditingController emailCon = TextEditingController();
  Rx<TextEditingController> searchController = TextEditingController().obs;
  TextEditingController txtUsername = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController mobileCon = TextEditingController();
  TextEditingController referralCon = TextEditingController();
  TextEditingController areaCon = TextEditingController();
  TextEditingController userTypeCon = TextEditingController();
  RxList<BookingJobData> listOfJobList = <BookingJobData>[].obs;

  RxList<AssignedJobData> detailList = <AssignedJobData>[].obs;
  RxList<BookingJobData> listOfAssignedJobList = <BookingJobData>[].obs;
  RxList<JobHistoryData> listOfJobHistoryJobList = <JobHistoryData>[].obs;
  RxList<SliderData> sliderDataList = <SliderData>[].obs;
  RxList<AssignedJobData> jobsNotifiedList = <AssignedJobData>[].obs;
  RxList<OrderStatusDataModel> orderStatusDataList = <OrderStatusDataModel>[].obs;

  Future<void> getUserData() async {
    String userStringData =
        SharedPrefHelper.sharedPreferences.getString('userData') ?? '';
    Map userMapData = userStringData.isEmpty ? {} : jsonDecode(userStringData);
    userDataWithToken.value = userMapData.isEmpty
        ? UserDataModel()
        : UserDataModel.fromJson(userMapData);

    userData.value = userDataWithToken.value.data?.user ?? User();
    log(userDataWithToken.value.data?.token ?? "");
    ApiHelper.apiHelper.authorizationToken =
        userDataWithToken.value.data?.token ?? "";
  }

  RxList<Widget> screenDataList = [
    const HomePage(),
    const JobHistoryPage(),
    const NotificationScreen(),
    const ProfileScreen(),
  ].obs;

  RxBool hasShownJobDialogThisSession = false.obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    // Run after the widget is fully rendered
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.find<HomeController>().fetchJobsNotifiedToVendorAndUser();
    });

    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// ////////////    EDIT PROFILE COMPONENTS  /////////////////

  TextEditingController nameEditCon = TextEditingController();
  TextEditingController emailEditCon = TextEditingController();
  TextEditingController mobileEditCon = TextEditingController();

  // get jobs which are notified
  Future<void> fetchJobsNotifiedToVendorAndUser() async {
    try {
      if (hasShownJobDialogThisSession.value) return;

      List<AssignedJobData> jobs = await ApiHelper.apiHelper.getJobsForVendorAndUsersOpenNotificationApi();

      if (jobs.isEmpty) return;

      hasShownJobDialogThisSession.value = true;
      jobsNotifiedList.assignAll(jobs);

      final PageController pageController = PageController();
      int currentIndex = 0;

      if (Get.context == null) return;

      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                title: Text(
                  'Job ${currentIndex + 1} of ${jobs.length}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 360, // fixed safe height, not LayoutBuilder
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: jobs.length,
                          onPageChanged: (index) => setState(() => currentIndex = index),
                          itemBuilder: (context, index) {
                            final job = jobs[index];
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        height: Get.height * 0.15,
                                        width: Get.height * 0.15,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey, width: 1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: ConstHelper.userImagePath + (job.serviceImage ?? ""),
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) => Center(
                                              child: SizedBox(
                                                height: Get.height * 0.05,
                                                width: Get.height * 0.05,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: ConstHelper.darkBlueColor,
                                                ),
                                              ),
                                            ),
                                            errorWidget: (_, __, ___) => Image.network(
                                              ConstHelper.noImage,
                                              height: 80,
                                              width: 80,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _infoRow(Icons.receipt_long, "Order Ref", job.orderRef),
                                  _infoRow(Icons.verified_user, "Person", job.orderCustomer),
                                  _infoRow(Icons.home_repair_service, "Service", job.orderService),
                                  _infoRow(Icons.calendar_today, "Date", _formatDate(job.orderServiceDate)),
                                  _infoRow(Icons.access_time, "Time Slot", job.orderTime),
                                  _infoRow(Icons.currency_rupee, "Amount", "₹${job.orderAmount ?? 0}"),
                                  _infoRow(
                                    Icons.location_on,
                                    "Address",
                                    job.orderServiceDate != null &&
                                        DateTime.now().isAfter(job.orderServiceDate!.subtract(const Duration(days: 1)))
                                        ? (job.orderAddress ?? '')
                                        : [job.orderSubLocality, job.orderLocality]
                                        .where((e) => e != null && e.trim().isNotEmpty)
                                        .join(", "),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(jobs.length, (index) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentIndex == index ? AppColors.primaryColor : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        label: const Text(
                            "Close",
                            style: TextStyle(color: Colors.red)
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text("Accept"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {

                          final job = jobs[currentIndex];

                          final result = await ApiHelper.apiHelper.acceptJobReceivedUsingNotificationStyleApi(
                              job.orderRef
                          );

                          if (result['status'] == 200) {
                            Get.snackbar("Success", result['message'], snackPosition: SnackPosition
                                .BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
                            if (context.mounted) Navigator.pop(context); // dismiss dialog
                          } else {
                            Get.snackbar("Error", result['message'], snackPosition: SnackPosition
                                .BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                          }

                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      );

    } catch (e) {
      debugPrint("fetchJobsNotifiedToVendorAndUser error: $e");
    }
  }

  String _formatDate(DateTime? dateStr) {
    if (dateStr == null) return '-';
    return DateFormat('dd MMM, yyyy').format(dateStr);
  }

  Widget _infoRow(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: value?.toString().isNotEmpty == true ? value.toString() : '-',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getOrderStatusData()
  async{
    final response = await ApiHelper.apiHelper.getOrderStatus();

    List data = response["data"];

    orderStatusDataList.value =
        data.map((e) => OrderStatusDataModel.fromJson(e)).toList();
    print("SSSSSSSS ${orderStatusDataList.length}");
  }

}
