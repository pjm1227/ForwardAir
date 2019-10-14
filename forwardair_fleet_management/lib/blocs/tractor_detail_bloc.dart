import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/apirepo/repository.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';
import 'package:forwardair_fleet_management/models/loadDetails/load_detail_model.dart';
import 'package:forwardair_fleet_management/models/webservice/load_request.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'barrels/load_details.dart';

import 'events/load_detail_events.dart';

class TractorDetailBloc extends Bloc<LoadDetailEvents, LoadDetailState> {
  @override
  get initialState => InitialState();

  //This method is check internet first, If we have internet connection
  // then call an API else Check if data exists in DB, If we have data in db then
  // Show it from DB else show some error
  Stream<LoadDetailState> fetchLoadDetails(FetchTractorDataEvent event) async* {
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
        var request = LoadRequest(
            weekStart: event.weekStart,
            weekEnd: event.weekEnd,
            year: event.year,
            tractorId: event.tractorId,
            month: event.month);
        //Convert request model to json
        var body = request.toJson();
        print(body.toString());
        var result = await repository.makeLoadDetailRequest(
            body.toString(), userModel.token);
        //Check if result is an instance of LoadDetailModel or ErrorModel
        //If it's LoadDetailModel then insert data into DB else show error message
        if (result is ErrorModel) {
          yield DetailsErrorState(errorMessage: result.errorMessage);
        } else {
          try {
            LoadDetailModel loadDetails = loadDetailModelFromJson(result);
            yield SuccessState(loadDetailsModel: loadDetails);
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
  Stream<LoadDetailState> mapEventToState(LoadDetailEvents event) async* {
    if (event is FetchTractorDataEvent) {
      yield* fetchLoadDetails(event);
    }
  }
}
