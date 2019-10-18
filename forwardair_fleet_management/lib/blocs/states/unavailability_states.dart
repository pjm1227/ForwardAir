import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';
import 'package:meta/meta.dart';

//This class is responsible to handle the states for Unavailability page
@immutable
abstract class UnavailabilityStates extends Equatable {
  UnavailabilityStates([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends UnavailabilityStates {}

//This state is called when API called
class ShimmerState extends UnavailabilityStates {}

//This state is return errors
class ErrorState extends UnavailabilityStates {
  final String errorMessage;

  ErrorState({@required this.errorMessage});
}

//This state is called when API return data
class SuccessState extends UnavailabilityStates {
  final UnavailabilityDataModel unavailabilityDataModel;
  final List<UnavailabilityDataModelDetail> pastUnavailabilityList;
  final List<UnavailabilityDataModelDetail> upcomingUnavailabilityList;
  SuccessState({ this.unavailabilityDataModel, this.pastUnavailabilityList, this.upcomingUnavailabilityList})
      : super([unavailabilityDataModel]);
}
