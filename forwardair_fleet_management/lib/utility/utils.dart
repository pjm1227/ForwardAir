import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
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

  //This method is used to show snack bar
  static showSnackBar(String text, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: AppColors.colorRed,
      /* action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),*/
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
