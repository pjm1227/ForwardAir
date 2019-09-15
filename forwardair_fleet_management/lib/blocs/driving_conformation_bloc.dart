import 'package:forwardair_fleet_management/databasemanager/terms_manager.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/blocs/barrels/driving_conformation.dart';
import 'package:bloc/bloc.dart';

class DrivingConformationBloc
    extends Bloc<DrivingConformationEvents, DrivingConfirmationState> {
  //Return an Initial state of widget
  @override
  get initialState => InitialState();

  //Map event with state
  @override
  Stream<DrivingConfirmationState> mapEventToState(
    DrivingConformationEvents event,
  ) async* {
    if (event is NotDrivingEvent) {
      yield InitialState();
      yield* checkForPaageNavigation();
    }
    if (event is CloseEvent) yield CloseState();
  }

  //This method will check if user accepted terms and conditions or Logged in
  //If not accepted then move to terms page else direct to Login page
  //If user Logged in then direct move to Dashboard page
  Stream<DrivingConfirmationState> checkForPaageNavigation() async* {
    var termManager = TermsManager();
    var termModel = await termManager.getData();
    // Check for if user Logged in already
    var userManager = UserManager();
    var userModel = await userManager.getData();
    yield NotDrivingState(
        isTermsAccepted: termModel != null ? termModel.isTermsAccepted : false,
        isUserLoggedIn: userModel != null ? userModel.isUserLoggedIn : false);
  }
}
