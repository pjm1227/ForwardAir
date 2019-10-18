import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//This class handle an events for Revenue Page
@immutable
abstract class RevenueDetailsEvent extends Equatable {
  RevenueDetailsEvent([List props = const []]) : super(props);
}

//This event is called to fetch revenue details
class FetchRevenueDetailsEvent extends RevenueDetailsEvent {
  final String transactionType;
  final int oid;

  FetchRevenueDetailsEvent({this.transactionType, this.oid}) : super();
}
