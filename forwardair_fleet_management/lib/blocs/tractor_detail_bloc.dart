import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/apirepo/repository.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/Tractor_settlement_model.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';
import 'package:forwardair_fleet_management/models/loadDetails/load_detail_model.dart';
import 'package:forwardair_fleet_management/models/tractor_fuel_details_model.dart';
import 'package:forwardair_fleet_management/models/webservice/load_request.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'barrels/load_details.dart';

import 'events/load_detail_events.dart';

class TractorDetailBloc extends Bloc<LoadDetailEvents, TractorDetailsState> {
  @override
  get initialState => InitialState();

  //This method is check internet first, If we have internet connection
  // then call an API else Check if data exists in DB, If we have data in db then
  // Show it from DB else show some error
  Stream<TractorDetailsState> fetchLoadDetails(
      FetchTractorDataEvent event) async* {
    print('Page name in Bloc ${event.pageName}');
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
            month: event.month,
            checkNbr: event.checkNbr);
        //Convert request model to json
        var body = request.toJson();
        print(body.toString());
        //Call API according to page Name
        var result;
        //Calling Same API for Load and miles details , For fuel and settlement we have to call different different API
        if (event.pageName == PageName.LOAD_PAGE ||
            event.pageName == PageName.MILES_PAGE) {
          result = await repository.makeTractorLoadsDetailRequest(
              body.toString(), userModel.token);
        } else if (event.pageName == PageName.FUEL_PAGE) {
          result = await repository.makeTractorFuelDetailsRequest(
              body.toString(), userModel.token);
        } else if (event.pageName == PageName.SETTLEMENTS_PAGE) {
          result = await repository.makeSettlementDetailRequest(
              body.toString(), userModel.token);
        }
        else {
          result = await repository.makeSettlementDetailRequest(
              body.toString(), userModel.token);
        }

        //Check if result is an instance of LoadDetailModel or ErrorModel
        //If it's LoadDetailModel then insert data into DB else show error message
        if (result is ErrorModel) {
          yield DetailsErrorState(errorMessage: result.errorMessage);
        } else {
          try {
            if (event.pageName == PageName.LOAD_PAGE ||
                event.pageName == PageName.MILES_PAGE) {
              TractorDetailsModel loadDetails = loadDetailModelFromJson(result);
              yield LoadMilesSuccessState(tractorDetailsModel: loadDetails);
            } else if (event.pageName == PageName.FUEL_PAGE) {
              TractorFuelDetailsModel fuelDetailsModel =
                  fuelDetailFromJson(result);
              yield FuelSuccessState(fuelDetailsModel: fuelDetailsModel);
            } else if (event.pageName == PageName.SETTLEMENTS_PAGE) {
              TractorSettlementModel settlementModel =
                  settlementFromJson(result);
              yield SettlementSuccessState(
                  settlementDetailsModel: settlementModel);
            } else {
              TractorSettlementModel settlementModel =
                  settlementFromJson(result);
              yield SettlementSuccessState(
                  settlementDetailsModel: settlementModel);
            }
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
  Stream<TractorDetailsState> mapEventToState(LoadDetailEvents event) async* {
    if (event is FetchTractorDataEvent) {
      yield* fetchLoadDetails(event);
    }
  }

  double getDeduction(List<SettlementDetail> data) {
    double deduction = 0.00;
    for (int i = 0; i < data.length; i++) {
      if (data[i].transType == Constants.DEDUCTION_TEXT) {
        deduction = deduction + double.parse(data[i].amt);
      }
    }
    return deduction;
  }

  double getEarning(List<SettlementDetail> data) {
    double earnings = 0.00;
    for (int i = 0; i < data.length; i++) {
      if (data[i].transType == Constants.EARNING_TEXT) {
        earnings = earnings + double.parse(data[i].amt);
      }
    }
    return earnings;
  }
}
