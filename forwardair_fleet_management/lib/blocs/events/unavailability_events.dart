import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';
import 'package:meta/meta.dart';

//This class handle an events for Unavailability Page
@immutable
abstract class UnavailabilityEvents extends Equatable {
  UnavailabilityEvents([List props = const []]) : super(props);
}

class DisplayInitiallyEvent extends UnavailabilityEvents {}

//This event called when Settlement data
class GetUnavailabilityDataEvent extends UnavailabilityEvents {

}

//This event to display the leave details
class TappedonLeaveListItemEvent extends UnavailabilityEvents {
  final UnavailabilityDataModelDetail dataModelDetail;
  TappedonLeaveListItemEvent({@required this.dataModelDetail}) : super([]);
}

//This event to display the leave reporting
class TappedOnLeaveReportingEvent extends UnavailabilityEvents {

}