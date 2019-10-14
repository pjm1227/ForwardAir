import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/load_chart_data.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoadStates extends Equatable {
  LoadStates([List list = const []]) : super([list]);
}

//Initial State
class InitialState extends LoadStates {}

//This state is called when API called
class ShimmerState extends LoadStates {}

//This state is return errors
class ErrorState extends LoadStates {
  final String errorMessage;

  ErrorState({@required this.errorMessage});
}

//This state is called when API return data
class SuccessState extends LoadStates {
  final dynamic loadChartData;
  final TractorData tractorData;

  SuccessState({this.loadChartData, this.tractorData})
      : super([loadChartData, tractorData]);
}

//This state is return when user choose sorting
class SortState extends LoadStates {
  final List<Map<Tractor, Color>> tractorData;

  SortState({this.tractorData}) : super([tractorData]);
}

//This state is return when user choose sorting
class FuelGallonsAmountState extends LoadStates {
  final bool isGallonClicked, isTotalAmountClicked;

  FuelGallonsAmountState({@required this.isGallonClicked, @required this.isTotalAmountClicked})
      : super([]);
}
