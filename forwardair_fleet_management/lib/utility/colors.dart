import 'dart:ui';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

/*This class is used to define the color codes
* And can be use anywhere in application*/
class AppColors {
  static const colorRed = Color.fromRGBO(207, 29, 43, 1);
  static const colorWhite = Colors.white;

  //Drawer Menu
  static const redColorWithTenOpacity = Color.fromRGBO(207, 29, 43, 0.1);
  static const redColorWithTwentyOpacity = Color.fromRGBO(207, 29, 43, 0.2);
  static const colorAppBar = Color.fromRGBO(15, 43, 52, 1);
  static const colorGrey = Color.fromRGBO(118, 119, 120, 1);
  static const colorLightGrey = Color(0xFFf9f9f9);
  static const colorBlack = Color.fromRGBO(0, 0, 0, 1);

  //Dashboard
  static const colorGreyInBottomSheet = Color.fromRGBO(191, 191, 191, 1);
  static const colorDashboard_Bg = Color.fromRGBO(246, 246, 246, 1);
  static const colorBlue = Color.fromRGBO(45, 135, 151, 1);
  static const darkColorBlue = Color.fromRGBO(23, 87, 99, 1);
  static const colorListItem = Color.fromRGBO(45, 135, 151, 1);
  static const colorDOT = Color.fromRGBO(140, 234, 255, 1);
  static const colorTotalGallons = Color.fromRGBO(118, 119, 120, 1);
  static const lightBlack = Color.fromRGBO(0, 0, 0, 0.87);

  //color list which is used in pie chart
  static const List<charts.Color> colorListPieChart = [
    charts.Color(r: 227, g: 26, b: 28),
    charts.Color(r: 51, g: 120, b: 180),
    charts.Color(r: 251, g: 154, b: 153),
    charts.Color(r: 128, g: 0, b: 128),
    charts.Color(r: 166, g: 206, b: 227),
    charts.Color(r: 178, g: 223, b: 138),
    charts.Color(r: 45, g: 135, b: 151),
    charts.Color(r: 253, g: 191, b: 111),
    charts.Color(r: 140, g: 234, b: 255),
    charts.Color(r: 255, g: 127, b: 0),
    charts.Color(r: 255, g: 255, b: 255),
  ];

  //color list which is used for dots color
  static const List<Color> colorListForDots = [
    Color.fromRGBO(227, 26, 28, 1),
    Color.fromRGBO(31, 120, 180, 1),
    Color.fromRGBO(251, 154, 153, 1),
    Color.fromRGBO(128, 0, 128, 1),
    Color.fromRGBO(166, 206, 227, 1),
    Color.fromRGBO(178, 223, 138, 1),
    Color.fromRGBO(45, 135, 151, 1),
    Color.fromRGBO(253, 191, 111, 1),
    Color.fromRGBO(140, 234, 255, 1),
    Color.fromRGBO(255, 127, 0, 1),
  ];
}
