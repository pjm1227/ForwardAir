import 'package:meta/meta.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartDataModel {
  final double value;
  final String name;
  final charts.Color color;

  ChartDataModel({@required this.value, @required this.name, this.color});
}
