/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StackedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedBarChart(this.seriesList, {this.animate});

  /// Creates a stacked [BarChart] with sample data and no transition.
  factory StackedBarChart.withSampleData() {
    return new StackedBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      _createSampleData(),
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
            labelStyle: new charts.TextStyleSpec(
                 color: charts.MaterialPalette.white),
          )),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.NoneRenderSpec(), showAxisLine: false),
    );
  }

  /// Create series list with multiple series

  static List<charts.Series<Contribution, String>> _createSampleData() {
    final loadedData = [
      new Contribution('Su', 25),
      new Contribution('Mo', 34),
      new Contribution('tu', 26),
      new Contribution('we', 14),
      new Contribution('th', 32),
      new Contribution('fr', 28),
      new Contribution('sa', 38),
    ];

    final emptyData = [
      new Contribution('su', 25),
      new Contribution('mo', 16),
      new Contribution('tu', 24),
      new Contribution('we', 24),
      new Contribution('th', 16),
      new Contribution('fr', 14),
      new Contribution('sa', 10),
    ];

    return [
      new charts.Series<Contribution, String>(
        id: 'Loaded',
        domainFn: (Contribution sales, _) => sales.time,
        measureFn: (Contribution sales, _) => sales.data,
        //labelAccessorFn: (_, __) => '1',
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        data: loadedData,
      ),
      new charts.Series<Contribution, String>(
        id: 'Empty',
        domainFn: (Contribution sales, _) => sales.time,
        measureFn: (Contribution sales, _) => sales.data,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        data: emptyData,
      ),
    ];
  }
}

/// Sample ordinal data type.
class Contribution {
  final String time;
  final int data;

  Contribution(this.time, this.data);
}
