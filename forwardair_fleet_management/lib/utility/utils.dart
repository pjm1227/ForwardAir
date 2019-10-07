import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:intl/intl.dart';
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

  //This method is used to show snack bar
  static showSnackBar(String text, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: AppColors.colorRed,
      duration: Duration(seconds: 2),
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static Future<bool> isConnectionAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  //Number formatting
  String formatDecimalsNumber(double decimalNumber) {
    final formatter = new NumberFormat("#,###.00");
    String formattedNumber = formatter.format(decimalNumber);
    return formattedNumber;
  }

  //Decimals to whole number
  static String formatDecimalToWholeNumber(dynamic decimalNumber) {
    final formatter = new NumberFormat("#,###");
    String formattedNumber = formatter.format(decimalNumber);
    return formattedNumber;
  }

  static String formatDateFromString(String dateString) {
    String date = '';
    date = dateString.substring(0, 4) +
        '/' +
        dateString.substring(4, 6) +
        '/' +
        dateString.substring(6, 8);
    return date;
  }
}
