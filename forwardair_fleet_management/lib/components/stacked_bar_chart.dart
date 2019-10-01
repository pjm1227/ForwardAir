/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/blocs/barrels/chart.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
/*class StackedBarChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedBarChart({this.seriesList, this.animate});

  @override
  State<StatefulWidget> createState() {
    return StackBarState(seriesList, animate);
  }
}*/

class StackedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  int total = 0;
  final chartBloc = ChartBloc();

  StackedBarChart({this.seriesList, this.animate});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChartBloc, ChartStates>(
        listener: (context, state) {
          if (state is SelectState) {
            total = state.total;
          }
        },
        bloc: chartBloc,
        child: BlocBuilder<ChartBloc, ChartStates>(
          bloc: chartBloc,
          builder: (context, state) {
            return _chartWidget();
          },
        ));
  }

  Widget _chartWidget() {
    return Column(
      children: <Widget>[
        TextWidget(
          text: total == 0 ? '' : 'Total : $total',
          colorText: AppColors.colorWhite,
        ),
        Expanded(
          child: charts.BarChart(
            seriesList,
            animate: animate,
            barGroupingType: charts.BarGroupingType.stacked,
            domainAxis: new charts.OrdinalAxisSpec(
                renderSpec: new charts.SmallTickRendererSpec(
                    minimumPaddingBetweenLabelsPx: 0,
                    labelStyle: new charts.TextStyleSpec(
                        lineHeight: 2,
                        fontSize: 10,
                        color: charts.MaterialPalette.white),
                    lineStyle: charts.LineStyleSpec(
                        color: charts.MaterialPalette.white, thickness: 1))),
            primaryMeasureAxis: charts.NumericAxisSpec(
                showAxisLine: false,
                renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                        fontSize: 10, color: charts.MaterialPalette.white),
                    lineStyle: charts.LineStyleSpec(
                        thickness: 0,
                        color: charts.MaterialPalette.gray.shadeDefault))),
            /*behaviors: [
              new charts.ChartTitle('$total',
                  titleStyleSpec: charts.TextStyleSpec(
                      color: charts.Color(
                        r: 255,
                        g: 255,
                        b: 255,
                      ),
                      fontSize: 14),
                  // subTitle: 'Top sub-title text',
                  behaviorPosition: charts.BehaviorPosition.top,
                  titleOutsideJustification: charts.OutsideJustification.start,
                  // Set a larger inner padding than the default (10) to avoid
                  // rendering the text too close to the top measure axis tick label.
                  // The top tick label may extend upwards into the top margin region
                  // if it is located at the top of the draw area.
                  innerPadding: 18),
            ],*/
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                updatedListener: _onSelectionChanged,
              )
            ],
          ),
        )
      ],
    );
  }

  _onSelectionChanged(charts.SelectionModel<dynamic> model) {
    final selectedDatum = model.selectedDatum;

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      total = 0;
      selectedDatum.forEach((item) {
        total = total + item.datum.value;
      });
      chartBloc.dispatch(SelectEvent(total: total));
      print("SelectedDatum lenght is $total");
    }
  }
}
