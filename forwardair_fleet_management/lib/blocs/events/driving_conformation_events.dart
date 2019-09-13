import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DrivingConformationEvents extends Equatable {
  DrivingConformationEvents([List list = const []]) : super(list);
}

class NotDrivingEvent extends DrivingConformationEvents {}

class CloseEvent extends DrivingConformationEvents {}
