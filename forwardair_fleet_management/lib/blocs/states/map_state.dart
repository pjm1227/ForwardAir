import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MapState extends Equatable {
  MapState([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends MapState{}

//It will handle Error state for fleet tracker page
class LocationErrorState extends MapState {
  final String errorMessage;

  LocationErrorState({@required this.errorMessage}) : super([errorMessage]);
}

//It will handle success state and return the address
class LocationSuccessState extends MapState {
  final String address;

  LocationSuccessState({this.address}) : super([address]);
}