import 'package:equatable/equatable.dart';
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
