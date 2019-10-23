import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

//This class is responsible to handle the states for Unavailability Reporting page
@immutable
abstract class UnavailabilityReportingStates extends Equatable {
  UnavailabilityReportingStates([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends UnavailabilityReportingStates {}

//To update Picked Start Date UI
class PickedStartDateState extends UnavailabilityReportingStates {
  final DateTime pickedDate;

  PickedStartDateState({this.pickedDate})
      : super([pickedDate]);
}

//To update Picked End Date UI
class PickedEndDateState extends UnavailabilityReportingStates {
  final DateTime pickedDate;

  PickedEndDateState({this.pickedDate})
      : super([pickedDate]);
}

//To update Picked Start Time UI
class PickedStartTimeState extends UnavailabilityReportingStates {
  final TimeOfDay pickedTime;

  PickedStartTimeState({this.pickedTime})
      : super([pickedTime]);
}

//To update Picked End Time UI
class PickedEndTimeState extends UnavailabilityReportingStates {
  final TimeOfDay pickedTime;

  PickedEndTimeState({this.pickedTime})
      : super([pickedTime]);
}
