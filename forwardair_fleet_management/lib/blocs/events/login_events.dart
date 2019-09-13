import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvents extends Equatable {
  LoginEvents([List list = const []]) : super(list);
}

class LoginPressedEvent extends LoginEvents {
  final String userName, userPassword;

  LoginPressedEvent({@required this.userName, @required this.userPassword})
      : super([]);
}

//This event will call on hide and visible password
class ObSecureEvent extends LoginEvents {
  final bool isVisible;

  ObSecureEvent({@required this.isVisible}) : super([isVisible]);
}
