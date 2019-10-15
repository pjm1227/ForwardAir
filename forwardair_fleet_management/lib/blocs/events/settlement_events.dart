import 'package:equatable/equatable.dart';
import 'package:forwardair_fleet_management/models/settlement_data_model.dart';
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

class NavigateToDetailPageEvent extends SettlementEvents {
  final int selectedIndex;
  final String appBarTitle;
  final SettlementModel settlementModel;
  NavigateToDetailPageEvent({this.selectedIndex, this.appBarTitle, this.settlementModel})
      : super([selectedIndex, appBarTitle, settlementModel]);
}