import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';
import 'package:meta/meta.dart';

//This class is responsible to handle the states for Unavailability Reporting page
@immutable
abstract class UnavailabilityReportingStates extends Equatable {
  UnavailabilityReportingStates([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends UnavailabilityReportingStates {}

//To update Picked Date UI
class PickedDateState extends UnavailabilityReportingStates {
  final DateTime pickedDate;

  PickedDateState({this.pickedDate})
      : super([pickedDate]);
}
