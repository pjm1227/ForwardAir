import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:forwardair_fleet_management/blocs/barrels/dashboard.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:forwardair_fleet_management/databasemanager/dashboard_manager.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/apirepo/repository.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';

class DashboardBloc extends Bloc<DashboardEvents, DashboardState> {
  //DB provider
  DashboardManager _dashboard_dbProvider = DashboardManager();
  //Fetched List From DB
  List<Dashboard_DB_Model> dashboardItemsFromDB = [];
  //Flag
  bool isAPICalling = false;
  //Filter Period Type
  String _selectedPeriodTypeInFilter = '';
  //No Internet Connection
  String noInternetText = '';

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
        final dbData = await fetchDataFromDB();
        if (dbData.length == 0) {
          final posts = await _fetchDashboardDetails();
          if (posts.length == 0) {
            yield DashboardError();
          } else {
            final selectedModel = applyFilterInaDashboard(posts);
            yield DashboardLoaded(dashboardData: selectedModel);
          }
        } else {
          final selectedModel = applyFilterInaDashboard(dbData);
          yield DashboardLoaded(dashboardData: selectedModel);
        }
      }
      //Once screen gets loaded
      if (currentState is DashboardLoaded) {
        noInternetText = '';
        final posts = await fetchDataFromDB();
        if (posts.length == 0) {
          yield DashboardError();
        } else {
          final selectedModel = applyFilterInaDashboard(posts);
          yield DashboardLoaded(dashboardData: selectedModel);
        }
      }
    }
    //Pull To Refresh Event
    else if (event is PullToRefreshDashboardEvent) {
      noInternetText = '';
      final posts = await _fetchDashboardDetails();
      yield InitialState();
      if (posts.length == 0) {
        yield DashboardError();
      } else {
        //If filter not applied
        var selectedModel = applyFilterInaDashboard(posts);
        yield DashboardLoaded(dashboardData: selectedModel);
      }
    }
    //Open Qucik Contact Sheet
    else if (event is OpenQuickContactsEvent) {
      final posts = await fetchDataFromDB();
      var selectedModel = applyFilterInaDashboard(posts);
      yield DashboardLoaded(dashboardData: selectedModel);
      yield OpenQuickContactsState(dashboardData: selectedModel);
    }
    //To send a mail from Quick Contact Sheet
    else if (event is QuickContactTapsOnMailEvent) {
      final posts = await fetchDataFromDB();
      var selectedModel = applyFilterInaDashboard(posts);
      yield DashboardLoaded(dashboardData: selectedModel);
      yield QuickContactsMailState(
          selectedIndex: event.selectedIndex, dashboardData: selectedModel);
    }
    //To make a call from Quick Contact Sheet
    else if (event is QuickContactTapsOnCallEvent) {
      final posts = await fetchDataFromDB();
      var selectedModel = applyFilterInaDashboard(posts);
      yield DashboardLoaded(dashboardData: selectedModel);
      yield QuickContactsCallState(
          selectedIndex: event.selectedIndex, dashboardData: selectedModel);
    }
    //Apply Filter
    else if (event is ApplyFilterEvent) {
      final dashboardList = await fetchDataFromDB();
      _selectedPeriodTypeInFilter = event.selectedDashboardPeriod;
      final selectedModel = applyFilterInaDashboard(dashboardList);
      yield ApplyFilterState(
          selectedIndex: event.selectedIndex, aModel: selectedModel);
    }
    //Drill Down Page
    else if (event is DrillDownPageEvent) {
      final posts = await fetchDataFromDB();
      var selectedModel = applyFilterInaDashboard(posts);
      yield DashboardLoaded(dashboardData: selectedModel);
      yield DrillDownPageState(
          pageName: event.pageName, dashboardData: selectedModel);
    }
  }

  Dashboard_DB_Model applyFilterInaDashboard(
      List<Dashboard_DB_Model> dashboardList) {
    if (_selectedPeriodTypeInFilter == '') {
      _selectedPeriodTypeInFilter = Constants.TEXT_DASHBOARD_PERIOD_THIS_MONTH;
    }
    for (var aModel in dashboardList) {
      if (aModel.dashboardPeriod == _selectedPeriodTypeInFilter) {
        return aModel;
      }
    }
  }

  //To Fetch Data either from API Or DB
  Future<List<Dashboard_DB_Model>> _fetchDashboardDetails() async {
    var userManager = UserManager();
    var userModel = await userManager.getData();
    //Check internet connection
    var isConnection = await Utils.isConnectionAvailable();
    if (isConnection) {
      // If device is in online
      try {
        //Making API Call
        final _repository = Repository();
        isAPICalling = true;
        final responseBody = await _repository.makeDashboardRequest(
            userModel.token != null ? userModel.token : '');
        final dashboardItems =
            Dashboard_DB_Model().dashboardDBModelFromJson(responseBody);
        //For success
        if (dashboardItems.length > 0) {
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
          dashboardItemsFromDB = [];
          // Add Items to the List to populate the date into the UI
          dashboardItemsFromDB.addAll(dashboardItems);
          return dashboardItemsFromDB;
        }
      }
      //If any Exception Occurs in API Call
      catch (_) {
        dashboardItemsFromDB = await fetchDataFromDB();
        return dashboardItemsFromDB;
      }
    } else {
      // If device is in offline
      dashboardItemsFromDB = await fetchDataFromDB();
      if (dashboardItemsFromDB.length == 0) {
        noInternetText = Constants.NO_INTERNET_FOUND;
      } else {
        noInternetText = '';
      }
      return dashboardItemsFromDB;
    }
  }

  //To fetch data from DB
  Future<List<Dashboard_DB_Model>> fetchDataFromDB() async {
    //Fetching all from DB
    List<Dashboard_DB_Model> list =
        await _dashboard_dbProvider.fetchAllAndConvertMaplistToDashboardList();
    if (list.length > 0) {
      // If data exist
      dashboardItemsFromDB = list;
      return dashboardItemsFromDB;
    } else {
      //If data does not exist in DB.
      return dashboardItemsFromDB;
    }
  }

  //To return the Filter Title of a Period
  String convertPeriodToTitle(String periodType) {
    if (periodType == Constants.TEXT_DASHBOARD_PERIOD_THIS_WEEK) {
      return Constants.TEXT_THISWEEK;
    } else if (periodType == Constants.TEXT_DASHBOARD_PERIOD_LAST_WEEK) {
      return Constants.TEXT_LASTWEEK;
    } else if (periodType ==
        Constants.TEXT_DASHBOARD_PREVIOUS_SETTLEMENT_PERIOD) {
      return Constants.TEXT_PREV_SETTLEMENT_PERIOD;
    } else {
      return Constants.TEXT_THISMONTH;
    }
  }

  //To return Filter Type of a Period
  String convertTitleToPeriod(String periodType) {
    if (periodType == Constants.TEXT_THISWEEK) {
      return Constants.TEXT_DASHBOARD_PERIOD_THIS_WEEK;
    } else if (periodType == Constants.TEXT_LASTWEEK) {
      return Constants.TEXT_DASHBOARD_PERIOD_LAST_WEEK;
    } else if (periodType == Constants.TEXT_PREV_SETTLEMENT_PERIOD) {
      return Constants.TEXT_DASHBOARD_PREVIOUS_SETTLEMENT_PERIOD;
    } else {
      return Constants.TEXT_DASHBOARD_PERIOD_THIS_MONTH;
    }
  }

  String addDollarAfterMinusSign(String deductions) {
    String deduction = '';
    if (deductions != 'N/A') {
      deduction = '-\$' + deductions.replaceAll(RegExp('-'), '');
    } else {
      deduction = 'N/A';
    }
    return deduction;
  }

  String appendDollarSymbol(String value) {
    String textWithDollar = '';
    if (value != 'N/A') {
      textWithDollar = '\$' + value;
    } else {
      textWithDollar = 'N/A';
    }
    return textWithDollar;
  }
}
