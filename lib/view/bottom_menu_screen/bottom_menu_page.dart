import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v3care/view/payment_detail/payment_detail_screen.dart';
import 'package:v3care/widget/safe_pop_scope.dart';

import '../../Constants/app_colors.dart';
import '../../Utils/const_helper.dart';
import '../../controller/home_controller.dart';
import '../../widget/custom_app_bar.dart';
import '../login_screen/login_page.dart';
import '../about_us/about_us_screen.dart';
import '../services/feedback_screen.dart';

class BottomMenuPage extends StatefulWidget {
  const BottomMenuPage({super.key});

  @override
  State<BottomMenuPage> createState() => _BottomMenuPageState();
}

class _BottomMenuPageState extends State<BottomMenuPage> {
  HomeController homeController = Get.put(HomeController());
  DateTime? currentBackPressTime;
  List<Map<dynamic, dynamic>> menuItem = [
    {"icon": "assets/images/svg/profile.svg", "title": "Profile"},
    {"icon": "assets/images/svg/new_job_icon.svg", "title": "New Jobs"},
    {
      "icon": "assets/images/svg/assigned_job_icon.svg",
      "title": "Assigned Job"
    },
    {"icon": "assets/images/svg/job_history.svg", "title": "Job History"},
    {"icon": "assets/images/payment_icon.png", "title": "Payment Details"},
    {"icon": "assets/images/svg/feedback.svg", "title": "Feedback"},
    {"icon": "assets/images/svg/about_us_icon.svg", "title": "About Us"},
    {"icon": "assets/images/svg/log_out_icon.svg", "title": "Log Out"},
  ];

  @override
  void initState() {
    // FirebaseHelper.firebaseHelper.initializeFirebaseMessaging();
    homeController.nameCon.clear();
    homeController.emailCon.clear();
    homeController.mobileCon.clear();
    homeController.userTypeCon.clear();
    homeController.areaCon.clear();
    homeController.referralCon.clear();
    super.initState();
  }

