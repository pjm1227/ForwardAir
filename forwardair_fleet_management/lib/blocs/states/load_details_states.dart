import 'package:forwardair_fleet_management/models/Tractor_settlement_model.dart';
import 'package:forwardair_fleet_management/models/loadDetails/load_detail_model.dart';
import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/tractor_fuel_details_model.dart';
import 'package:meta/meta.dart';

abstract class TractorDetailsState extends Equatable {
  TractorDetailsState([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends TractorDetailsState {}

//It will handle Error state for Dashboard page
class DetailsErrorState extends TractorDetailsState {
  final String errorMessage;

  DetailsErrorState({@required this.errorMessage}) : super([errorMessage]);
}

//It will handle Success state for Tractor Loads and miles details
class LoadMilesSuccessState extends TractorDetailsState {
  final TractorDetailsModel tractorDetailsModel;

  LoadMilesSuccessState({this.tractorDetailsModel})
      : super([tractorDetailsModel]);
}

//It will handle Success state for Tractor fuel details
class FuelSuccessState extends TractorDetailsState {
  final TractorFuelDetailsModel fuelDetailsModel;

  FuelSuccessState({this.fuelDetailsModel}) : super([fuelDetailsModel]);
}

//It will handle Success state for Tractor fuel details
class SettlementSuccessState extends TractorDetailsState {
  final TractorSettlementModel settlementDetailsModel;

  SettlementSuccessState({this.settlementDetailsModel})
      : super([settlementDetailsModel]);
}
