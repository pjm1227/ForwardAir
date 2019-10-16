import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/fleetTracker/fleet_tracker_model.dart';
import 'package:meta/meta.dart';

abstract class FleetTrackerState extends Equatable {
  FleetTrackerState([List props = const []]) : super(props);
}
//It will handle Initial state
class InitialState extends FleetTrackerState {}

//It will handle Error state for Compensation page
class DetailsErrorState extends FleetTrackerState {
  final String errorMessage;
  DetailsErrorState({@required this.errorMessage}) : super([errorMessage]);
}

//It will handle Loaded state for Compensation page
class SuccessState extends FleetTrackerState {
  final FleetTrackerModel fleetModel;

  SuccessState({this.fleetModel}) : super([fleetModel]);
}