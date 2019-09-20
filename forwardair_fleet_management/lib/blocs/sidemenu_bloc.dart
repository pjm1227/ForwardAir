import 'dart:math';

import 'package:bloc/bloc.dart';

import 'package:forwardair_fleet_management/blocs/events/sidemenu_events.dart';
import 'package:forwardair_fleet_management/blocs/states/sidemenu_state.dart';
import 'package:forwardair_fleet_management/databasemanager/terms_manager.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/login_model.dart';

import 'package:package_info/package_info.dart';

//SideMenu Bloc,All business logic for drawer menu
class SideMenuBloc extends Bloc<SideMenuEvents, SideMenuStates> {
  //User Details
  UserDetails userDetails = UserDetails();
  String versionNumer = '';
  bool expandFlag = false;

  //It will call to map initial State
  @override
  SideMenuStates get initialState => InitialState();

  //Here will map state according to event
  @override
  Stream<SideMenuStates> mapEventToState(SideMenuEvents event) async* {
    if (event is DisplayInitiallyEvent) {
      await _fetchUserDetails();
      await _getVersionNumberOfTheApp();
      yield InitialState();
    }
    //To expand SafetyIncidents sub-items
    if (event is SafetyIncidentsEvent) {
      yield SafetyIncidentState(selectedIndex: event.selectedIndex);
    }
    //To expanded items event
    if (event is ExpandEvent) {
      expandFlag = !event.expandFlag;
      yield ExpandState(
          expandFlag: expandFlag, selectedIndex: event.selectedIndex);
    }
    //To navigate to other screens
    if (event is NavigationEvent) {
      yield InitialState();
      yield NavigationState(selectedIndex: event.selectedIndex);
    }
    //Logout Event
    if (event is LogoutEvent) {
      await _logoutAction();
      yield LoggedOutState();
    }
  }

  //Fetch Loggin User Data
  Future<UserDetails> _fetchUserDetails() async {
    var userManager = UserManager();
    userDetails = await userManager.getData();
    return userDetails;
  }

  //Fetch Version of the app
  Future<String> _getVersionNumberOfTheApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionNumer = packageInfo.version;
    return versionNumer;
  }

  //Log out
  Future _logoutAction() async {
    final userManager = UserManager();
    final termsManager = TermsManager();
    await termsManager.deleteAll();
    //Deleting all data in User Table
    return await userManager.deleteAll();
  }
}
