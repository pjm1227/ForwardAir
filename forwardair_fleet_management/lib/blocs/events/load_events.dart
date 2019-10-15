import 'dart:ui';

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

//This event is called when we called chart API to fetch chart data
class GetChartDataEvent extends LoadEvents {}

//This event is called when user choose sort high to low
class SortHighToLowEvent extends LoadEvents {
  final List<Map<Tractor, Color>> tractorData;
  final PageName pageName;

  SortHighToLowEvent({@required this.tractorData, @required this.pageName})
      : super([tractorData, pageName]);
}
//This event is called when user choose sort low to high
class SortLowToHighEvent extends LoadEvents {
  final List<Map<Tractor, Color>> tractorData;
  final PageName pageName;

  SortLowToHighEvent({@required this.tractorData, @required this.pageName})
      : super([tractorData, pageName]);
}
//This event is called when user choose sort ascending using tractor ID
class SortAscendingTractorIDEvent extends LoadEvents {
  final List<Map<Tractor, Color>> tractorData;
  final PageName pageName;

  SortAscendingTractorIDEvent(
      {@required this.tractorData, @required this.pageName})
      : super([tractorData, pageName]);
}

//This event is called when user choose sort descending using tractor ID
class SortDescendingTractorIDEvent extends LoadEvents {
  final List<Map<Tractor, Color>> tractorData;
  final PageName pageName;

  SortDescendingTractorIDEvent(
      {@required this.tractorData, @required this.pageName})
      : super([tractorData, pageName]);
}

//This event is called when user click on Fuel Gallons

class FuelGallonsEvent extends LoadEvents {
  final bool isGallonClicked, isTotalAmountClicked;
  FuelGallonsEvent(
      {@required this.isGallonClicked, @required this.isTotalAmountClicked})
      : super([]);
}
