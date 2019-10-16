import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FleetTrackerEvents extends Equatable {
  FleetTrackerEvents([List props = const []]) : super(props);
}

//This event called when fetch compensation data
class FetchFleetDataEvent extends FleetTrackerEvents {

}
