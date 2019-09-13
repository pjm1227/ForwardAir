import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/apirepo/api_methods.dart';
import 'package:forwardair_fleet_management/blocs/barrels/login.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';
import 'package:forwardair_fleet_management/models/login_model.dart';
import 'package:forwardair_fleet_management/models/webservice/login_request.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/endpoints.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:http/src/response.dart';

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
      print(event.isVisible);
      yield ObSecureState(isVisible: event.isVisible);
    }
    if (event is LoginPressedEvent) {
      yield* _validation(event.userName, event.userPassword);
    }
  }

  Stream<LoginStates> _validation(String userName, String userPassword) async* {
    if (userName.isEmpty) {
      yield LoginInitialState();
      yield FormErrorState(emailError: 'Please enter Email');
    } else if (!_isValidEmail(userName)) {
      yield LoginInitialState();
      yield FormErrorState(emailError: 'Please enter a valid Email');
    } else if (userPassword.isEmpty) {
      yield LoginInitialState();
      yield FormErrorState(emailError: 'Please enter a password');
    } else {
      if (Utils.isConnectionAvailable() != null) {
        //And make API call here
        yield* makeAPiCall(userName, userPassword);
      } else {
        yield LoginInitialState();
        yield FormErrorState(emailError: Constants.NO_INTERNET_FOUND);
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
    var apiMethods = ApiMethods();
    var request = LoginRequest(userName, userPassword);
    var body = request.toJson();
    print(body.toString());
    var response = await apiMethods.requestInPost(
        Endpoints.LOGIN_URL, null, body.toString());
    print('Respose $response');
    try {
      var loginModel = loginModelFromJson(response);
      //print(loginModel.userDetails.isUserLoggedIn);
      await _insertIntoDB(loginModel);
      yield LoginSuccessState();
    } on TypeError {
      print('Response in Type $response');
      var errorModel = errorModelFromJson(response);
      yield LoginInitialState();
      yield FormErrorState(emailError: response);
    }
  }

  Future<int> _insertIntoDB(LoginModel loginModel) async {
    var userManager = UserManager();
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
    print('Inserting into DB...');
    var id = await userManager.insertTermsData(userModel.toMap());
    print('Inserted $id');
    return id;
  }
}
