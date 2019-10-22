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
    }
  }
}
