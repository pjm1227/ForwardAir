import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';

//This class is responsible to handle the states for Dashboard page
abstract class DashboardState extends Equatable {
  DashboardState([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends DashboardState {}

//It will handle Error state for Dashboard page
class DashboardError extends DashboardState {}

//It will handle Loaded state for Dashboard page
class DashboardLoaded extends DashboardState {
  final Dashboard_DB_Model dashboardData;

  DashboardLoaded({
    this.dashboardData
  }) : super([dashboardData]);

}

//It will handle bottom Sheet actions
class OpenQuickContactsState extends DashboardState {
  final Dashboard_DB_Model dashboardData;

  OpenQuickContactsState({
    this.dashboardData
  }) : super([dashboardData]);

}

//It will handle bottom Sheet actions
class QuickContactsMailState extends DashboardState {
  final Dashboard_DB_Model dashboardData;
  final int selectedIndex;
  QuickContactsMailState({@required this.selectedIndex, @required this.dashboardData}) : super([selectedIndex, dashboardData]);
}

//It will handle bottom Sheet actions
class QuickContactsCallState extends DashboardState {
  final Dashboard_DB_Model dashboardData;
  final int selectedIndex;
  QuickContactsCallState({@required this.selectedIndex, @required this.dashboardData}) : super([selectedIndex, dashboardData]);
}

class ApplyFilterState extends DashboardState {
  final Dashboard_DB_Model aModel;
  ApplyFilterState({@required this.aModel}) : super([aModel]);
}