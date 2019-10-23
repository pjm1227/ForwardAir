import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/apirepo/repository.dart';
import 'package:forwardair_fleet_management/blocs/states/fleet_tracker_states.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';
import 'package:forwardair_fleet_management/models/fleetTracker/fleet_tracker_model.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';

import 'events/fleet_tracker_event.dart';

class FleetTrackerBloc extends Bloc<FleetTrackerEvents, FleetTrackerState> {
  @override
  get initialState => InitialState();

  //This method is check internet first, If we have internet connection
  // then call an API else Check if data exists in DB, If we have data in db then
  // Show it from DB else show some error
  Stream<FleetTrackerState> fetchFleetTrackerDetails(
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
        var result =
            await repository.makeFleetTrackerDataRequest(userModel.token);
        //Check if result is an instance of FleetTrackerModel or ErrorModel
        //If it's FleetTrackerModel then insert data into DB else show error message
        if (result is ErrorModel) {
          yield FleetErrorState(errorMessage: result.errorMessage);
        } else {
          try {
            FleetTrackerModel fleetModel = fleetFromJson(result);
            yield FleetSuccessState(fleetModel: fleetModel);
          } catch (_) {
            yield FleetErrorState(errorMessage: Constants.SOMETHING_WRONG);
            print("db Exception");
          }
        }
      } else {
        yield FleetErrorState(errorMessage: Constants.SOMETHING_WRONG);
      }
    } else {
      yield FleetErrorState(errorMessage: Constants.NO_INTERNET_FOUND);
    }
  }

  @override
  Stream<FleetTrackerState> mapEventToState(FleetTrackerEvents event) async* {
    if (event is FleetTrackerEvents) {
      yield* fetchFleetTrackerDetails(event);
    }
  }

  Future<String> getLocationAddress(CurrentPositions fleetData) async{
    final coordinates = new Coordinates(double.parse(fleetData.latitude), double.parse(fleetData.longitude)); //coordinated required to fetch streetAddress
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates); //this address holds list of Addresses based on coordinates
    var first = addresses.first;//this will hold the first index from list of addresses
    String streetAddress=" ${first.addressLine}"; //this streetAddress holds the addressLine
    return streetAddress;
  }

  bool compareDate(String startDate,String endDate){

    final beginDate1 = DateTime.parse(startDate);
    final endDate1 = DateTime.parse(endDate);
    final formatter = new DateFormat('yyyyMMdd');
    final inDate = formatter.format(beginDate1);
    final outDate = formatter.format(endDate1);
    final todayDate = formatter.format(DateTime.now());
    final iDate = DateTime.parse(inDate);
    final oDate = DateTime.parse(outDate);
    final tDate = DateTime.parse(todayDate);
    if ((tDate.isAfter(iDate) || tDate.isAtSameMomentAs(iDate)) && (tDate.isBefore(oDate) || tDate.isAtSameMomentAs(oDate))) {
      return false;
    }
    return true;
//    var temp = DateTime.now().toUtc();
//    var d1 = DateTime.utc(temp.year,temp.month,temp.day); //this is todayDate
//
//      var d2 = DateTime.utc(int.parse(startDate.substring(0, 4)),
//          int.parse(startDate.substring(4, 6)), int.parse(
//              startDate.substring(6, 8))); //this is startDate
//    var d3 = DateTime.utc(int.parse(endDate.substring(0, 4)),
//        int.parse(endDate.substring(4, 6)), int.parse(
//            endDate.substring(6, 8)));//this is EndDate
//      if ((d2.compareTo(d1)< 0 ||d2.compareTo(d1)==0) && (d3.compareTo(d1)>0 ||d3.compareTo(d1)==0)) {
//        return false;
//      } else {
//        return true;
//      }

  }
}
