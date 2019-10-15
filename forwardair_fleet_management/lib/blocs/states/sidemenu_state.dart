import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SideMenuStates extends Equatable {
  SideMenuStates([List list = const []]) : super(list);
}

//This is Side Menu InitialState
class FirstState extends SideMenuStates {
  FirstState() : super([]);
}

//This is Side Menu InitialState
class InitialState extends SideMenuStates {
  final int selectedIndex;
  InitialState({@required this.selectedIndex}) : super([selectedIndex,]);
}

//This State for Logout
class LoggedOutState extends SideMenuStates {
  final int selectedIndex;
  LoggedOutState({@required this.selectedIndex}) : super([selectedIndex]);
}

//This State for Logout
class TappedOnLogoutState extends SideMenuStates {
  TappedOnLogoutState() : super([]);
}

//This State for Navigation Option
class NavigationState extends SideMenuStates {
  final int selectedIndex;
  NavigationState({@required this.selectedIndex}) : super([selectedIndex,]);
}

//This SafetyIncident ListView sub Items
class ExpandState extends SideMenuStates {
  final bool expandFlag;
  final int selectedIndex;
  ExpandState({@required this.selectedIndex, @required this.expandFlag}) : super([ expandFlag, selectedIndex]);
}

//This State to expand SafetyIncident
class SafetyIncidentState extends SideMenuStates {
  final int selectedIndex;
  SafetyIncidentState({@required this.selectedIndex}) : super([selectedIndex]);
}