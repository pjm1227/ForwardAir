import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//This class handle an events for Terms Page
@immutable
abstract class TermsEvents extends Equatable {
  TermsEvents([List props = const []]) : super(props);
}

//Decline event
class DeclineEvent extends TermsEvents {}

//Accept Event
class AcceptEvent extends TermsEvents {
  final bool isChecked ;
  AcceptEvent({@required this.isChecked}) : assert(isChecked !=null);
}

class CheckBoxEvent extends TermsEvents
{
  final bool isChecked ;
  CheckBoxEvent({@required this.isChecked}) : assert(isChecked !=null);
}
