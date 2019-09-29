import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/blocs/barrels/login.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/databasemanager/user_role_manager.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';
import 'package:forwardair_fleet_management/models/login_model.dart';
import 'package:forwardair_fleet_management/models/webservice/login_request.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:forwardair_fleet_management/apirepo/repository.dart';

//Login Bloc,All business logic for login page will goes here
class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  //It will call to map initial State
  @override
  LoginStates get initialState => LoginInitialState();

  //Here will map state according to event
  @override
  Stream<LoginStates> mapEventToState(
    LoginEvents event,
  ) async* {
    if (event is ObSecureEvent) {
      yield ObSecureState(isVisible: event.isVisible);
    }
    if (event is LoginPressedEvent) {
      yield* _validation(event.userName, event.userPassword);
    }
  }

//This method is called to validate views and making API call
  Stream<LoginStates> _validation(String userName, String userPassword) async* {
    if (userName.isEmpty) {
      yield LoginInitialState();
      yield FormErrorState(errorMessage: Constants.ERROR_ENTER_NAME);
    }/* else if (!_isValidEmail(userName)) {
      yield LoginInitialState();
      yield FormErrorState(errorMessage: Constants.ERROR_ENTER_VALID_EMAIL);
    } */else if (userPassword.isEmpty) {
      yield LoginInitialState();
      yield FormErrorState(errorMessage: Constants.ERROR_ENTER_PASSWORD);
    } else {
      //Check for internet connection
      var isConnection = await Utils.isConnectionAvailable();
      if (isConnection) {
        //And make API call here
        yield* makeAPiCall(userName, userPassword);
      } else {
        yield LoginInitialState();
        yield FormErrorState(errorMessage: Constants.NO_INTERNET_FOUND);
      }
    }
  }

  //Validation for email
  bool _isValidEmail(String email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }

  //This method is used to make an API call
  // And save user data into DB
  Stream<LoginStates> makeAPiCall(String userName, String userPassword) async* {
    yield LoginLoadingState();
    var request = LoginRequest(userName.trim(), userPassword.trim());
    var body = request.toJson();
    print(body.toString());
    final _repository = Repository();
    var result = await _repository.makeLoginRequest(body.toString());
    //Check if result is an instance of LoginModel or ErrorModel
    //If it's LoginModel then insert data into DB else show error message
    if (result is ErrorModel) {
      yield LoginInitialState();
      yield FormErrorState(errorMessage: result.errorMessage);
    } else {
      try {
        var loginModel = loginModelFromJson(result);
        await _insertIntoDB(loginModel);
        yield LoginSuccessState();
      } catch (_) {
        yield LoginInitialState();
        yield FormErrorState(errorMessage: Constants.SOMETHING_WRONG);
        print("db Exception");
      }
    }
  }

  //This method is used to insert data in user table after user logged in successfully.
  Future<int> _insertIntoDB(LoginModel loginModel) async {
    //Instance of user Table manager
    var userManager = UserManager();
    //Mapping User model
    var userModel = UserDetails(
      token: loginModel.token,
      emailAddress: loginModel.userDetails.emailAddress,
      fullName: loginModel.userDetails.fullName,
      userId: loginModel.userDetails.userId,
      stationCd: loginModel.userDetails.stationCd,
      participantId: loginModel.userDetails.participantId,
      phone: loginModel.userDetails.phone,
      companyCd: loginModel.userDetails.companyCd,
      contractorcd: loginModel.userDetails.contractorcd,
      driverid: loginModel.userDetails.driverid,
      driveroid: loginModel.userDetails.driveroid,
      faauthuseroid: loginModel.userDetails.faauthuseroid,
      xrefoid: loginModel.userDetails.xrefoid,
      faauthuserid: loginModel.userDetails.faauthuserid,
      usertype: loginModel.userDetails.usertype,
      activetractors: loginModel.userDetails.activetractors,
      isUserLoggedIn: true,
    );
    //Inserting user Data into DB
    await userManager.insertTermsData(userModel.toMap());
    print("User Table inserted");
    //Check for user group and user role
    if (loginModel.userDetails.userGroups.length > 0) {
      //Here is the list of User Roles
      for (UserGroup userGroup in loginModel.userDetails.userGroups) {
        var userRoles = userGroup.userRoles;
        //Insert User Roles into Table now
        var userRolesManager = UserRoleManager();
        userRoles.forEach((k) async {
          var userRoleModel = UserRole(roleNm: k.roleNm);
          await userRolesManager.insertUserRole(userRoleModel.toMap());
          print("User Role inserted.");
        });
      }
    }
    return 0;
  }
}
