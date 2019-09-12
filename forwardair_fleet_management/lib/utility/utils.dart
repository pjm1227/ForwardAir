import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';

import 'colors.dart';
import 'constants.dart';

class Utils {
  static showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: AppColors.colorRed,
      textColor: AppColors.colorWhite,
    );
  }

  //To check the internet connectivity
  static Future<bool> checkTheInternetConnection()async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        return true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        return true;
      }
      return false;
    }
}
