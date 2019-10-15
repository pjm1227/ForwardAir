import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/apirepo/repository.dart';
import 'package:forwardair_fleet_management/blocs/states/fleet_tracker_states.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';
import 'package:forwardair_fleet_management/models/fleetTracker/fleet_tracker_model.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

import 'events/fleet_tracker_event.dart';

class FleetTrackerBloc extends Bloc<FleetTrackerEvents, FleetTrackerState> {
  @override
  get initialState => InitialState();

  //This method is check internet first, If we have internet connection
  // then call an API else Check if data exists in DB, If we have data in db then
  // Show it from DB else show some error
  Stream<FleetTrackerState> fetchLoadDetails(
      FetchFleetDataEvent event) async* {
    //Check for internet connection first
    var isConnection = await Utils.isConnectionAvailable();
    if (isConnection) {
      //Internet Connection available, So Make API call
      //Fetch user tokens from User table
      var userManager = UserManager();
      var userModel = await userManager.getData();
      if (userModel.token != null) {
        var repository = Repository();
        //Create a request Model

        var result = await repository.makeFleetDataRequest(userModel.token);
        //Check if result is an instance of CompensationModel or ErrorModel
        //If it's CompensationModel then insert data into DB else show error message
        if (result is ErrorModel) {
          yield DetailsErrorState(errorMessage: result.errorMessage);
        } else {
          try {
            FleetTrackerModel fleetModel = fleetFromJson(result);
            yield SuccessState(fleetModel: fleetModel);
          } catch (_) {
            yield DetailsErrorState(errorMessage: Constants.SOMETHING_WRONG);
            print("db Exception");
          }
        }
      } else {
        yield DetailsErrorState(errorMessage: Constants.SOMETHING_WRONG);
      }
    } else {
      yield DetailsErrorState(errorMessage: Constants.NO_INTERNET_FOUND);
    }
  }

  @override
  Stream<FleetTrackerState> mapEventToState(FleetTrackerEvents event) async* {
    if (event is FleetTrackerEvents) {
      yield* fetchLoadDetails(event);
    }
  }
}
