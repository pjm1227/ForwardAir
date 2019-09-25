

import 'package:forwardair_fleet_management/apirepo/repository.dart';
import 'package:forwardair_fleet_management/blocs/events/drill_down_event.dart';
import 'package:forwardair_fleet_management/blocs/states/drill_down_state.dart';
import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/drillDown/drill_down_model.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';
import 'package:forwardair_fleet_management/models/login_model.dart';
import 'package:forwardair_fleet_management/models/webservice/drill_down_request.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';

class DrillDownBloc extends Bloc<DrillDownEvents,DrillDownState> {

  @override
  get initialState => InitialState();
  //Fetched Array From DB
  Stream<DrillDownState> FetchDrillDownData(String weekStart, String weekEnd,int month,String year,bool isMilePage) async* {

    yield DataLoadingState();

    var userManager = UserManager();
    var userModel = await userManager.getData();

    var request = DrillDownRequest(weekStart,weekEnd,month,year);
    var body = request.toJson();
    print(body.toString());
    final _repository = Repository();
    var result = await _repository.makeDrillDataRequest(body.toString(),userModel.token != null ? userModel.token : '');
    print('Result is $result');
    //Check if result is an instance of LoginModel or ErrorModel
    //If it's LoginModel then insert data into DB else show error message
    if (result is ErrorModel) {
      yield DrillDataError(errorMessage: result.errorMessage);
    } else {
      try {
        var drillDownData= sortbyContribution('High',drillDownModelFromJson(result),isMilePage);
        yield DrillDataLoaded(drillDownData: drillDownData);
      } catch (_) {
        yield DrillDataError(errorMessage: Constants.SOMETHING_WRONG);
        print("db Exception");
      }
    }
  }



  @override
  Stream<DrillDownState> mapEventToState(DrillDownEvents event,)async* {
    if(event is FetchDrillDownEvent){
      yield* FetchDrillDownData(event.weekStart, event.weekEnd,event.month,event.year,event.isMilePage);
    }
    else if (event is PeriodEvent) {
      yield PeriodChangeState(weekText: event.weekText);
    }
    else if(event is FilterEvent){

      if(event.filterOption==Constants.TEXT_ASCENDING){
        var drillDownData=sortbyTractorId('Ascending',event.drillData);
        yield InitialState();
        yield SortedState(sortedData: drillDownData,filterOption: event.filterOption);
      }
      else if(event.filterOption==Constants.TEXT_DESCENDING){
        var drillDownData=sortbyTractorId('Descending',event.drillData);
        yield InitialState();
        yield SortedState(sortedData: drillDownData,filterOption: event.filterOption);
      }
      else if(event.filterOption==Constants.TEXT_HIGHTOLOW){
        var drillDownData=sortbyContribution('High',event.drillData,event.isMilePage);
        yield InitialState();
        yield SortedState(sortedData: drillDownData,filterOption: event.filterOption);
      }
      else if(event.filterOption==Constants.TEXT_LOWTOHIGH){
        var drillDownData=sortbyContribution('Low',event.drillData,event.isMilePage);
        yield InitialState();
        yield SortedState(sortedData: drillDownData,filterOption: event.filterOption);
      }

    }
  }

  DrillDownModel sortbyTractorId(String text,DrillDownModel data){
    if(text=='Ascending'){
      data.tractors.sort((a, b) =>
      (int.parse(a.tractorId)).compareTo(int.parse(b.tractorId)));
    }
    else if(text=='Descending'){
      data.tractors.sort((a, b) =>
          (int.parse(b.tractorId)).compareTo(int.parse(a.tractorId)));
    }

    return data;
  }

  DrillDownModel sortbyContribution(String text,DrillDownModel data,bool isMilePage){
    if(text=='High' && isMilePage){
      data.tractors.sort((a, b) =>
          b.totalMilesPercent.compareTo(a.totalMilesPercent));
    }
    if(text=='High' && !isMilePage){
      data.tractors.sort((a, b) =>
          b.totalLoadsPercent.compareTo(a.totalLoadsPercent));
      return data;
    }
    else if(text=='Low' && isMilePage){
      data.tractors.sort((a, b) =>
          a.totalMilesPercent.compareTo(b.totalMilesPercent));
    }
    else if(text=='Low' && !isMilePage){
      data.tractors.sort((a, b) =>
          a.totalLoadsPercent.compareTo(b.totalLoadsPercent));
    }

    return data;
  }


}