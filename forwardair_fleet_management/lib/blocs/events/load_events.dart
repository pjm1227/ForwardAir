import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoadEvents extends Equatable {
  LoadEvents([List list = const []]) : super(list);
}

class LoadingEvent extends LoadEvents {}

//This event called when fetch tractor data
class GetTractorDataEvent extends LoadEvents {
  final String weekStart, weekEnd;
  final int month, year;
  final PageName pageName;

  GetTractorDataEvent(
      {@required this.pageName,
      @required this.weekStart,
      @required this.weekEnd,
      @required this.month,
      @required this.year})
      : super([]);
}

class GetChartDataEvent extends LoadEvents {}

class SortHighToLowEvent extends LoadEvents {
  final TractorData tractorData;
  final PageName pageName;

  SortHighToLowEvent({@required this.tractorData, @required this.pageName})
      : super([tractorData, pageName]);
}

class SortLowToHighEvent extends LoadEvents {
  final TractorData tractorData;
  final PageName pageName;

  SortLowToHighEvent({@required this.tractorData, @required this.pageName})
      : super([tractorData, pageName]);
}

class SortAscendingTractorIDEvent extends LoadEvents {
  final TractorData tractorData;
  final PageName pageName;

  SortAscendingTractorIDEvent(
      {@required this.tractorData, @required this.pageName})
      : super([tractorData, pageName]);
}

class SortDescendingTractorIDEvent extends LoadEvents {
  final TractorData tractorData;
  final PageName pageName;

  SortDescendingTractorIDEvent(
      {@required this.tractorData, @required this.pageName})
      : super([tractorData, pageName]);
}
