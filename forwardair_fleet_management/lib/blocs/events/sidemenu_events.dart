import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SideMenuEvents extends Equatable {
  SideMenuEvents([List list = const []]) : super(list);
}

class DisplayInitiallyEvent extends SideMenuEvents {}

//this event to navigate to other screens
class NavigationEvent extends SideMenuEvents {
  final int selectedIndex;
  final bool expandFlag;

  NavigationEvent({@required this.selectedIndex, @required this.expandFlag})
      : super([]);
}

//This Event for expanded the ListView
class ExpandEvent extends SideMenuEvents {
  final bool expandFlag;
  final int selectedIndex;
  ExpandEvent({@required this.selectedIndex, @required this.expandFlag})
      : super([]);
}

//This Event to expand the SafetyIncidents sub items
class SafetyIncidentsEvent extends SideMenuEvents {
  final int selectedIndex;
  SafetyIncidentsEvent({@required this.selectedIndex})
      : super([]);
}


//This event for logout
class LogoutEvent extends SideMenuEvents {

}