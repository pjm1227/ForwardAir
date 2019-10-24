import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/fleetTracker/fleet_tracker_model.dart';
import 'package:meta/meta.dart';

abstract class FleetTrackerState extends Equatable {
  FleetTrackerState([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends FleetTrackerState {}

//It will handle Error state for fleet tracker page
class FleetErrorState extends FleetTrackerState {
  final String errorMessage;

  FleetErrorState({@required this.errorMessage}) : super([errorMessage]);
}

//It will handle success state for Fleet tracker page
class FleetSuccessState extends FleetTrackerState {
  final List<CurrentPositions> fleetData;

  FleetSuccessState({this.fleetData}) : super([fleetData]);
}
