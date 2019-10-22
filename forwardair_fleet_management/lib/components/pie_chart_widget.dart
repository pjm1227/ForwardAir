/// Simple pie chart with outside labels example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PieChartWidget(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isAllNull()
          ? Container()
          : new charts.PieChart(
              seriesList,
              animate: animate,
              defaultRenderer: new charts.ArcRendererConfig(
                  arcRendererDecorators: [
                    new charts.ArcLabelDecorator(
                        labelPosition: charts.ArcLabelPosition.outside)
                  ]),
            ),
    );
  }

  bool isAllNull() {
    var isShowPieChart = false;
    if (seriesList.length > 0) {
      seriesList[0].data.forEach((item) {
        if ((item.loadsValue == null) && (item.value == null)) {
          isShowPieChart = true;
        }
      });
    }

    return isShowPieChart;
  }
}
