import 'package:bloc/bloc.dart';
import 'package:forwardair_fleet_management/databasemanager/dashboard_manager.dart';
import 'package:forwardair_fleet_management/databasemanager/user_role_manager.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:package_info/package_info.dart';

import 'package:forwardair_fleet_management/blocs/events/sidemenu_events.dart';
import 'package:forwardair_fleet_management/blocs/states/sidemenu_state.dart';
import 'package:forwardair_fleet_management/databasemanager/terms_manager.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/login_model.dart';

//SideMenu Bloc,All business logic for drawer menu
class SideMenuBloc extends Bloc<SideMenuEvents, SideMenuStates> {
  //User Details
  UserDetails userDetails = UserDetails();
  //User Role
  List<UserRole> userRoleList = [];
  //Version
  String versionNumer = '';
  //Expand Flag
  bool expandFlag = false;
  //Side Menu Items
  List<Map> drawerMenuItems = [];
  //Safety & Incidents Items
  List expandedSafetyItems = [];

  //It will call to map initial State
  @override
  SideMenuStates get initialState => FirstState();

  //Here will map state according to event
  @override
  Stream<SideMenuStates> mapEventToState(SideMenuEvents event) async* {
    if (event is DisplayInitiallyEvent) {
      await _fetchUserDetails();
      await _getVersionNumberOfTheApp();
      await _fetchUserRoles();
      //SideMenu Items
      drawerMenuItems = drawerMenuItemsBasedOnTheUserType();
      if (Utils.selectedIndexInSideMenu != null) {
        yield InitialState(selectedIndex: Utils.selectedIndexInSideMenu);
      } else {
        yield InitialState(selectedIndex: 1);
      }
    }
    if (event is TappedOnLogoutEvent) {
      yield TappedOnLogoutState();
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
      yield InitialState(selectedIndex: event.selectedIndex);
      Utils.selectedIndexInSideMenu = event.selectedIndex;
      yield NavigationState(selectedIndex: event.selectedIndex);
    }
    //Logout Event
    if (event is LogoutEvent) {
     // await _logoutAction();
      yield LoggedOutState(selectedIndex: event.selectedIndex);
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

  //Fetch Loggin User Data
  Future<List<UserRole>> _fetchUserRoles() async {
    var userManager = UserRoleManager();
    userRoleList = await userManager.getUserRoles();
    return userRoleList;
  }

  //Log out
  Future logoutAction() async {
    final userManager = UserManager();
    final termsManager = TermsManager();
    final userRoleManager = UserRoleManager();
    final dashboardManagaer = DashboardManager();
    //Deleting all data in Terms Table
    await termsManager.deleteAll();
    //Deleting all data in User Roles
    await userRoleManager.deleteUserRoles();
    //Delete Dashboard Data
    await dashboardManagaer.deleteAll();
    //Deleting all data in User Table
    return await userManager.deleteUserData();
  }

  String convertUserTypeToText(String userType) {
    String userTypeText = '';
    switch (userType) {
      case Constants.TEXT_FO_TYPE:
        userTypeText = Constants.TEXT_FLEET_OWNER;
        break;
      case Constants.TEXT_FOD_TYPE:
        userTypeText = Constants.TEXT_FLEET_OWNER_DRIVER;
        break;
      case Constants.TEXT_FD_TYPE:
        userTypeText = Constants.TEXT_DRIVER_FOR_FLEET;
        break;
      case Constants.TEXT_OO_TYPE:
        userTypeText = Constants.TEXT_OWNER_OPERATOR;
        break;
      case Constants.TEXT_CD_TYPE:
        userTypeText = Constants.TEXT_COMPANY_DRIVER;
        break;
    }
    return userTypeText;
  }

  List<Map> drawerMenuItemsBasedOnTheUserType() {
    Map<String, dynamic> safetyIncidents = {
      Constants.TEXT_ID: 1,
      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_SAFETY_INCIDENTS,
      Constants.TEXT_UNSELECTED_ICON: 'images/ic_safety&incident.png',
      Constants.TEXT_SELECTED_ICON: 'images/ic_safety&incident_active.png',
    };
    Map<String, dynamic> dashboard = {
      Constants.TEXT_ID: 2,
      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_DASHBOARD,
      Constants.TEXT_UNSELECTED_ICON: 'images/ic_dashboard.png',
      Constants.TEXT_SELECTED_ICON: 'images/ic_dashboard_active.png',
    };
    Map<String, dynamic> module = {
      Constants.TEXT_ID: 3,
      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_MODULES,
      Constants.TEXT_UNSELECTED_ICON: 'images/ic_notification.png',
      Constants.TEXT_SELECTED_ICON: 'images/ic_notification.png',
    };
    Map<String, dynamic> fleetTracker = {
      Constants.TEXT_ID: 4,
      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_FLEET_TRACKER,
      Constants.TEXT_UNSELECTED_ICON: 'images/ic_fleet_tracker.png',
      Constants.TEXT_SELECTED_ICON: 'images/ic_fleet_tracker_active.png',
    };
    Map<String, dynamic> settlements = {
      Constants.TEXT_ID: 5,
      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_SETTLEMENTS,
      Constants.TEXT_UNSELECTED_ICON: 'images/ic_settlement.png',
      Constants.TEXT_SELECTED_ICON: 'images/ic_settlement_active.png',
    };
    Map<String, dynamic> notificationOfUnavailabilty = {
      Constants.TEXT_ID: 6,
      Constants.TEXT_SIDE_MENU_TITLE:
          Constants.TEXT_NOTIFICATION_OF_UNAVALIABILITY,
      Constants.TEXT_UNSELECTED_ICON:
          'images/ic_notification_unavailability.png',
      Constants.TEXT_SELECTED_ICON:
          'images/ic_notification_unavailability_active.png',
    };
    Map<String, dynamic> companyNews = {
      Constants.TEXT_ID: 7,
      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_COMPANY_NEWS,
      Constants.TEXT_UNSELECTED_ICON: 'images/ic_company_news.png',
      Constants.TEXT_SELECTED_ICON: 'images/ic_company_news_active.png',
    };
    Map<String, dynamic> profile = {
      Constants.TEXT_ID: 8,
      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_PROFILE,
      Constants.TEXT_UNSELECTED_ICON: 'images/ic_profile.png',
      Constants.TEXT_SELECTED_ICON: 'images/ic_profile_active.png',
    };
    Map<String, dynamic> settings = {
      Constants.TEXT_ID: 9,
      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_SETTINGS,
      Constants.TEXT_UNSELECTED_ICON: 'images/ic_settings.png',
      Constants.TEXT_SELECTED_ICON: 'images/ic_settings_active.png',
    };
    Map<String, dynamic> logout = {
      Constants.TEXT_ID: 10,
      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_LOGOUT,
      Constants.TEXT_UNSELECTED_ICON: 'images/ic_logout.png',
      Constants.TEXT_SELECTED_ICON: 'images/ic_logout_active.png',
    };
    Map<String, dynamic> reportAccident = {
      Constants.TEXT_ID: 1,
      Constants.TEXT_SAFETY_AND_INCIDENT_EXPENDED_TITLE:
          Constants.TEXT_REPORT_ACCIDENT,
    };
    Map<String, dynamic> reportBreakdown = {
      Constants.TEXT_ID: 2,
      Constants.TEXT_SAFETY_AND_INCIDENT_EXPENDED_TITLE:
          Constants.TEXT_REPORT_BREAKDOWN,
    };
    Map<String, dynamic> viewHistory = {
      Constants.TEXT_ID: 3,
      Constants.TEXT_SAFETY_AND_INCIDENT_EXPENDED_TITLE:
          Constants.TEXT_VIEW_HISTORY,
    };

    /* currently API is sending Unique data. So here no need to do the duplicate removal.
    var duplicateRoleList = [];
    for (UserRole aRole in userRoleList) {
      duplicateRoleList.add(aRole.roleNm);
    }
    var uniqueRolesList = Set<String>.from(duplicateRoleList).toList();
     */
    drawerMenuItems.add(safetyIncidents);
    for (UserRole userRole in userRoleList) {
      final roleNm =  userRole.roleNm;
      if (roleNm == Constants.TEXT_DASHBOARD_ROLE) {
        drawerMenuItems.add(dashboard);
        drawerMenuItems.add(module);
      }
      if (roleNm == Constants.TEXT_FLEET_TRACKER) {
        drawerMenuItems.add(fleetTracker);
      } else if (roleNm == Constants.TEXT_SETTLEMENTS_VIEW_ROLE) {
        drawerMenuItems.add(settlements);
      } else if (roleNm == Constants.TEST_UNAVAILABILITY_VIEW_ROLE) {
        drawerMenuItems.add(notificationOfUnavailabilty);
      } else if (roleNm == Constants.TEXT_COMPANY_NEWS_ROLE) {
        drawerMenuItems.add(companyNews);
      }
      //Safety & Incidents Items
      else if (roleNm == Constants.TEXT_SAFETY_REPORTING_ROLE) {
        expandedSafetyItems.add(reportAccident);
      } else if (roleNm == Constants.TEXT_BREAKDOWN_REPORTING_ROLE) {
        expandedSafetyItems.add(reportBreakdown);
      } else if (roleNm == Constants.TEST_SAFETY_REPORT_VIEW_ROLE ||
          roleNm == Constants.TEXT_BREAKDOWN_REPORT_VIEW_ROLE) {
        if (!isItemExistInSafetyList()) {
          expandedSafetyItems.add(viewHistory);
        }
      }
    }
    expandedSafetyItems.sort((a, b) {
      int aData = a[Constants.TEXT_ID];
      int bData = b[Constants.TEXT_ID];
      return aData.compareTo(bData);
    });
    drawerMenuItems.add(profile);
    drawerMenuItems.add(settings);
    drawerMenuItems.add(logout);
    drawerMenuItems.sort((a, b) {
      int aData = a[Constants.TEXT_ID];
      int bData = b[Constants.TEXT_ID];
      return aData.compareTo(bData);
    });

//    for (int i = 0; i < drawerMenuItems.length; i++) {
//      drawerMenuItems = drawerMenuItems;
//    }
    return drawerMenuItems;
  }

  bool isItemExistInSafetyList() {
    var isExist = false;
    for (var aSafetyItem in expandedSafetyItems) {
      if (aSafetyItem[Constants.TEXT_SAFETY_AND_INCIDENT_EXPENDED_TITLE] ==
          Constants.TEXT_VIEW_HISTORY) {
        isExist = true;
      }
    }
    return isExist;
  }

//  List<Map> drawerMenuItemsBasedOnTheUserType() {
//    Map<String, String> safetyIncidents = {
//      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_SAFETY_INCIDENTS,
//      Constants.TEXT_UNSELECTED_ICON: 'images/ic_safety&incident.png',
//      Constants.TEXT_SELECTED_ICON: 'images/ic_safety&incident_active.png',
//    };
//    Map<String, String> dashboard = {
//      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_DASHBOARD,
//      Constants.TEXT_UNSELECTED_ICON: 'images/ic_dashboard.png',
//      Constants.TEXT_SELECTED_ICON: 'images/ic_dashboard_active.png',
//    };
//    Map<String, String> module = {
//      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_MODULES,
//      Constants.TEXT_UNSELECTED_ICON: 'images/ic_notification.png',
//      Constants.TEXT_SELECTED_ICON: 'images/ic_notification.png',
//    };
//    Map<String, String> fleetTracker = {
//      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_FLEET_TRACKER,
//      Constants.TEXT_UNSELECTED_ICON: 'images/ic_fleet_tracker.png',
//      Constants.TEXT_SELECTED_ICON: 'images/ic_fleet_tracker_active.png',
//    };
//    Map<String, String> settlements = {
//      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_SETTLEMENTS,
//      Constants.TEXT_UNSELECTED_ICON: 'images/ic_settlement.png',
//      Constants.TEXT_SELECTED_ICON: 'images/ic_settlement_active.png',
//    };
//    Map<String, String> notificationOfUnavailabilty = {
//      Constants.TEXT_SIDE_MENU_TITLE:
//          Constants.TEXT_NOTIFICATION_OF_UNAVALIABILITY,
//      Constants.TEXT_UNSELECTED_ICON:
//          'images/ic_notification_unavailability.png',
//      Constants.TEXT_SELECTED_ICON:
//          'images/ic_notification_unavailability_active.png.png',
//    };
//    Map<String, String> companyNews = {
//      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_COMPANY_NEWS,
//      Constants.TEXT_UNSELECTED_ICON: 'images/ic_company_news.png',
//      Constants.TEXT_SELECTED_ICON: 'images/ic_company_news_active.png',
//    };
//    Map<String, String> profile = {
//      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_PROFILE,
//      Constants.TEXT_UNSELECTED_ICON: 'images/ic_profile.png',
//      Constants.TEXT_SELECTED_ICON: 'images/ic_profile_active.png',
//    };
//    Map<String, String> settings = {
//      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_SETTINGS,
//      Constants.TEXT_UNSELECTED_ICON: 'images/ic_settings.png',
//      Constants.TEXT_SELECTED_ICON: 'images/ic_settings_active.png',
//    };
//    Map<String, String> logout = {
//      Constants.TEXT_SIDE_MENU_TITLE: Constants.TEXT_LOGOUT,
//      Constants.TEXT_UNSELECTED_ICON: 'images/ic_logout.png',
//      Constants.TEXT_SELECTED_ICON: 'images/ic_logout_active.png',
//    };
//
//    //These three items are common to all role type
//    drawerMenuItems = [safetyIncidents, dashboard, module];
//
//    //For both FO & FOD
//    if (userDetails.usertype == Constants.TEXT_FO_TYPE ||
//        userDetails.usertype == Constants.TEXT_FOD_TYPE) {
//      drawerMenuItems.add(fleetTracker);
//      drawerMenuItems.add(settlements);
//      drawerMenuItems.add(notificationOfUnavailabilty);
//      drawerMenuItems.add(companyNews);
//    }
//    //For OO
//    else if (userDetails.usertype == Constants.TEXT_OO_TYPE) {
//      drawerMenuItems.add(settlements);
//      drawerMenuItems.add(notificationOfUnavailabilty);
//      drawerMenuItems.add(companyNews);
//    }
//    //For FD
//    else if (userDetails.usertype == Constants.TEXT_FD_TYPE) {
//      drawerMenuItems.add(notificationOfUnavailabilty);
//      drawerMenuItems.add(companyNews);
//    }
//    //For CD
//    else {
//      drawerMenuItems.add(companyNews);
//    }
//    //Below item are common to all role type
//    drawerMenuItems.add(profile);
//    drawerMenuItems.add(settings);
//    drawerMenuItems.add(logout);
//    return drawerMenuItems;
//  }
}
