import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
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

class ApplyFilterEvent extends DashboardEvents {
  final String selectedDashboardPeriod;

  ApplyFilterEvent({@required this.selectedDashboardPeriod}) : super([]);
}

class DrillDownPageEvent extends DashboardEvents {
  final PageName pageName;

  DrillDownPageEvent({@required this.pageName}) : super([pageName]);
}
