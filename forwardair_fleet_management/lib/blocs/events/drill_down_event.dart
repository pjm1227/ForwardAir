import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:forwardair_fleet_management/models/drillDown/drill_down_model.dart';

abstract class DrillDownEvents extends Equatable {
  DrillDownEvents([List props = const []]) : super(props);
}

class FetchDrillDownEvent extends DrillDownEvents {
  final String weekStart, weekEnd,year,args;
  final int month;


  FetchDrillDownEvent({@required this.weekStart, @required this.weekEnd,@required this.month,@required this.year,@required this.args})
      : super([]);

}

class FilterEvent extends DrillDownEvents {
  DrillDownModel drillData;
  String filterOption;
  String arg;
  FilterEvent({@required this.filterOption,@required this.drillData,@required this.arg}) : super([]);
}


class PullToRefreshDrillDownEvent extends DrillDownEvents {

}

class PeriodEvent extends DrillDownEvents {
  final bool weekText;

  PeriodEvent({@required this.weekText}) : super([weekText]);
}