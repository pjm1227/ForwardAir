import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DrivingConfirmationState extends Equatable {
  DrivingConfirmationState([List list = const []]) : super(list);
}

class InitialState extends DrivingConfirmationState {}

class CloseState extends DrivingConfirmationState {}

class NotDrivingState extends DrivingConfirmationState {
  final bool isTermsAccepted;

  NotDrivingState({@required this.isTermsAccepted}) : super([isTermsAccepted]);
}
