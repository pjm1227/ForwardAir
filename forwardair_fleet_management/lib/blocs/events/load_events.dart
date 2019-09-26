import 'package:equatable/equatable.dart';
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
  final bool isMiles;

  GetTractorDataEvent(
      {@required this.isMiles,
      @required this.weekStart,
      @required this.weekEnd,
      @required this.month,
      @required this.year})
      : super([]);
}

class GetChartDataEvent extends LoadEvents {}
