import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/const_helper.dart';

class CommonCarouselSlider extends StatelessWidget {
  final List<String> imageUrls;
  final bool autoPlay;
  final double height;
  final bool enableInfiniteScroll;
  final bool enlargeCenterPage;

  const CommonCarouselSlider({
    super.key,
    required this.imageUrls,
    this.autoPlay = true,
    this.height = 200,
    this.enableInfiniteScroll = true,
    this.enlargeCenterPage = true,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: imageUrls.map((url) {
        debugPrint(url);

        return ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            // imageUrl: 'https://www.wemakescholars.com/uploads/blog/TopprofessionalITcoursetopursueincollege.jpg',
            imageUrl: url,
            fit: BoxFit.fill,
            width: Get.width,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                color: ConstHelper.darkBlueColor,
              ),
            ),
            errorWidget: (context, url, error) => ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                ConstHelper.noImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: Get.height * 0.22,
        autoPlay: autoPlay,
        aspectRatio: 0.2,
        viewportFraction: 0.7,
        enableInfiniteScroll: enableInfiniteScroll,
        enlargeCenterPage: enlargeCenterPage,
        autoPlayInterval: const Duration(seconds: 3),
      ),
    );
  }
}
