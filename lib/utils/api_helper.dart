import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:v3care/model/assigned_job_model.dart';

import '../../Utils/api.dart';
import '../controller/home_controller.dart';
import '../model/about_us_model.dart';
import '../model/assigned_job_detail_model.dart';
import '../model/booking_job_model.dart';
import '../model/job_history_model.dart';
import '../model/notification_model.dart';
import '../model/order_status_model.dart';
import '../model/profile_model.dart';
import '../model/slider_model.dart';
import '../model/user_detail_by_id_model.dart';
import '../model/user_detail_model.dart';

class ApiHelper {
  ApiHelper._();

  static ApiHelper apiHelper = ApiHelper._();
  HomeController homeController = getx.Get.put(HomeController());

  API api = API();
  dynamic authorizationToken;

  void getAuthorizationToken() {
    authorizationToken =
        homeController.userDataWithToken.value.data?.token ?? '';
    debugPrint(authorizationToken);
  }

  Future<Map> checkMobileNumber({
    required String mobileNo,
  }) async {
    getAuthorizationToken();

    var data = FormData.fromMap({
      'mobile': mobileNo,
    });
    Response response = await api.dio.post(
      'check-mobile',
      data: data,
    );
    debugPrint(response.data.toString());
    if (response.statusCode == 200) {
      var data = response.data;
      return data;
    } else {
      return {};
    }
  }

  Future<Map> loginUser({
    required String mobileNo,
    required String password,
    required String deviceId,
  }) async {
    try {
      getAuthorizationToken();
      var data = FormData.fromMap({
        'mobile': mobileNo,
        'password': password,
        'device_id': deviceId,
      });
      Response response = await api.dio.post(
        'login',
        data: data,
      );
      if (response.statusCode == 200) {
        var data = response.data;
        return data;
      } else {
        return {};
      }
    } catch (error) {
      return {};
    }
  }

  Future<Map> signUpUser({
    required String name,
    required String email,
    required String mobile,
    required String userType,
    required String area,
    required String referredCode,
  }) async {
    try {
      getAuthorizationToken();
      var data = FormData.fromMap({
        'person_name': name,
        'person_email': email,
        'person_mobile': mobile,
        'person_user_type': userType,
        'person_area': area,
        'referred_by_code': referredCode,
      });
      Response response = await api.dio.post(
        'sign-up',
        data: data,
      );
      if (response.statusCode == 200) {
        var data = response.data;
        return data;
      } else {
        return {};
      }
    } catch (error) {
      return {};
    }
  }

