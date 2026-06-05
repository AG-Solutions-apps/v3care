import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/app_colors.dart';
import '../Constants/app_defaults.dart';
import '../Constants/app_sizes.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.isBackIcon,
    this.bottom,
    required this.title,
    this.isAction,
    this.actionIcon,
    this.onTapAction,
    this.appBarHeight,
    this.color,
    this.leading,
    this.leadingWidth,
    this.action,
  });

  final bool? isBackIcon;
  final bool? isAction;
  final String title;
  final double? appBarHeight;
  final IconData? actionIcon;
  final PreferredSizeWidget? bottom;
  final void Function()? onTapAction;
  final Color? color;
  final Widget? leading;
  final Widget? action;
  final double? leadingWidth;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(appBarHeight ?? 70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      centerTitle: false,
      // Controls the shadow depth
      backgroundColor: AppColors.white,
      toolbarHeight: appBarHeight ?? 70,
      automaticallyImplyLeading: isBackIcon ?? true,
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          textStyle: Theme.of(context).textTheme.displayMedium,
          color: AppColors.secondaryColor,
          fontSize: Get.height / 40,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: leading ??
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(
              "assets/images/svg/back_icon.svg",
              height: Get.height * 0.035,
              colorFilter:
                  const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
            ),
          ),
      leadingWidth: leadingWidth,
      bottom: bottom,
      actions: [
        action ?? const SizedBox(),
        if (isAction ?? false)
          GestureDetector(
            onTap: onTapAction,
            child: Container(
              margin:
                  EdgeInsets.only(right: AppSizes.horizontalPadding24(context)),
              padding: const EdgeInsets.all(AppSizes.defaultRadius),
              decoration: BoxDecoration(
                  color: color ?? Colors.transparent,
                  borderRadius: AppDefaults.defaultBorderRadius),
              child: Icon(
                actionIcon,
                color: AppColors.primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}

/*class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomHomeAppBar({
    super.key,
    this.isBackIcon,
    required this.title,
     this.subTitle,
    this.isAction, this.actionIcon, this.onTapAction, this.appBarHeight, this.isColumn, this.leading, this.leadingWidth, this.assetName, this.storeRating, this.ratingCount,
  });

  final bool? isBackIcon;
  final bool? isColumn;
  final bool? isAction;
  final String title;
  final String? subTitle;
  final String? storeRating;
  final String? ratingCount;
  final double? appBarHeight;
  final IconData? actionIcon;
  final void Function()? onTapAction;
  final Widget? leading;
  final String? assetName;
  final double? leadingWidth;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(appBarHeight ?? 70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.textSky,
      elevation: 0,
      titleSpacing: 0,
      centerTitle: true,
      toolbarHeight: AppSizes.displayHeight(context) * 80/800,
      automaticallyImplyLeading: isBackIcon ?? true,
      leadingWidth:leadingWidth,
      leading: leading,
      title:isColumn== true? InkWell(
        onTap: () {
          Get.toNamed(RouteConstants.registerStoreDetailsScreen, arguments: {"isFromDrawer" : true});
          //Get.toNamed(RouteConstants.editScreen);
        },
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subTitle ?? "",
                  style: AppDefaults.textRegular12,
                ),
                Text(
                  title,
                  style: AppDefaults.textRegular12,
                ),
                if(storeRating != null && storeRating != "null" && storeRating != "N/A" && storeRating != "")
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orangeAccent,
                        size: 12,
                      ),
                      Text(
                        "${storeRating!}($ratingCount)",
                        style: AppDefaults.textStyleRegular12(fontColor: AppColors.primaryColor),
                      ),
                    ],
                  )
              ],
            ),
          ],
        ),
      ):Text(
        title,
        style: const TextStyle(
            fontSize: 20.0,
            fontFamily: AppFonts.poppinsRegular,
            color: AppColors.textHint,
            fontWeight: FontWeight.w600
        ),
      ),
      actions: [
        assetName != null ?
        GestureDetector(
            onTap: onTapAction,
            child: Container(
                margin: EdgeInsets.only(
                    right: AppSizes.horizontalPadding24(context)),
                padding: const EdgeInsets.all(AppSizes.defaultRadius),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: AppDefaults.defaultBorderRadius),
                child: SvgPicture.asset(assetName!))):const SizedBox()
      ],
    );
  }
}*/
