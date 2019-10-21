import 'package:bloc/bloc.dart';

import 'package:forwardair_fleet_management/blocs/barrels/leave_calendar.dart';
import 'package:forwardair_fleet_management/blocs/events/leave_calendar_events.dart';
import 'package:forwardair_fleet_management/blocs/states/leave_calendar_states.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';

class LeaveCalendarBloc extends Bloc<LeaveCalendarEvents, LeaveCalendarStates> {
  //It will call to map initial State
  @override
  LeaveCalendarStates get initialState => InitialState();

  //Here will map state according to event
  @override
  Stream<LeaveCalendarStates> mapEventToState(
    LeaveCalendarEvents event,
  ) async* {
    //To assign data to the Calendar
    if (event is GetLeaveCalendarDataEvent) {
      //Add events to the calendar.
      yield* _assignDataToCalendarEvent(event);
    } //To fetch events for selected date in the Calendar
    else if (event is TappedonDateEvent) {
      yield InitialState();
      yield TappedonDateState(events: event.events);
    } else if (event is TappedonLeaveListItemEvent){
      yield InitialState();
      yield TappedonLeaveListItemState(dataModelDetail: event.dataModelDetail);
    }
  }

  //To Assign date and Events to the Calendar
 Stream<LeaveCalendarStates> _assignDataToCalendarEvent(LeaveCalendarEvents event) async* {
    if (event is GetLeaveCalendarDataEvent) {
      Map<DateTime, List<UnavailabilityDataModelDetail>> _events = Map<DateTime, List<UnavailabilityDataModelDetail>>();
      var _selectedDay = DateTime.now();
      if (event.upcomingOrPastLeaves.length > 0) {
        for (var event in event.upcomingOrPastLeaves) {
          final date = DateTime.parse(event.leaveStartDate);
          _selectedDay = date;
          if (_events.containsKey(_selectedDay)) {
            //Fetch Existing Items for the contains date in map
            var existingitems = _events[_selectedDay];
            existingitems.add(event);
            //Add all Events into map for the selected day
            _events[_selectedDay] = existingitems;
          } else {
            //Add Events into map for the selected day
            _events[_selectedDay] = [event];
          }
        }
        //To add dates to the calendar.
        yield GetLeaveCalendarSate(events: _events);
      } else {
        //If not events found.
        yield GetLeaveCalendarSate(events: _events);
      }
    }
  }
}
