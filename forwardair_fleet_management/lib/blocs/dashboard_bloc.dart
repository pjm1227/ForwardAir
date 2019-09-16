import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/blocs/events/dashboardevent.dart';
import 'package:forwardair_fleet_management/blocs/states/dashboardstate.dart';
//import 'package:forwardair_fleet_management/databasemanager/dashboard/dashboard_db_provider.dart';
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

  @override
  get initialState => InitialState();

  @override
  Stream<DashboardState> mapEventToState(DashboardEvents event) async* {

    if (event is FetchDashboardEvent) {
      try {
        if (currentState is InitialState) {
          final posts = await _fetchDashboardDetails();
          yield DashboardLoaded(dashboardData: posts);
        }
        if (currentState is DashboardLoaded) {
          final posts = await fetchDataFromDB();
          yield DashboardLoaded(dashboardData: posts);
        }
      } catch (_) {
        yield DashboardError();
      }
    } else if (event is PullToRefreshDashboardEvent) {
      try {
        if (currentState is DashboardLoaded) {
          final posts = await _fetchDashboardDetails();
          yield InitialState();
          yield DashboardLoaded(dashboardData: posts);
        }
      } catch (_) {
        yield DashboardError();
      }
    }
  }

  Future<List<Dashboard_DB_Model>> _fetchDashboardDetails() async {

    var userManager = UserManager();
    var userModel = await userManager.getData();

    await Utils.checkTheInternetConnection().then((intenet) async {
      if (intenet != null && intenet) {
        // Internet Present Case
        //Load API Data
        final dashboardItems = await apiManager.loadDashboardDataFromServer(userModel.token != null ? userModel.token : '');
        if (dashboardItems.length > 0) {
          // await _dashboard_dbProvider.deleteAll();
          for (var index = 0; index < dashboardItems.length; index++) {
            Dashboard_DB_Model _apimodel = dashboardItems[index];
            final isExist = await _dashboard_dbProvider.isDashboardPeriodeExist(_apimodel);
            if (isExist) {
              print('update $index)');
              _dashboard_dbProvider.updateDashboardDB(_apimodel);
            } else {
              _dashboard_dbProvider.insertIntoDashboardDB(_apimodel);
            }
          }
          dashboardItemsFromDB.addAll(dashboardItems);
        }
      } else {
        // No-Internet Case
        //Fetch From DB
        dashboardItemsFromDB = await fetchDataFromDB();
      }
      return dashboardItemsFromDB;
    });
    return dashboardItemsFromDB;
  }

  //This method to fetch from Dashboard DB
  Future<List<Dashboard_DB_Model>> fetchDataFromDB() async {
    List<Dashboard_DB_Model> list =
        await _dashboard_dbProvider.fetchAllAndConvertMaplistToDashboardList();
    if (list.length > 0) {
      dashboardItemsFromDB = list;
      return dashboardItemsFromDB;
    } else {
      return dashboardItemsFromDB;
    }
  }
}
