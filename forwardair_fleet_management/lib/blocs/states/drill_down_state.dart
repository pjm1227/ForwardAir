import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/drillDown/drill_down_model.dart';
import 'package:meta/meta.dart';

//This class is responsible to handle the states for Dashboard page
abstract class DrillDownState extends Equatable {
  DrillDownState([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends DrillDownState {}

//It will handle Error state for Dashboard page
class DrillDataError extends DrillDownState {
  final String errorMessage;
  DrillDataError({@required this.errorMessage}) : super([errorMessage]);

}

class DataLoadingState extends DrillDownState {}

class PeriodChangeState extends DrillDownState {
  final bool weekText;

  PeriodChangeState({
    this.weekText
  }) : super([weekText]);
}

//It will handle Loaded state for Dashboard page
class DrillDataLoaded extends DrillDownState {
  final DrillDownModel drillDownData;

  DrillDataLoaded({
    this.drillDownData
  }) : super([drillDownData]);

}

class SortedState extends DrillDownState {
  final DrillDownModel sortedData;

  SortedState({
    this.sortedData
  }) : super([sortedData]);}