import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/settlement_data_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettlementStates extends Equatable {
  SettlementStates([List list = const []]) : super(list);
}

//This is Side Menu InitialState
class InitialState extends SettlementStates {}

class ShimmerState extends SettlementStates {}

class ErrorState extends SettlementStates {
  final String errorMessage;

  ErrorState({@required this.errorMessage});
}

class SuccessState extends SettlementStates {
  final SettlementModel settlementData;

  SuccessState({this.settlementData})
      : super([settlementData]);
}

class PickedDateState extends SettlementStates {
  final DateTime pickedDate;

  PickedDateState({this.pickedDate})
      : super([pickedDate]);
}

class NavigateToDetailPageState extends SettlementStates {
  final int selectedIndex;
  final String appBarTitle;
  final SettlementModel settlementModel;
  NavigateToDetailPageState({this.selectedIndex, this.appBarTitle, this.settlementModel})
      : super([selectedIndex, appBarTitle, settlementModel]);
}