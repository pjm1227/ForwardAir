import 'package:forwardair_fleet_management/models/loadDetails/load_detail_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoadDetailState extends Equatable {
  LoadDetailState([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends LoadDetailState {}

//It will handle Error state for Dashboard page
class LoadDataError extends LoadDetailState {
  final String errorMessage;
  LoadDataError({@required this.errorMessage}) : super([errorMessage]);

}




//It will handle Loaded state for Dashboard page
class LoadDataLoaded extends LoadDetailState {
  final LoadDetailModel loadDetails;

  LoadDataLoaded({
    this.loadDetails
  }) : super([loadDetails]);

}
