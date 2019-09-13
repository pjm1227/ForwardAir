import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//This class handle an events for Dashboard Page
@immutable
abstract class DashboardEvents extends Equatable {
  DashboardEvents([List props = const []]) : super(props);
}

class FetchDashboardEvent extends DashboardEvents {

}

class PullToRefreshDashboardEvent extends DashboardEvents {

}
