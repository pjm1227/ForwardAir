/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StackedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedBarChart({this.seriesList, this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
        minimumPaddingBetweenLabelsPx: 0,
        labelStyle: new charts.TextStyleSpec(
            lineHeight: 2, fontSize: 10, color: charts.MaterialPalette.white),
        /*lineStyle: charts.LineStyleSpec(
                  color: charts.MaterialPalette.white, thickness: 1)*/
      )),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.NoneRenderSpec(), showAxisLine: false),
    );
  }
}
