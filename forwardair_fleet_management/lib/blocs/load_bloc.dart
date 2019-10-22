import 'dart:ui';

import 'package:forwardair_fleet_management/apirepo/repository.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/chart_data_month.dart';
import 'package:forwardair_fleet_management/models/chart_data_weeks.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:forwardair_fleet_management/models/webservice/load_request.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
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

    if (event is SortHighToLowEvent) {
      //Sort data model in high to low
      // And return Sort state
      yield InitialState();
      yield SortState(
          tractorData: sortHighToLow(event.pageName, event.tractorData));
    }
    if (event is SortLowToHighEvent) {
      //Sort data model in low to high
      // And return Sort state
      yield InitialState();
      yield SortState(
          tractorData: sortLowToHigh(event.pageName, event.tractorData));
    }
    if (event is SortAscendingTractorIDEvent) {
      //Sort data model in Ascending order using Tractor Id
      // And return Sort state
      yield InitialState();
      yield SortState(
          tractorData:
              sortAscendingTractorId(event.pageName, event.tractorData));
    }
    if (event is SortDescendingTractorIDEvent) {
      //Sort data model Descending order using Tractor Id
      // And return Sort state
      yield InitialState();
      yield SortState(
          tractorData:
              sortDescendingTractorId(event.pageName, event.tractorData));
    }

    if (event is FuelGallonsEvent) {
      yield FuelGallonsAmountState(
          isGallonClicked: event.isGallonClicked,
          isTotalAmountClicked: event.isTotalAmountClicked);
      yield InitialState();
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
          print('Error found in Tractor API');
          //  yield InitialState();
          //Show some error
          yield ErrorState(errorMessage: result.errorMessage);
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
              yield ErrorState(errorMessage: result.errorMessage);
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
                  tractorData: topContributorData(event.pageName, tractorModel),
                  loadChartData: chartDataModel,
                );
                print(" Chart Data Found");
                // Handle type error
              } catch (_) {
                print("Exception found in chart API");
                yield ErrorState(errorMessage: Constants.SOMETHING_WRONG);
              }
            }
          } catch (_) {
            yield ErrorState(errorMessage: Constants.SOMETHING_WRONG);

            print("db Exception");
          }
        }
      } else {
        yield ErrorState(errorMessage: Constants.SOMETHING_WRONG);
      }
    } else {
      //No internet connection, So fetch Data from DB
      yield ErrorState(errorMessage: Constants.NO_INTERNET_FOUND);
    }
  }

  //This method sort top contributors
  TractorData topContributorData(PageName pageName, TractorData tractorModel) {
    try {
      //Create a temp list to check for tractor list
      //In this list we'll add empty items, so that we can manage exception
      //for null
      var tempTractorList = List<Tractor>();
      tractorModel.tractors.forEach((item) {
        if (pageName == PageName.FUEL_PAGE) {
          if (item.totalTractorGallons == null) {
            //If item is null then add it into tempTractorList
            tempTractorList.add(item);
          }
        } else if (pageName == PageName.COMPENSATION_PAGE) {
          if (item.totalNet == null) {
            //If item is null then add it into tempTractorList
            tempTractorList.add(item);
          }
        } else if (pageName == PageName.LOAD_PAGE) {
          if (item.totalLoads == null) {
            //If item is null then add it into tempTractorList
            tempTractorList.add(item);
          }
        } else {
          if (item.totalMiles == null) {
            //If item is null then add it into tempTractorList
            //And remove it from TractorModel
            tempTractorList.add(item);
          }
        }
      });
      //Now remove element from Tractor List where elements are null based on page name
      tractorModel.tractors.removeWhere((item) => pageName == PageName.FUEL_PAGE
          ? item.totalTractorGallons == null
          : pageName == PageName.COMPENSATION_PAGE
              ? item.totalNet == null
              : pageName == PageName.LOAD_PAGE
                  ? item.totalLoads == null
                  : item.totalMiles == null);
      //We have removed all null items from TractorModel, Now do sorting for top contributor
      tractorModel.tractors.sort((a, b) => pageName == PageName.LOAD_PAGE
          ? b.totalLoads.compareTo(a.totalLoads)
          : pageName == PageName.MILES_PAGE
              ? b.totalMiles.compareTo(a.totalMiles)
              : pageName == PageName.FUEL_PAGE
                  ? b.totalTractorGallons.compareTo(a.totalTractorGallons)
                  : b.totalNet.compareTo(a.totalNet));
      //Sorting is done now add empty item in the list of tractor model and return
      tractorModel.tractors.addAll(tempTractorList);
      return tractorModel;
    } catch (_) {
      return tractorModel;
    }
  }

  //This method sort Tractors data High to low
  List<Map<Tractor, Color>> sortHighToLow(
      PageName pageName, List<Map<Tractor, Color>> tractorModel) {
    try {
      tractorModel.sort((a, b) => pageName == PageName.LOAD_PAGE
          ? b.keys.first.totalLoads.compareTo(a.keys.first.totalLoads)
          : pageName == PageName.MILES_PAGE
              ? b.keys.first.totalMiles.compareTo(a.keys.first.totalMiles)
              : pageName == PageName.FUEL_PAGE
                  ? b.keys.first.totalTractorGallons
                      .compareTo(a.keys.first.totalTractorGallons)
                  : b.keys.first.totalNet.compareTo(a.keys.first.totalNet));
      return tractorModel;
    } catch (_) {
      return tractorModel;
    }
  }

  //This method sort Tractors data low to high
  List<Map<Tractor, Color>> sortLowToHigh(
      PageName pageName, List<Map<Tractor, Color>> tractorModel) {
    try {
      tractorModel.sort((a, b) => pageName == PageName.LOAD_PAGE
          ? a.keys.first.totalLoads.compareTo(b.keys.first.totalLoads)
          : pageName == PageName.MILES_PAGE
              ? a.keys.first.totalMiles.compareTo(b.keys.first.totalMiles)
              : pageName == PageName.FUEL_PAGE
                  ? a.keys.first.totalTractorGallons
                      .compareTo(b.keys.first.totalTractorGallons)
                  : a.keys.first.totalNet.compareTo(b.keys.first.totalNet));
      return tractorModel;
    } catch (_) {
      return tractorModel;
    }
  }

  //This method sort Tractors data in ascending tractor id
  List<Map<Tractor, Color>> sortAscendingTractorId(
      PageName pageName, List<Map<Tractor, Color>> tractorModel) {
    tractorModel.sort((a, b) => int.parse(a.keys.first.tractorId)
        .compareTo(int.parse(b.keys.first.tractorId)));
    return tractorModel;
  }

  //This method sort Tractors data according to miles and loads
  List<Map<Tractor, Color>> sortDescendingTractorId(
      PageName pageName, List<Map<Tractor, Color>> tractorModel) {
    try {
      tractorModel.sort((a, b) => int.parse(b.keys.first.tractorId)
          .compareTo(int.parse(a.keys.first.tractorId)));
      return tractorModel;
    } catch (_) {
      return tractorModel;
    }
  }

  _insertIntoDB(TractorData tractorModel) {}
}
