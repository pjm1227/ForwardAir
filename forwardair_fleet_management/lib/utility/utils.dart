import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'colors.dart';

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
    if (decimalNumber == 0) {
      return '0';
    }
    final formatter = new NumberFormat("#,###.00");
    String formattedNumber = formatter.format(decimalNumber);
    return formattedNumber;
  }

  //Decimals to whole number
  static String formatDecimalToWholeNumber(dynamic decimalNumber) {
    try {
      final formatter = new NumberFormat("#,###");
      String formattedNumber = formatter.format(decimalNumber);
      return formattedNumber;
    } catch (_) {
      return 'N/A';
    }
  }

  //Date Formatter
  static String formatTimeFromString(String timeString) {
    String time = '';
    time = timeString.substring(9, 11) + ':' + timeString.substring(11, 13);
    return time;
  }

  //Format Date to MM/dd/yyyy
  static String formatDateFromString(String dateString) {
    try {
      var formattedString = '';
      if (dateString != '') {
        final date = DateTime.parse(dateString);
        final f = new DateFormat('MM/dd/yyyy');
        formattedString = f.format(date);
      }
      return formattedString;
    } catch (_) {
      return 'N/A';
    }
  }

  //Format Start and End Date String
  static String formatStringDateToDateAndMonth(String dateString) {
    var formattedString = '';
    if (dateString != '') {
      final date = DateTime.parse(dateString);
      final f = new DateFormat('dd MMM');
      formattedString = f.format(date);
    }
    return formattedString;
  }

  //Date Format like 'MMMM, yyyy'
  static String dateNowToFormat(DateTime date) {
    var formattedString = '';
    if (date != null) {
      final format = new DateFormat('MMMM, yyyy');
      formattedString = format.format(date);
    }
    return formattedString;
  }

  //Date Format like 'MM'
  static String pickerDateToFormat(DateTime date) {
    var formattedString = '';
    if (date != null) {
      final format = new DateFormat('MM');
      formattedString = format.format(date);
    }
    return formattedString;
  }

  //To pick only month from String
  static String pickOnlyMonthInCheckList(String dateString) {
    var formattedString = '';
    if (dateString != '') {
      final date = DateTime.parse(dateString);
      final f = new DateFormat('MM');
      formattedString = f.format(date);
    }
    return formattedString;
  }

  //Append $ after - sign
  static String addDollarAfterMinusSign(String deductions) {
    String deduction = '';
    if (deductions != 'N/A') {
      deduction = '-\$' + deductions.replaceAll(RegExp('-'), '');
    } else {
      deduction = 'N/A';
    }
    return deduction;
  }

  //Append $ Sign
  static String appendDollarSymbol(double value) {
    if (value == 0.0) {
      return '\$' + value.toString();
    }
    var commaAddedText =
        Utils().formatDecimalsNumber(value != null ? value : '');
    if (commaAddedText != '') {
      return '\$' + commaAddedText;
    } else {
      return 'N/A';
    }
  }

  //Findout past and upcoming dates with today's date
  static bool findOutDateIsPastAndFuture(String inDate) {
    final date = DateTime.parse(inDate);
    final formatter = new DateFormat('yyyyMMdd');
    final inputDate = formatter.format(date);
    final todayDate = formatter.format(DateTime.now());
    final iDate = DateTime.parse(inputDate);
    final tDate = DateTime.parse(todayDate);
    if (iDate.isBefore(tDate)) {
      return true;
    }
    return false;
  }

  //Date format like 'dd MMM yyyy'
  static String formatStartAndEndDate(String dateString) {
    var formattedString = '';
    if (dateString != '') {
      final date = DateTime.parse(dateString);
      final f = new DateFormat('dd MMM yyyy');
      formattedString = f.format(date);
    }
    return formattedString;
  }

  //Date and Time format like dd MMMM HH:mm aa
  static String formatDateAndTime(String dateString) {
    var formattedString = '';
    if (dateString != '') {
      final date = DateTime.parse(dateString);
      final f = new DateFormat('dd MMMM HH:mm aa');
      formattedString = f.format(date);
    }
    return formattedString;
  }

  /// Whether or not two times are on the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
