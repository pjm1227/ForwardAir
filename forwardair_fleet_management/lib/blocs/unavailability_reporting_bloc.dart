import 'package:bloc/bloc.dart';

import 'package:forwardair_fleet_management/blocs/barrels/unavailability_reporting.dart';

class UnavailabilityReportingBloc
    extends Bloc<UnavailabilityReportingEvents, UnavailabilityReportingStates> {
  //It will call to map initial State
  @override
  UnavailabilityReportingStates get initialState => InitialState();

  //Here will map state according to event
  @override
  Stream<UnavailabilityReportingStates> mapEventToState(
    UnavailabilityReportingEvents event,
  ) async* {
    if (event is DisplayInitiallyEvent) {
      yield InitialState();
    } else if (event is PickedStartDateEvent) {
      yield PickedStartDateState(pickedDate: event.pickedDate);
    } else if (event is PickedEndDateEvent) {
      yield PickedEndDateState(pickedDate: event.pickedDate);
    } else if (event is PickedStartTimeEvent) {
      yield PickedStartTimeState(pickedTime: event.pickedTime);
    } else if (event is PickedEndTimeEvent) {
      yield PickedEndTimeState(pickedTime: event.pickedTime);
    } else if (event is TappedOnSubmitButtonEvent) {
      yield InitialState();
      yield TappedOnSubmitButtonState(
          startDate: event.startDate,
          endDate: event.endDate,
          startTime: event.startTime,
          endTime: event.endTime,
          startLocation: event.startLocation,
          reason: event.reason,
          numberOfDays: event.numberOfDays);
      //TODO: Calling API to submit leave.
    }
  }
}
