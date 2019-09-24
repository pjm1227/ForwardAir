import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoadDetailEvents extends Equatable {
  LoadDetailEvents([List props = const []]) : super(props);
}

class FetchLoadDetailsEvent extends LoadDetailEvents {
  final String weekStart, weekEnd,year,tractorId;
  final int month;


  FetchLoadDetailsEvent({@required this.weekStart, @required this.weekEnd,@required this.month,@required this.year,@required this.tractorId})
      : super([]);

}
