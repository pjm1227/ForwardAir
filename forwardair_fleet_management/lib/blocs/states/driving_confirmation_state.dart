import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DrivingConfirmationState extends Equatable {
  DrivingConfirmationState([List list = const []]) : super(list);
}

class InitialState extends DrivingConfirmationState {}

class CloseState extends DrivingConfirmationState {}
class NotDrive extends DrivingConfirmationState {}

class NotDrivingState extends DrivingConfirmationState {
  final bool isTermsAccepted, isUserLoggedIn;

  NotDrivingState(
      {@required this.isTermsAccepted, @required this.isUserLoggedIn})
      : super([isTermsAccepted, isUserLoggedIn]);
}
