import 'package:forwardair_fleet_management/databasemanager/database_helper.dart';
import 'package:forwardair_fleet_management/databasemanager/terms_manager.dart';
import 'package:forwardair_fleet_management/models/database/terms_model.dart';

import 'package:forwardair_fleet_management/blocs/barrels/driving_conformation.dart';
import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/utility/endpoints.dart';

class DrivingConformationBloc
    extends Bloc<DrivingConformationEvents, DrivingConfirmationState> {
  @override
  get initialState => InitialState();

  @override
  Stream<DrivingConfirmationState> mapEventToState(
    DrivingConformationEvents event,
  ) async* {
    if (event is NotDrivingEvent) {
      print(event);
      yield InitialState();
      yield* isTermsChecked();
    }
    if (event is CloseEvent) yield CloseState();
  }

  //This method will check if user accepted terms and conditions
  //If not accepted then move to terms page else direct to Login page
  Stream<DrivingConfirmationState> isTermsChecked() async* {
    var termManager = TermsManager();
    var termModel = await termManager.getData();
    yield NotDrivingState(
        isTermsAccepted: termModel != null ? termModel.isTermsAccepted : false);
  }
}