  Future<bool> onWillPop() async {
    if (homeController.bottomIndex.value != 0) {
      homeController.bottomIndex.value = 0;
      return false;
    }
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Get.snackbar(
        "Exit Now?",
        "Click back again to exit",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafePopScope(
      canPop: true,
      onWillPop: onWillPop,
      child: SafeArea(
        child: Obx(
          () => Scaffold(
            backgroundColor: AppColors.white,
            appBar: CustomAppbar(
              title: !homeController.isMenuOpen.value
                  ? homeController.bottomIndex.value == 0
                      ? 'Home'
                      : homeController.bottomIndex.value == 1
                          ? 'Jobs History'
                          : homeController.bottomIndex.value == 2
                              ? 'Notification'
                              : 'Profile'
                  : "Menu",
              leading: Padding(
                padding: EdgeInsets.all(Get.height * 0.012),
                child: MenuCloseIcon(
                  menuIconPath: 'assets/images/svg/menu_icon.svg',
                  closeIconPath: 'assets/images/svg/menu_icon.svg',
                  onToggle: (isMenuOpen) {
                    homeController.isMenuOpen.value = isMenuOpen;
                  },
                  isMenuOpen: homeController.isMenuOpen.value,
                ),
              ),
            ),
            body: Obx(
              () => Stack(
                children: [
                  homeController
                      .screenDataList[homeController.bottomIndex.value],
                  Visibility(
                    visible: homeController.isMenuOpen.value,
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            homeController.isMenuOpen.value = false;
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.black.withAlpha(153), // Semi-transparent overlay
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomRight:
                                      Radius.circular(Get.height * 0.02),
                                  bottomLeft:
                                      Radius.circular(Get.height * 0.02)),
                            ),
                            child: Card(
                              color: AppColors.white,
                              surfaceTintColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomRight:
                                        Radius.circular(Get.height * 0.02),
                                    bottomLeft:
                                        Radius.circular(Get.height * 0.02)),
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                children: menuItem.map((item) {
                                  return ListTile(
                                    leading: item['icon']
                                            .toString()
                                            .toLowerCase()
                                            .contains("png")
                                        ? Image.asset(
                                            item['icon'],
                                            width: Get.height * 0.04,
                                            height: Get.height * 0.04,
                                          )
                                        : SvgPicture.asset(
                                            item['icon'],
                                            width: 24,
                                            height: 24,
                                          ),
                                    title: Text(item['title']),
                                    onTap: () async {
                                      int index = menuItem.indexOf(item);
                                      switch (index) {
                                        case 0:
                                          homeController.isMenuOpen.value =
                                              false;
                                          homeController.bottomIndex.value = 3;
                                          break;
                                        case 1:
                                          homeController.isMenuOpen.value =
                                              false;
                                          homeController.bottomIndex.value = 0;
                                          homeController.tabController.index =
                                              0;
                                          break;
                                        case 3:
                                          homeController.isMenuOpen.value =
                                              false;
                                          homeController.bottomIndex.value = 1;
                                          break;
                                        case 2:
                                          homeController.isMenuOpen.value =
                                              false;
                                          homeController.bottomIndex.value = 0;
                                          homeController.tabController.index =
                                              1;
                                          break;
                                        case 4:
                                          Get.to(() => const PaymentPage());
                                          break;
                                        case 5:
                                          Get.to(() => const FeedbackScreen());
                                          break;
                                        case 6:
                                          Get.to(() => const AboutUsScreen());
                                          break;
                                        case 7:
                                          ConstHelper.constHelper
                                              .areYouSureWantAlertDialog(
                                            title: 'Confirm Logout?',
                                            description:
                                                'You are about to log out. Do you wish to continue?',
                                            onPressed: () async {
                                              Get.back();
                                              homeController.isMenuOpen.value =
                                                  false;
                                              final SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.clear();
                                              Get.offAll(
                                                  () => const LoginPage());
                                            },
                                          );
                                          break;
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: IntrinsicHeight(
              child: Obx(
                () => SafeArea(child: Container(
                  width: Get.width,
                  color: AppColors.white,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            homeController.bottomIndex.value = 0;
                            homeController.isMenuOpen.value = false;
                            homeController.tabController.index = 0;
                          },
                          child: Container(
                            width: Get.width,
                            color: Colors.transparent,
                            child: Center(
                              child: bottomItem(
                                index: 0,
                                imagePath: 'assets/images/svg/home-2.svg',
                                title: 'Home',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            homeController.bottomIndex.value = 1;
                            homeController.isMenuOpen.value = false;
                          },
                          child: Container(
                            width: Get.width,
                            color: Colors.transparent,
                            child: Center(
                              child: bottomItem(
                                  index: 1,
                                  imagePath: 'assets/images/svg/job_icon.svg',
                                  title: 'History'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            homeController.bottomIndex.value = 2;
                            homeController.isMenuOpen.value = false;
                          },
                          child: Container(
                            width: Get.width,
                            color: Colors.transparent,
                            child: Center(
                              child: bottomItem(
                                  index: 2,
                                  imagePath:
                                  'assets/images/svg/notification_icon.svg',
                                  title: 'Notification'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            homeController.bottomIndex.value = 3;
                            homeController.isMenuOpen.value = false;
                          },
                          child: Container(
                            width: Get.width,
                            color: Colors.transparent,
                            child: Center(
                              child: bottomItem(
                                index: 3,
                                imagePath: 'assets/images/svg/profile_icon.svg',
                                title: 'Profile',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomItem({
    required int index,
    required String imagePath,
    required String title,
  }) {
    final isSelected = homeController.bottomIndex.value == index;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.008),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            imagePath,
            colorFilter: ColorFilter.mode(
              isSelected
                  ? AppColors.primaryColor
                  : AppColors.color80.withAlpha(77),
              BlendMode.srcIn,
            ),
            height: Get.width / 16,
            width: Get.width / 16,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: GoogleFonts.openSans(
                fontSize: Get.height / 80,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.color80.withAlpha(77),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomItemPng({required int index, required String imagePath}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Get.width / 30,
      ),
      child: IntrinsicWidth(
        child: Column(
          children: [
            Image.asset(
              imagePath,
              color: homeController.bottomIndex.value == index
                  ? AppColors.primaryColor
                  : AppColors.lightGrey,
              height: Get.width / 14,
              width: Get.width / 14,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCloseIcon extends StatefulWidget {
  final String menuIconPath;
  final String closeIconPath;
  final double iconSize;
  final Duration duration;
  final bool isMenuOpen; // External parameter to control state
  final void Function(bool isMenuOpen)? onToggle;

  const MenuCloseIcon({
    super.key,
    required this.menuIconPath,
    required this.closeIconPath,
    this.iconSize = 24.0,
    this.duration = const Duration(milliseconds: 300),
    required this.isMenuOpen,
    this.onToggle,
  });

  @override
  MenuCloseIconState createState() => MenuCloseIconState();
}

class MenuCloseIconState extends State<MenuCloseIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Set initial state based on isMenuOpen
    if (widget.isMenuOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(MenuCloseIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMenuOpen != oldWidget.isMenuOpen) {
      if (widget.isMenuOpen) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  void _toggleIcon() {
    bool newState = !widget.isMenuOpen;
    widget.onToggle?.call(newState);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleIcon,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 1.0 - _animation.value,
                child: SvgPicture.asset(
                  widget.menuIconPath,
                  height: Get.height * 0.031,
                ),
              ),
              Opacity(
                opacity: _animation.value,
                child: SvgPicture.asset(
                  widget.closeIconPath,
                  height: Get.height * 0.031,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
