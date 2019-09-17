import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/blocs/events/dashboardevent.dart';
import 'package:forwardair_fleet_management/blocs/states/dashboardstate.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/webservice/dashboard_request.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:forwardair_fleet_management/databasemanager/dashboard_table_manager.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';

class DashboardBloc extends Bloc<DashboardEvents, DashboardState> {
  //DB provider
  DashboardManager _dashboard_dbProvider = DashboardManager();

  //Fetched Array From DB
  List<Dashboard_DB_Model> dashboardItemsFromDB = [];

  //For API Calling
  final apiManager = DashboardRequest();

  //Initial State of the Dashboard
  @override
  get initialState => InitialState();

  //To update UI  based on the state changes in the  Dashboard Page.
  @override
  Stream<DashboardState> mapEventToState(DashboardEvents event) async* {
    // FetchDashboardEvent
    if (event is FetchDashboardEvent) {
      //When app is initialized
      if (currentState is InitialState) {
        final posts = await _fetchDashboardDetails();
        if (posts.length == 0) {
          yield DashboardError();
        } else {
          yield DashboardLoaded(dashboardData: posts);
        }
      }
      //Once screen gets loaded
      if (currentState is DashboardLoaded) {
        final posts = await fetchDataFromDB();
        if (posts.length == 0) {
          yield DashboardError();
        } else {
          yield DashboardLoaded(dashboardData: posts);
        }
      }
    }
    //Pull To Refresh Event
    else if (event is PullToRefreshDashboardEvent) {
      final posts = await _fetchDashboardDetails();
      yield InitialState();
      if (posts.length == 0) {
        yield DashboardError();
      } else {
        yield DashboardLoaded(dashboardData: posts);
      }
    }
  }

  //To Fetch Data either from API Or DB
  Future<List<Dashboard_DB_Model>> _fetchDashboardDetails() async {
    var userManager = UserManager();
    var userModel = await userManager.getData();
    //Handle Internet connection
    var isConnection = await Utils.isConnectionAvailable();
    if (isConnection) {
      // If device is in online
      try {
        //Making API Call
        final dashboardItems = await apiManager.loadDashboardDataFromServer(
            userModel.token != null ? userModel.token : '');
        //If data exist in response
        if (dashboardItems.length > 0) {
          // await _dashboard_dbProvider.deleteAll();
          for (var index = 0; index < dashboardItems.length; index++) {
            Dashboard_DB_Model _apimodel = dashboardItems[index];
            //Check whether response data, exist in DB or not
            final isExist =
                await _dashboard_dbProvider.isDashboardPeriodeExist(_apimodel);
            if (isExist) {
              // To update the DB
              _dashboard_dbProvider.updateDashboardDB(_apimodel);
            } else {
              // To insert into the DB
              _dashboard_dbProvider.insertIntoDashboardDB(_apimodel);
            }
          }
          // Add Items to the List to populate the date into the UI
          dashboardItemsFromDB.addAll(dashboardItems);
          return dashboardItemsFromDB;
        }
      } catch (_) {
        //If any Exception Occurs in API Call
        dashboardItemsFromDB = await fetchDataFromDB();
        return dashboardItemsFromDB;
      }
    } else {
      // If device is in offline
      dashboardItemsFromDB = await fetchDataFromDB();
      return dashboardItemsFromDB;
    }

//    await Utils.checkTheInternetConnection().then((intenet) async {
//      if (intenet != null && intenet) {
//        // Internet Present Case
//        //Load API Data
//        final dashboardItems = await apiManager.loadDashboardDataFromServer(userModel.token != null ? userModel.token : '');
//        if (dashboardItems.length > 0) {
//          // await _dashboard_dbProvider.deleteAll();
//          for (var index = 0; index < dashboardItems.length; index++) {
//            Dashboard_DB_Model _apimodel = dashboardItems[index];
//            final isExist = await _dashboard_dbProvider.isDashboardPeriodeExist(_apimodel);
//            if (isExist) {
//              print('update $index)');
//              _dashboard_dbProvider.updateDashboardDB(_apimodel);
//            } else {
//              _dashboard_dbProvider.insertIntoDashboardDB(_apimodel);
//            }
//          }
//          dashboardItemsFromDB.addAll(dashboardItems);
//        }
//        return dashboardItemsFromDB;
//      } else {
//        // No-Internet Case
//        //Fetch From DB
//        dashboardItemsFromDB = await fetchDataFromDB();
//        return dashboardItemsFromDB;
//      }
//     // return  dashboardItemsFromDB;
//    });
    // return dashboardItemsFromDB;
  }

  //This method to fetch from Dashboard DB
  Future<List<Dashboard_DB_Model>> fetchDataFromDB() async {
    //Fetching all data from DB
    List<Dashboard_DB_Model> list =
        await _dashboard_dbProvider.fetchAllAndConvertMaplistToDashboardList();
    if (list.length > 0) {
      // If data exist, assigning to teh List To update UI
      dashboardItemsFromDB = list;
      return dashboardItemsFromDB;
    } else {
      //If data does not exist in DB.
      return dashboardItemsFromDB;
    }
  }
}
