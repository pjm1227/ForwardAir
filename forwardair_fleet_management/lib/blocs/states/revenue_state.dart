import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/blocs/barrels/revenue.dart';
import 'package:meta/meta.dart';

//This class is responsible to handle the states for Revenue Details
@immutable
abstract class RevenueDetailsState extends Equatable {
  RevenueDetailsState([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends RevenueDetailsState {}

//It will handle error state for revenue details page
class RevenueErrorState extends RevenueDetailsState {
  final String errorMessage;

  RevenueErrorState({this.errorMessage}) : super([errorMessage]);
}

//It will handle the Accept state for the page
class RevenueSuccessState extends RevenueDetailsState {
  final dynamic tractorRevenueModel;

  RevenueSuccessState({@required this.tractorRevenueModel}) : super([tractorRevenueModel]);
}
