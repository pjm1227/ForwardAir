import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/apirepo/repository.dart';

import 'package:forwardair_fleet_management/blocs/barrels/settlement.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';
import 'package:forwardair_fleet_management/models/settlement_data_model.dart';
import 'package:forwardair_fleet_management/models/webservice/settlement_request.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

class SettlementBloc extends Bloc<SettlementEvents, SettlementStates> {
  //It will call to map initial State
  @override
  SettlementStates get initialState => InitialState();

  @override
  Stream<SettlementStates> mapEventToState(SettlementEvents event) async* {
    if (event is GetSettlementDataEvent) {
      yield ShimmerState();
      yield* _makeApiCall(event);
    } else if (event is PickedDateEvent) {
      yield PickedDateState(pickedDate: event.pickedDate);
    } else if (event is NavigateToDetailPageEvent) {
      yield SuccessState(settlementData: event.settlementModel);
      yield NavigateToDetailPageState(selectedIndex: event.selectedIndex,appBarTitle: event.appBarTitle, settlementModel: event.settlementModel);
    }
  }

  //This method is check internet first, If we have internet connection
  // then call an API else show some error
  Stream<SettlementStates> _makeApiCall(GetSettlementDataEvent event) async* {
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
        var request = SettlementRequest(event.month, event.year);
        //Convert request model to json
        var body = request.toJson();
        print(body.toString());
        var result = await repository.makeSettlementRequest(
            body.toString(), userModel.token);
        //Check if result is an instance of Settlement Model or ErrorModel
        //If it's Settlement Model show data. else show error message
        if (result is ErrorModel) {
          //Show some error
          yield ErrorState(errorMessage: result.errorMessage);
        } else {
          try {
            //Data found
            var settlementModel = settlementModelFromJson(result);
            yield SuccessState(settlementData: settlementModel);
            print('Data Found');
          } catch (_) {
            print("Exception found in settlement API");
            yield ErrorState(errorMessage: Constants.SOMETHING_WRONG );
          }
        }
      } else {
        yield ErrorState(errorMessage: Constants.SOMETHING_WRONG);
      }
    } else {
      //No internet connection.
      yield ErrorState(errorMessage: Constants.NO_INTERNET_FOUND);
    }
  }

  String startAndEndDateCheckDate(SettlementCheck _settlementCheck) {
    var combinedText = '';
    String startDate = Utils.formatStringDateToDateAndMonth(
        _settlementCheck.checkDt != null ? _settlementCheck.checkDt : '');
    if (startDate != '') {
      startDate = startDate;
    } else {
      startDate = 'NA';
    }
    String endDate = Utils.formatStringDateToDateAndMonth(
        _settlementCheck.payPeriodEndDt != null
            ? _settlementCheck.payPeriodEndDt
            : '');
    if (endDate != '') {
      endDate = endDate;
    } else {
      endDate = 'NA';
    }
    combinedText = '$startDate - $endDate';
    return combinedText;
  }

  String getCheckAmount(SettlementCheck _settlementCheck) {
    var commaAddedText = Utils().formatDecimalsNumber(
        _settlementCheck.checkAmt != null ? _settlementCheck.checkAmt : '');
    if (commaAddedText != '') {
      return '\$' + commaAddedText;
    } else {
      return 'NA';
    }
  }

  List<SettlementCheck> applyPickerDateToSettlementList(DateTime pickedDate, SettlementModel _settlementModel) {
    List<SettlementCheck> filteredSettlementChecks = [];
    String pickedDateText = Utils.pickerDateToFormat(pickedDate);
    for (var aSettlementCheck in _settlementModel.settlementChecks) {
      String pickedMonthText = Utils.pickOnlyMonthInCheckList(aSettlementCheck.checkDt);
      if (pickedMonthText == pickedDateText) {
        filteredSettlementChecks.add(aSettlementCheck);
      }
    }
    return filteredSettlementChecks;
  }

}
