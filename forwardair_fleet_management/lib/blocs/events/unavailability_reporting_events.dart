import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//This class handle an events for Unavailability Reporting Page
@immutable
abstract class UnavailabilityReportingEvents extends Equatable {
  UnavailabilityReportingEvents([List props = const []]) : super(props);
}

class DisplayInitiallyEvent extends UnavailabilityReportingEvents {}

//Picked Date Event
class PickedDateEvent extends UnavailabilityReportingEvents {
  final DateTime pickedDate;

  PickedDateEvent({this.pickedDate})
      : super([pickedDate]);
}