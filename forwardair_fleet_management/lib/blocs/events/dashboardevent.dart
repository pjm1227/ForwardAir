import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//This class handle an events for Dashboard Page
@immutable
abstract class DashboardEvents extends Equatable {
  DashboardEvents([List props = const []]) : super(props);
}

class FetchDashboardEvent extends DashboardEvents {}

class PullToRefreshDashboardEvent extends DashboardEvents {}

class OpenQuickContactsEvent extends DashboardEvents {}

class QuickContactTapsOnMailEvent extends DashboardEvents {
  final int selectedIndex;

  QuickContactTapsOnMailEvent({@required this.selectedIndex}) : super([]);
}

class QuickContactTapsOnCallEvent extends DashboardEvents {
  final int selectedIndex;

  QuickContactTapsOnCallEvent({@required this.selectedIndex}) : super([]);
}
