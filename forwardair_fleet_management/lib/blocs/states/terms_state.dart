import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//This class is responsible to handle the states for Terms page
@immutable
abstract class TermsStates extends Equatable {
  TermsStates([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends TermsStates {}

//It will handle Decline state for terms and condition page
class DeclineState extends TermsStates {}

//It will handle the Accept state for the page
class AcceptState extends TermsStates {}
//It will handle the state for checkbox
class CheckBoxState extends TermsStates {
  final bool accepted;

  CheckBoxState({@required this.accepted}) : super([accepted]);
}
