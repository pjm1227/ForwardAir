import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';
import 'package:meta/meta.dart';

//This class is responsible to handle the states for Leave Calendar page
@immutable
abstract class LeaveCalendarStates extends Equatable {
  LeaveCalendarStates([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends LeaveCalendarStates {}

//This state is return errors
class ErrorState extends LeaveCalendarStates {
  final String errorMessage;

  ErrorState({@required this.errorMessage});
}

//This event called when Leave calendar data
class GetLeaveCalendarSate extends LeaveCalendarStates {
  final  Map<DateTime, List<UnavailabilityDataModelDetail>>  events;
  GetLeaveCalendarSate({@required this.events}) : super([]);
}

//This state to display the List of Leave items for  the selected date.
class TappedonDateState extends LeaveCalendarStates {
  final List events;
  TappedonDateState({@required this.events}) : super([]);
}