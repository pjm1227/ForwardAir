import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginStates extends Equatable {
  LoginStates([List list = const []]) : super([list]);
}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginFailureState extends LoginStates {
  final String errorMessage;

  LoginFailureState({@required this.errorMessage}) : super([errorMessage]);
}

class LoginSuccessState extends LoginStates {}

class FormErrorState extends LoginStates {
  final String errorMessage;

  FormErrorState({@required this.errorMessage}) : super([errorMessage]);
}

class ObSecureState extends LoginStates {
  final bool isVisible;

  ObSecureState({@required this.isVisible}) : super([isVisible]);
}
