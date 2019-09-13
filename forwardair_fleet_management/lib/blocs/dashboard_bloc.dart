import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/blocs/events/dashboardevent.dart';
import 'package:forwardair_fleet_management/blocs/states/dashboardstate.dart';
import 'package:forwardair_fleet_management/databasemanager/dashboard/dashboard_db_provider.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/webservice/apimanager.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

class DashboardBloc extends Bloc<DashboardEvents, DashboardState> {
  //DB provider
  Dashboard_DBProvider _dashboard_dbProvider = Dashboard_DBProvider();

  //Fetched Array From DB
  List<Dashboard_DB_Model> dashboardItemsFromDB = [];

  //For API Calling
  final apiManager = APIManager();

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
    await Utils.checkTheInternetConnection().then((intenet) async {
      if (intenet != null && intenet) {
        // Internet Present Case
        //Load API Data
        print('Fetch1');
        final dashboardItems = await apiManager.loadDashboardDataFromServer();
        if (dashboardItems.length > 0) {
          //print('Delete');
          // await _dashboard_dbProvider.deleteAll();
          for (var index = 0; index < dashboardItems.length; index++) {
            Dashboard_DB_Model _apimodel = dashboardItems[index];
            Dashboard_DB_Model _fetched_db_model = await _dashboard_dbProvider
                .fetchAnItemAndconvertMapToDashboard();

            final isExist = await _dashboard_dbProvider.isDashboardPeriodeExist(_apimodel);

            if (isExist == true) {
              print('update $index)');
              _dashboard_dbProvider.updateDashboardDB(_apimodel);
            } else {
              print('insert $index)');
              _dashboard_dbProvider.insertIntoDashboardDB(_apimodel);
            }
          }
          print('Adding to List for UI');
          dashboardItemsFromDB.addAll(dashboardItems);
//          print('Fetch4');
//          dashboardItemsFromDB.addAll(dashboardItems);
        }
      } else {
        // No-Internet Case
        //Fetch From DB
        dashboardItemsFromDB = await fetchDataFromDB();
      }
      return dashboardItemsFromDB;
      // var posts = await apiManager.loadDashboardDataFromServer();
      // return posts;
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
