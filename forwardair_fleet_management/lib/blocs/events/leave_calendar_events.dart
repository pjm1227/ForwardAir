import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';
import 'package:meta/meta.dart';

//This class handle an events for LeaveCalendar Page
@immutable
abstract class LeaveCalendarEvents extends Equatable {
  LeaveCalendarEvents([List props = const []]) : super(props);
}

class DisplayInitiallyEvent extends LeaveCalendarEvents {}

//This event called when Settlement data
class GetLeaveCalendarDataEvent extends LeaveCalendarEvents {
  final List<UnavailabilityDataModelDetail> upcomingOrPastLeaves;
  GetLeaveCalendarDataEvent({@required this.upcomingOrPastLeaves}) : super([]);
}

//This event to display the List of Leave items for  the selected date.
class TappedonDateEvent extends LeaveCalendarEvents {
  final List events;
  TappedonDateEvent({@required this.events}) : super([]);
}