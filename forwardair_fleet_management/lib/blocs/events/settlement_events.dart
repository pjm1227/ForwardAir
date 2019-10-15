import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettlementEvents extends Equatable {
  SettlementEvents([List list = const []]) : super(list);
}

//This event called when Settlement data
class GetSettlementDataEvent extends SettlementEvents {
  final int month, year;
  GetSettlementDataEvent( {
    @required this.month,
    @required this.year}) : super([]);
}

class PickedDateEvent extends SettlementEvents {
  final DateTime pickedDate;

  PickedDateEvent({this.pickedDate})
      : super([pickedDate]);
}