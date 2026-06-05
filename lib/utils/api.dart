import 'package:dio/dio.dart' show Dio;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API {
  final Dio _dio = Dio();

  /// LIVE URL
  //var imageBaseUrl = "https://agsdemo.in/v3careapi";
  var imageBaseUrl = "https://v3care.in/crmapi";

  /// TEST URL
  //var imageBaseUrl = "https://agscare.site/crmapi";

  /// TEST URL
  API() {
    /// LIVE URL
    // _dio.options.baseUrl = "https://agsdemo.in/v3careapi/public/api/";
    _dio.options.baseUrl = "https://v3care.in/crmapi/public/api/";

    /// TEST URL
    //_dio.options.baseUrl = "https://agscare.site/crmapi/public/api/";

    // _dio.options.baseUrl = "https://agsdraft.online/app/public/api/";
    //_dio.options.baseUrl = "https://agstest.online/public/api/";
    _dio.interceptors.add(PrettyDioLogger(
      request: false,
      responseBody: false,
    ));
  }

  Dio get dio => _dio;

}