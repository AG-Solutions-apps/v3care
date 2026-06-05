import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/const_helper.dart';

class CommonBanner extends StatelessWidget {
  final List<String> imageUrls;
  final bool autoPlay;
  final double height;
  final bool enableInfiniteScroll;
  final bool enlargeCenterPage;

  const CommonBanner({
    super.key,
    required this.imageUrls,
    this.autoPlay = true,
    this.height = 200,
    this.enableInfiniteScroll = true,
    this.enlargeCenterPage = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                  spreadRadius: 2, // Slight spread
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                // imageUrl: 'https://www.wemakescholars.com/uploads/blog/TopprofessionalITcoursetopursueincollege.jpg',
                imageUrl: imageUrls[index],
                fit: BoxFit.fill,
                width: Get.width,
                height: Get.height * 0.17,
                placeholder: (context, url) =>
                    Center(
                      child: CircularProgressIndicator(
                        color: ConstHelper.darkBlueColor,
                      ),
                    ),
                errorWidget: (context, url, error) =>
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        ConstHelper.noImage,
                        fit: BoxFit.fill,
                      ),
                    ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) =>
            SizedBox(
              width: Get.width * 0.02,
            ),
        itemCount: imageUrls.length);
  }
}
