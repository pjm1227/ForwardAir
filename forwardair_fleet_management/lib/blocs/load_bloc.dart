import 'package:forwardair_fleet_management/apirepo/repository.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/chart_data_month.dart';
import 'package:forwardair_fleet_management/models/chart_data_weeks.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:forwardair_fleet_management/models/webservice/load_request.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

import 'barrels/load.dart';
import 'package:bloc/bloc.dart';

class LoadBloc extends Bloc<LoadEvents, LoadStates> {
  @override
  LoadStates get initialState => InitialState();

  @override
  Stream<LoadStates> mapEventToState(
    LoadEvents event,
  ) async* {
    if (event is GetTractorDataEvent) {
      //fetching load data so show shimmer effect while we get data from API
      yield ShimmerState();
      yield* _makeApiCall(event);
    }
  }

  //This method is check internet first, If we have internet connection
  // then call an API else Check if data exists in DB, If we have data in db then
  // Show it from DB else show some error
  Stream<LoadStates> _makeApiCall(GetTractorDataEvent event) async* {
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
            month: event.month);
        //Convert request model to json
        var body = request.toJson();
        print(body.toString());
        var result = await repository.makeDrillDataRequest(
            body.toString(), userModel.token);
        //Check if result is an instance of TractorModel or ErrorModel
        //If it's TractorModel then insert data into DB else show error message
        if (result is ErrorModel) {
          //Show some error
          yield ErrorState();
        } else {
          try {
            //Data found for Tractors
            var tractorModel = tractorDataFromJson(result);
            print('Data Found');
            //  await _insertIntoDB(tractorModel);
            //Now make a request to Call APi For chart Data
            //We can use same request Model for it
            var chartResult = await repository.makeChartDataRequest(
                body.toString(), userModel.token);
            //Check if result is an instance of ChartDataModel or ErrorModel
            //If it's ChartDataModel then insert data into DB else show error message
            if (chartResult is ErrorModel) {
              yield ErrorState();
            } else {
              try {
                //Now We have chart Data and Tractor data insert them into DB
                //Here we will check If chart data is for Month or week,
                //Convert chart data model according to week or month
                var chartDataModel;
                if (chartDataMonthFromJson(chartResult).weeks != null) {
                  //Convert into chart month model
                  chartDataModel = chartDataMonthFromJson(chartResult);
                } else {
                  //Convert into Chart Weeks model
                  chartDataModel = chartDataWeeksFromJson(chartResult);
                }
                //Now we have chart data, return success state with chart data model
                // and tractor data
                yield SuccessState(
                  tractorData: sortingData(event.pageName, tractorModel),
                  loadChartData: chartDataModel,
                );
                print(" Chart Data Found");
                // Handle type error
              } catch (_) {
                print("Exception found in chart API");
                yield ErrorState();
              }
            }
          } catch (_) {
            yield ErrorState();
            print("db Exception");
          }
        }
      } else {
        yield ErrorState();
      }
    } else {
      //No internet connection, So fetch Data from DB
      yield ErrorState();
    }
  }

  //This method sort Tractors data according to miles and loads
  TractorData sortingData(PageName pageName, TractorData tractorModel) {
    if (pageName == PageName.MILES_PAGE) {
      tractorModel.tractors
          .sort((a, b) => b.totalMiles.compareTo(a.totalMiles));
    } else {
      tractorModel.tractors
          .sort((a, b) => b.totalLoads.compareTo(a.totalLoads));
    }

    return tractorModel;
  }

  _insertIntoDB(TractorData tractorModel) {}
}
