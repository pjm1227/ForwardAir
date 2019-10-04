import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/load_chart_data.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoadStates extends Equatable {
  LoadStates([List list = const []]) : super([list]);
}

class InitialState extends LoadStates {}

class ShimmerState extends LoadStates {}

class ErrorState extends LoadStates {
  final String errorMessage;

  ErrorState({@required this.errorMessage});
}

class SuccessState extends LoadStates {
  final dynamic loadChartData;
  final TractorData tractorData;

  SuccessState({this.loadChartData, this.tractorData})
      : super([loadChartData, tractorData]);
}

class SortState extends LoadStates {
  final List<Map<Tractor, Color>> tractorData;

  SortState({this.tractorData}) : super([tractorData]);
}
