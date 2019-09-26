import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/apirepo/repository.dart';
import 'package:forwardair_fleet_management/blocs/states/load_details_states.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';
import 'package:forwardair_fleet_management/models/loadDetails/load_detail_model.dart';
import 'package:forwardair_fleet_management/models/webservice/load_request.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';

import 'events/load_detail_events.dart';

class LoadDetailBloc extends Bloc<LoadDetailEvents, LoadDetailState> {
  @override
  // TODO: implement initialState
  get initialState => InitialState();

  //Fetched Array From DB
  Stream<LoadDetailState> FetchLoadDetails(String weekStart, String weekEnd,
      int month, String year, String tractorId) async* {
    var userManager = UserManager();
    var userModel = await userManager.getData();

    var request = LoadRequest(
        weekStart: weekStart,
        weekEnd: weekEnd,
        month: month,
        year: int.parse(year),
        tractorId: tractorId);
    var body = request.toJson();
    print(body.toString());
    final _repository = Repository();
    var result = await _repository.makeLoadDetailRequest(
        body.toString(), userModel.token != null ? userModel.token : '');
    print('Result is $result');
    //Check if result is an instance of LoadDetailModel or ErrorModel
    //If it's LoginModel then insert data into DB else show error message
    if (result is ErrorModel) {
      yield LoadDataError(errorMessage: result.errorMessage);
    } else {
      try {
        LoadDetailModel loadDetails = loadDetailModelFromJson(result);
        yield LoadDataLoaded(loadDetails: loadDetails);
      } catch (_) {
        yield LoadDataError(errorMessage: Constants.SOMETHING_WRONG);
        print("db Exception");
      }
    }
  }

  @override
  Stream<LoadDetailState> mapEventToState(LoadDetailEvents event) async* {
    if (event is FetchLoadDetailsEvent) {
      yield* FetchLoadDetails(event.weekStart, event.weekEnd, event.month,
          event.year, event.tractorId);
    }
  }
}
