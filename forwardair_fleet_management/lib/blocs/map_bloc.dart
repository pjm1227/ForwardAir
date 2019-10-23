import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/blocs/states/map_state.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:geocoder/geocoder.dart';
import 'events/map_event.dart';

class MapBloc extends Bloc<MapEvents, MapState> {
  @override
  get initialState => InitialState();

  //This method is check internet first, If we have internet connection
  // then it will get the address from geoCoder else gives Error state
  Stream<MapState> fetchAddress(FetchLocationEvent event) async* {
    //Check for internet connection first
    var isConnection = await Utils.isConnectionAvailable();
    if (isConnection) {
      //Internet Connection available, So request for address through geoCoder

      try {
        final coordinates = new Coordinates(double.parse(event.latitude),
            double.parse(
                event.longitude)); //coordinated required to fetch streetAddress
        var addresses = await Geocoder.local.findAddressesFromCoordinates(
            coordinates); //this address holds list of Addresses based on coordinates
        var first = addresses.first; //this will hold the first index from list of addresses
        String streetAddress = " ${first.addressLine}"; //this streetAddress holds the addressLine
        yield LocationSuccessState(address: streetAddress);
      } catch (_) {
        yield LocationErrorState(errorMessage: Constants.SOMETHING_WRONG);
        print("db Exception");
      }
    } else {
      yield LocationErrorState(errorMessage: Constants.SOMETHING_WRONG);
    }
  }

  @override
  Stream<MapState> mapEventToState(MapEvents event) async* {
    if (event is MapEvents) {
      yield* fetchAddress(event);
    }
  }
}


