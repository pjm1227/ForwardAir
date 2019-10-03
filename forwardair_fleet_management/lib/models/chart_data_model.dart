import 'package:meta/meta.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartDataModel {
  final double value;
  final int loadsValue;
  final String name;
  final charts.Color color;

  ChartDataModel({this.value, @required this.name, this.color, this.loadsValue});
}
