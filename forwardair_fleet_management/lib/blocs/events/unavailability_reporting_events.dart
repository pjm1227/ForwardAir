import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

//This class handle an events for Unavailability Reporting Page
@immutable
abstract class UnavailabilityReportingEvents extends Equatable {
  UnavailabilityReportingEvents([List props = const []]) : super(props);
}

class DisplayInitiallyEvent extends UnavailabilityReportingEvents {}

//Picked Date Event
class PickedStartDateEvent extends UnavailabilityReportingEvents {
  final DateTime pickedDate;

  PickedStartDateEvent({this.pickedDate})
      : super([pickedDate]);
}

//Picked Date Event
class PickedEndDateEvent extends UnavailabilityReportingEvents {
  final DateTime pickedDate;

  PickedEndDateEvent({this.pickedDate})
      : super([pickedDate]);
}

//Picked Date Event
class PickedStartTimeEvent extends UnavailabilityReportingEvents {
  final TimeOfDay pickedTime;

  PickedStartTimeEvent({this.pickedTime})
      : super([pickedTime]);
}

//Picked Date Event
class PickedEndTimeEvent extends UnavailabilityReportingEvents {
  final TimeOfDay pickedTime;

  PickedEndTimeEvent({this.pickedTime})
      : super([pickedTime]);
}
