import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> dataMap;

  final List<Color> colorList;

  const PieChartWidget(
      {Key key, @required this.dataMap, @required this.colorList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var map = Map<String, double>();
    map["a"] = 100.0;
    return PieChart(
      dataMap: dataMap.length > 0 ? dataMap : map,
      chartValuesColor: Colors.transparent,
      animationDuration: Duration(milliseconds: 600),
      chartLegendSpacing: 0.0,
      chartRadius: 180,
      showChartValuesInPercentage: false,
      showChartValues: false,
      showChartValuesOutside: false,
      colorList: colorList,
      showLegends: false,
      decimalPlaces: 0,
    );
  }
}
