import 'package:get/get.dart';

import '../Utils/api_helper.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isLoading = false.obs;

  RxList<NotificationData> notificationList = <NotificationData>[].obs;

  var currentPage = 0.obs; // Observable to track the current page

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    getNotificationData();
    super.onReady();
  }

  void getNotificationData() async {
    notificationList.value = await ApiHelper.apiHelper.fetchNotificationApiUrl(
      loading: isLoading,
    );
  }
}
