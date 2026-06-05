import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  SharedPrefHelper._();

  static SharedPrefHelper sharedPrefHelper = SharedPrefHelper._();

  static late SharedPreferences sharedPreferences;

  Future<void> initSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

}