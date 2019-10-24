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
  static String formatDecimalsNumber(double decimalNumber) {
    if (decimalNumber == 0) {
      return '0';
    }
    try {
      final formatter = new NumberFormat("#,###.00");
      String formattedNumber = formatter.format(decimalNumber);
      return formattedNumber;
    } catch (_) {
      return 'N/A';
    }
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
    var commaAddedText = formatDecimalsNumber(value != null ? value : '');
    if (commaAddedText != '') {
      return '\$' + commaAddedText;
    } else {
      return 'N/A';
    }
  }

  //Find out past and upcoming dates with today's date
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

  //Format Time
  static String formatTimeOfDay(TimeOfDay tod) {
    if (tod != null) {
      final now = new DateTime.now();
      tod.periodOffset.abs();
      String amOrPmText = '';
      if (tod.period == DayPeriod.am) {
        amOrPmText = ' AM';
      } else {
        amOrPmText = ' PM';
      }
      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      // final format = DateFormat.jm(); for 12 Hr format
      final format = DateFormat.Hm(); //for 24 Hr format
     return format.format(dt) + amOrPmText;
    } else {
      return 'N/A';
    }
  }

  //Compare Start/End Date with Today date
  static compareStartandDateWithToday(DateTime inDate) {
    final formatter = new DateFormat('yyyyMMdd');
    final inputDate = formatter.format(inDate);
    final todayDate = formatter.format(DateTime.now());
    final iDate = DateTime.parse(inputDate);
    final tDate = DateTime.parse(todayDate);
    if (iDate.isBefore(tDate)) {
      return false;
    }
    return true;
  }

  //Validation for start and end date
  static validateStartAndEndDate(DateTime startDate, DateTime endDate) {
    bool isValid = false;
     if (startDate.isAfter(endDate)) {
       isValid =  false;
     }
     else if (startDate.isBefore(endDate)) {
      if ( isValid = compareStartandDateWithToday(startDate)) {
        isValid = true;
      } else {
        return false;
      }
      if ( isValid = compareStartandDateWithToday(endDate)) {
        isValid = true;
      } else {
        return false;
      }
    } else if (startDate.isAtSameMomentAs(endDate)) {
       isValid = true;
    }
     return isValid;
  }

  //Find number of days b/w start and end date
  static int findNumberOfDaysBetweenStartAndEndDate(DateTime startDate, DateTime endDate) {
    if (startDate != null && endDate != null) {
      final difference = endDate.difference(startDate).inDays;
      return difference;
    } else {
      return 0;
    }
  }

  static double convertTimeToDouble(TimeOfDay myTime) {
    return myTime.hour + myTime.minute/60.0;
  }

  static bool validateStartAndEndTime(TimeOfDay startTime, TimeOfDay endTime) {
    bool isValidTime = false;
    if (startTime != null && endTime != null) {
      if (convertTimeToDouble(startTime) == convertTimeToDouble(endTime)) {
        isValidTime  = true;
      } else if (convertTimeToDouble(startTime) > convertTimeToDouble(endTime)) {
        isValidTime  = false;
      } else if (convertTimeToDouble(startTime) < convertTimeToDouble(endTime)) {
        isValidTime  = true;
      }
    }
    return isValidTime;
  }
}
