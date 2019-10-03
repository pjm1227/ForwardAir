import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//This class is responsible to handle the states for Terms page
@immutable
abstract class ChartStates extends Equatable {
  ChartStates([List props = const []]) : super(props);
}

//It will handle Initial state
class InitialState extends ChartStates {}

//It will handle the Accept state for the page
class SelectState extends ChartStates {
  final double total;

  SelectState({@required this.total}) : super([total]);
}
