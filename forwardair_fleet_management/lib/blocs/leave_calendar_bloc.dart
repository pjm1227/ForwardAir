import 'package:bloc/bloc.dart';

import 'package:forwardair_fleet_management/blocs/barrels/leave_calendar.dart';
import 'package:forwardair_fleet_management/blocs/events/leave_calendar_events.dart';
import 'package:forwardair_fleet_management/blocs/states/leave_calendar_states.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';
import 'package:intl/intl.dart';

class LeaveCalendarBloc
    extends Bloc<LeaveCalendarEvents,LeaveCalendarStates> {
  //It will call to map initial State
  @override
  LeaveCalendarStates get initialState => InitialState();

  //Here will map state according to event
  @override
  Stream<LeaveCalendarStates> mapEventToState(
      LeaveCalendarEvents event,) async* {
    //To assign data to the Calendar
    if (event is GetLeaveCalendarDataEvent) {
      yield GetLeaveCalendarSate(events: _assignDataToCalendarEvent(event));
    }  //To fetch events for selected date in the Calendar
    else if (event is TappedonDateEvent){
       yield InitialState();
       yield TappedonDateState(events: event.events);
    }
  }

  //To Assign date and Events to the Calendar
  Map<DateTime, List<UnavailabilityDataModelDetail>> _assignDataToCalendarEvent(LeaveCalendarEvents event) {
    Map<DateTime, List<UnavailabilityDataModelDetail>> _events = Map<DateTime, List<UnavailabilityDataModelDetail>>();
    var _selectedDay = DateTime.now();
    if (event is GetLeaveCalendarDataEvent) {
      if (event.upcomingOrPastLeaves.length > 0) {
        for (var event in event.upcomingOrPastLeaves) {
          final date = DateTime.parse(event.leaveStartDate);
          _selectedDay = date;
          if (_events.containsKey(_selectedDay)) {
            for (UnavailabilityDataModelDetail val in _events[_selectedDay]) {
              _events[_selectedDay] = [val,event];
            }
          } else {
            _events[_selectedDay] = [event];
          }
        }
        return _events;
      }
    }

  }
}