import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//This class handle an events for Terms Page
@immutable
abstract class ChartEvents extends Equatable {
  ChartEvents([List props = const []]) : super(props);
}

//Accept Event
class SelectEvent extends ChartEvents {
  final int total;

  SelectEvent({@required this.total}) : assert(total != null);
}
