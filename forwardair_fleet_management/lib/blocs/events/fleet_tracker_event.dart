import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FleetTrackerEvents extends Equatable {
  FleetTrackerEvents([List props = const []]) : super(props);
}
//This event called when fetch fleet tracker data
class FetchFleetDataEvent extends FleetTrackerEvents {

}
