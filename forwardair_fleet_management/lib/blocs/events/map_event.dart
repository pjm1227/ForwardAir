import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MapEvents extends Equatable {
  MapEvents([List props = const []]) : super(props);
}
//This event called to fetch location address
class FetchLocationEvent extends MapEvents {
  final String latitude, longitude;

  FetchLocationEvent(
      {@required this.latitude,
        @required this.longitude,
       })
      : super([]);
}