  Future postDeleteProfileApi() async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };
      Response response = await api.dio.post(
        'delete-account',
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint(data.toString());
        debugPrint('runtimeType ${data.runtimeType} ${data['data'].runtimeType}');

        return data;
      } else {
        return {};
      }
    } catch (error) {
      debugPrint(error.toString());
      return {};
    }
  }

  Future<List<NotificationData>> fetchNotificationApiUrl({
    required RxBool loading,
  }) async {
    try {
      getAuthorizationToken();
      var headers = {'Authorization': 'Bearer $authorizationToken'};
      loading.value = true;
      Response response = await api.dio.post('fetch-notification',
          options: Options(
            headers: headers,
          ));

      debugPrint("fetchNotificationApiUrl statusCode:- ${response.statusCode}");
      if (response.statusCode == 200) {
        debugPrint("fetchNotificationApiUrl response:- ${response.data}");
        loading.value = false;

        return notificationModelFromJson(jsonEncode(response.data)).data ?? [];
      } else {
        loading.value = false;
      }
    } catch (error) {
      loading.value = false;

      debugPrint(error.toString());
      return [];
    }
    return [];
  }

  Future createShareApi({
    required String id,
  }) async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };
      var data = FormData.fromMap({
        'share_to_id': id,
      });
      Response response = await api.dio.post(
        'create-share',
        data: data,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint(data.toString());
        debugPrint(
            'createShareApi :::::: $data ${data.runtimeType} ${data['data'].runtimeType}');

        return data;
      } else {
        return {};
      }
    } catch (error) {
      debugPrint(error.toString());
      return {};
    }
  }

  Future getOrderStatus()
  async{
    try{
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      Response response = await api.dio.post(
        'fetch-orderStatus',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return {
          'status': response.data['code'] ?? 200,
          'data': response.data['data']??[],
        };
      } else {
        return {
          'status': response.statusCode,
          'message': response.statusMessage ?? 'Unexpected response',
        };
      }

    }
    catch(error)
    {
      return {
        'status': 500,
        'message': 'Something went wrong',
      };
    }
  }

  Future<List<BookingJobData>> getAllJobsApi() async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };
      debugPrint('Bearer $authorizationToken');
      Response response = await api.dio.post(
        'fetch-booking',
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint('getAllJobsApi data $data');
        return BookingJobModel.fromJson(data).data ?? [];
      } else {
        return [];
      }
    } catch (error) {
      debugPrint('error $error');
      return [];
    }
  }

  Future<List<AssignedJobData>> getJobDetailApi(
      {required String orderRef}) async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };
      var data = FormData.fromMap({
        'order_ref': orderRef,
      });
      debugPrint('Bearer $authorizationToken');
      Response response = await api.dio.post(
        'fetch-booking-details',
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint('getJobDetailApi data $data');
        return AssignedJobDetailModel.fromJson(data).data ?? [];
      } else {
        return [];
      }
    } catch (error) {
      debugPrint('getJobDetailApi error $error');
      return [];
    }
  }

  Future<Map> statusChangeOfJOB({
    required String ref,
    required String status,
  }) async {
    getAuthorizationToken();
    var headers = {
      'Authorization': 'Bearer $authorizationToken',
    };
    if (kDebugMode) {
      print({
        'order_ref': ref,
        'order_status': status.toLowerCase(),
      });
    }
    var data = FormData.fromMap({
      'order_ref': ref,
      'order_status': status,
    });

    if (kDebugMode) {
      print(
        {'order_ref': ref, 'order_status': status},
      );
    }
    Response response = await api.dio.post(
      'update-booking-status',
      data: data,
      options: Options(
        headers: headers,
      ),
    );
    debugPrint('statusChangeOfJOB response.data ${response.data}');
    debugPrint('statusChangeOfJOB response.statusCode ${response.statusCode}');
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.data);
      }
      var data = response.data;
      EasyLoading.dismiss();
      return data;
    } else {
      EasyLoading.dismiss();
      return {};
    }
  }

  Future<Map> createCommentOfJOB({
    required String ref,
    required String comment,
  }) async {
    try {
      getAuthorizationToken();
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };
      var data = FormData.fromMap({
        'order_ref': ref,
        'order_comment': comment,
      });
      if (kDebugMode) {
        print({
          'order_ref': ref,
          'order_comment': comment,
        });
      }
      Response response = await api.dio.post(
        'update-booking-comment',
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      debugPrint('createCommentOfJOB response.data ${response.data}');
      if (response.statusCode == 200) {
        var data = response.data;

        return data;
      } else {
        return {};
      }
    } catch (error) {
      debugPrint('createCommentOfJOB error $error');

      return {};
    }
  }

  Future<List<JobHistoryData>> getAllHistoryJobsApi() async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };
      debugPrint('Bearer $authorizationToken');
      Response response = await api.dio.post(
        'fetch-booking-history',
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint('getAllHistoryJobsApi data $data');
        return JobHistoryModel.fromJson(data).data ?? [];
      } else {
        return [];
      }
    } catch (error) {
      debugPrint('getAllHistoryJobsApi error $error');
      return [];
    }
  }

  Future<List<BookingJobData>> getAllAssignedJobsApi() async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };
      debugPrint('Bearer $authorizationToken');
      Response response = await api.dio.post(
        'fetch-assign-booking',
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint('getAllAssignedJobsApi data $data');
        return AssignedJobModel.fromJson(data).data ?? [];
      } else {
        return [];
      }
    } catch (error) {
      debugPrint('error $error');
      return [];
    }
  }

  Future<List<SliderData>> getAllSliderData() async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };
      debugPrint('Bearer $authorizationToken');
      Response response = await api.dio.post(
        'fetch-slider',
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint('getAllSliderData $data');
        return SliderModel.fromJson(data).data ?? [];
      } else {
        return [];
      }
    } catch (error) {
      debugPrint('getAllSliderData error $error');
      return [];
    }
  }

  Future<UserDetailModel> getUserDetailData(String companyShort) async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };
      var data = FormData.fromMap({
        "companyShort": companyShort,
      });
      debugPrint('Bearer $authorizationToken');
      Response response = await api.dio.post(
        'fetch-user-details',
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint('getAllSliderData $data');
        return UserDetailModel.fromJson(data);
      } else {
        return UserDetailModel();
      }
    } catch (error) {
      debugPrint('getAllSliderData error $error');
      return UserDetailModel();
    }
  }

  Future<UserDetailByIdModel> getUserDetailByIdData(String id) async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };
      var data = FormData.fromMap({
        "user_id": id,
      });
      debugPrint('Bearer $authorizationToken');
      Response response = await api.dio.post(
        'fetch-user-by-id',
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint('getAllSliderData $data');
        return UserDetailByIdModel.fromJson(data);
      } else {
        return UserDetailByIdModel();
      }
    } catch (error) {
      debugPrint('getAllSliderData error $error');
      return UserDetailByIdModel();
    }
  }

  Future<ProfileModel> getProfileData() async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      debugPrint('Bearer $authorizationToken');
      Response response = await api.dio.post(
        'fetch-profile',
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint('getProfileData $data');
        return ProfileModel.fromJson(data);
      } else {
        return ProfileModel();
      }
    } catch (error) {
      debugPrint('getProfileData error $error');
      return ProfileModel();
    }
  }

  Future<AboutUsModel> getAboutUsData() async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      debugPrint('Bearer $authorizationToken');
      Response response = await api.dio.post(
        'fetch-company',
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint('getAboutUsData $data');
        return AboutUsModel.fromJson(data);
      } else {
        return AboutUsModel();
      }
    } catch (error) {
      debugPrint('getAboutUsData error $error');
      return AboutUsModel();
    }
  }

  Future<Map> postFeedBackApi({
    required String sub,
    required String des,
  }) async {
    try {
      getAuthorizationToken();
      var data = FormData.fromMap(
          {'feedback_subject': sub, 'feedback_description': des});
      if (kDebugMode) {
        print({'feedback_subject': sub, 'feedback_description': des}.toString());
      }
      var headers = {'Authorization': 'Bearer $authorizationToken'};

      Response response = await api.dio.post(
        'create-feedback',
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      if (kDebugMode) {
        print(response.data);
      }
      if (response.statusCode == 200) {
        var data = response.data;
        return data;
      } else {
        return {};
      }
    } catch (error) {
      return {};
    }
  }

  Future<Map> updateProfileApi({
    required String name,
    required String mobile,
    required String email,
    required RxBool loading,
  }) async {
    try {
      loading.value = true;
      getAuthorizationToken();
      var data =
      FormData.fromMap({'name': name, 'mobile': mobile, 'email': email});
      if (kDebugMode) {
        print({'name': name, 'mobile': mobile, 'email': email}.toString());
      }
      var headers = {'Authorization': 'Bearer $authorizationToken'};

      Response response = await api.dio.post(
        'update-profile',
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      if (kDebugMode) {
        print(response.data);
      }
      if (response.statusCode == 200) {
        loading.value = false;
        var data = response.data;
        return data;
      } else {
        loading.value = false;
        return {};
      }
    } catch (error) {
      loading.value = false;
      return {};
    }
  }

  Future<Map> paymentUpdateApi({
    required String ref,
    required String paymentType,
    required String amount,
    String? orderComment,
    required String discount,
    required String transactionDetail,
  }) async {
    getAuthorizationToken();
    var headers = {
      'Authorization': 'Bearer $authorizationToken',
    };
    var data = FormData.fromMap({
      'order_ref': ref,
      'order_payment_type': paymentType,
      'order_comment': orderComment,
      'order_payment_amount': amount,
      'order_discount': discount,
      'order_transaction_details': transactionDetail,
    });

    if (kDebugMode) {
      print(
        {
          'order_ref': ref,
          'order_payment_type': paymentType,
          'order_comment': orderComment,
          'order_payment_amount': amount,
          'order_discount': discount,
          'order_transaction_details': transactionDetail,
        },
      );
    }
    Response response = await api.dio.post(
      'update-booking-payment',
      data: data,
      options: Options(
        headers: headers,
      ),
    );
    debugPrint('statusChangeOfJOB response $response');
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.data);
      }
      var data = response.data;

      return data;
    } else {
      return {};
    }
  }

  // Jobs for vendors like open notification
  Future<List<AssignedJobData>> getJobsForVendorAndUsersOpenNotificationApi() async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      debugPrint('Bearer $authorizationToken');

      Response response = await api.dio.post(
        'fetch-vendor-booking-request',
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('getJobsForVendorsApi data ${response.data}');

        // Deserialize JSON response using your model
        final model = AssignedJobDetailModel.fromJson(response.data);

        // Return the list or empty list if null
        return model.data ?? [];
      } else {
        return [];
      }

    } catch (error, stackTrace) {
      debugPrint('getJobsForVendorAndUsersOpenNotificationApi error: $error');
      debugPrintStack(stackTrace: stackTrace);
      return [];
    }
  }

  // accept job which was sent using notification type api
  Future<Map<String, dynamic>> acceptJobReceivedUsingNotificationStyleApi(String? orderRedId) async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      var data = FormData.fromMap({
        'order_ref': orderRedId,
      });

      Response response = await api.dio.post(
        'create-booking-vendor-accept',
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return {
          'status': response.data['code'] ?? 200,
          'message': response.data['msg'] ?? 'Success',
        };
      } else {
        return {
          'status': response.statusCode,
          'message': response.statusMessage ?? 'Unexpected response',
        };
      }

    } catch (e, stackTrace) {
      debugPrint('acceptJobReceivedUsingNotificationStyleApi error: $e');
      debugPrintStack(stackTrace: stackTrace);
      return {
        'status': 500,
        'message': 'Something went wrong',
      };
    }
  }



}
