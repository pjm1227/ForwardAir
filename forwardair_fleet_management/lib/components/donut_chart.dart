// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/models/chart_data_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

class DonutPieChart extends StatelessWidget {
  final double grossAmount, deductions;

  DonutPieChart({@required this.grossAmount, @required this.deductions});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(createChartData(),
        animate: true,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 20,
            arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.outside)
            ]));
  }

  List<charts.Series> createChartData() {

    // convert double to string to remove - sign from deductions
    var finalDeduction;
    if(deductions !=null) {
      var deductionString = deductions.toString();
      if (deductionString.contains('-')) {
        deductionString = deductionString.substring(1, deductionString.length);
      }

     finalDeduction = double.parse(deductionString);
    }
    List<charts.Series<ChartDataModel, String>> seriesListPieChart =
        List<charts.Series<ChartDataModel, String>>();
    var chartDataList = List<ChartDataModel>();

    var chartModelGrossAmount = ChartDataModel(
        name: 'gross_amount',
        value: grossAmount == null ? 0.0 : grossAmount,
        color: charts.Color(r: 0, g: 128, b: 129));
    var chartModelDeductions = ChartDataModel(
        name: 'deductions',
        value: finalDeduction == null ? 0.0 : finalDeduction,
        color: AppColors.colorListPieChart[0]);
    chartDataList.add(chartModelGrossAmount);
    chartDataList.add(chartModelDeductions);
    //Create pie chart basic properties here
    var pieChart = charts.Series<ChartDataModel, String>(
      id: 'donut_chart',
      domainFn: (ChartDataModel sales, _) => sales.name,
      measureFn: (ChartDataModel sales, _) => sales.value,
      data: chartDataList,
      // Set a label accessor to control the text of the arc label.
      labelAccessorFn: (ChartDataModel row, _) => '\$${Utils.formatDecimalToWholeNumber(row.value)}',
      colorFn: (ChartDataModel clickData, _) => clickData.color,
      insideLabelStyleAccessorFn: (_, __) =>
          charts.TextStyleSpec(color: charts.Color(r: 255, g: 255, b: 255)),
      outsideLabelStyleAccessorFn: (ChartDataModel sales, _) {
        return new charts.TextStyleSpec(
            color: charts.Color(r: 255, g: 255, b: 255));
      },
    );
    seriesListPieChart.add(pieChart);
    return seriesListPieChart;
  }
}
