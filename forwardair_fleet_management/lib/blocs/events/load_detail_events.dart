import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoadDetailEvents extends Equatable {
  LoadDetailEvents([List props = const []]) : super(props);
}

//This event called when fetch tractor data
class FetchTractorDataEvent extends LoadDetailEvents {
  final String weekStart, weekEnd, tractorId;
  final int month, year;
  final PageName pageName;

  FetchTractorDataEvent(
      {@required this.tractorId,
      @required this.pageName,
      @required this.weekStart,
      @required this.weekEnd,
      @required this.month,
      @required this.year})
      : super([]);
}
