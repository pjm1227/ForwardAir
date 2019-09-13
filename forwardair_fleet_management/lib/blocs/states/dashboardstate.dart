import 'package:equatable/equatable.dart';
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
  final List<Dashboard_DB_Model> dashboardData;

  DashboardLoaded({
    this.dashboardData
  }) : super([dashboardData]);

}
