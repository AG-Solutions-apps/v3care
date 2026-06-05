import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedBackController extends GetxController {

  final isLoading = false.obs;
  final isButtonLoading = false.obs;
  final subjectController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;

}
