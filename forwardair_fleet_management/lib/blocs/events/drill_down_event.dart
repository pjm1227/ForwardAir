import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:forwardair_fleet_management/models/drillDown/drill_down_model.dart';

abstract class DrillDownEvents extends Equatable {
  DrillDownEvents([List props = const []]) : super(props);
}

class FetchDrillDownEvent extends DrillDownEvents {
  final String weekStart, weekEnd,year;
  bool isMilePage;
  final int month;


  FetchDrillDownEvent({@required this.weekStart, @required this.weekEnd,@required this.month,@required this.year,@required this.isMilePage})
      : super([]);

}

class FilterEvent extends DrillDownEvents {
  DrillDownModel drillData;
  String filterOption;
  bool isMilePage;
  FilterEvent({@required this.filterOption,@required this.drillData,@required this.isMilePage}) : super([]);
}




class PullToRefreshDrillDownEvent extends DrillDownEvents {

}

class PeriodEvent extends DrillDownEvents {
  final bool weekText;

  PeriodEvent({@required this.weekText}) : super([weekText]);
}