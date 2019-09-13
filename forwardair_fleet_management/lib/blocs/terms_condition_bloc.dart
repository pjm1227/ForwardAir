import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/databasemanager/database_helper.dart';
import 'package:forwardair_fleet_management/databasemanager/terms_manager.dart';
import 'package:forwardair_fleet_management/models/database/terms_model.dart';
import 'package:forwardair_fleet_management/utility/endpoints.dart';
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
      if (event.isChecked) {
        //User accepted the terms and condition now add data in DB
        _insertIntoDB();
        yield AcceptState(accepted: true);
      } else {
        yield InitialState();
        yield AcceptState(accepted: false);
      }
    }
  }

  //This method insert user acceptance into DB
  void _insertIntoDB() async {
    var termManager = TermsManager();
    var termsModel = TermsModel(id: 0, isTermsAccepted: true);
    await termManager.insertTermsData(termsModel.toMap());
  }
}
