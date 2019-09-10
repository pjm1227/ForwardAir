import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

import 'events/terms_events.dart';
import 'states/terms_state.dart';

//This is Bloc class for Terms And Condition page
//Here we will implement all the logic part for terms page.
class TermsBloc extends Bloc<TermsEvents, TermsStates> {
  @override
  TermsStates get initialState => InitialState();

  @override
  Stream<TermsStates> mapEventToState(
    TermsEvents event,
  ) async* {
    if (event is DeclineEvent) {
      yield DeclineState();
    }
    if (event is CheckBoxEvent) {
      yield CheckBoxState(accepted: event.isChecked);
    }
    if (event is AcceptEvent) {
      print('Accept Event');
      print(event.isChecked);
      if (event.isChecked)
        yield AcceptState();
      else {
        Utils.showToast(Constants.ACCEPT_TERMS_CONDITION);
      }
    }
  }
}
