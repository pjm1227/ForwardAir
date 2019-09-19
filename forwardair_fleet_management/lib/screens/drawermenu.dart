import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:forwardair_fleet_management/blocs/events/sidemenu_events.dart';
import 'package:forwardair_fleet_management/blocs/states/sidemenu_state.dart';
import 'package:forwardair_fleet_management/screens/login_screen.dart';
import 'package:forwardair_fleet_management/screens/dashboard_page.dart';
import 'package:forwardair_fleet_management/screens/featurecomingsoon.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/customwidgets/expandablecontainer.dart';
import 'package:forwardair_fleet_management/blocs/sidemenu_bloc.dart';

/*
  HomePage is the Holder of the DrawerMenu and Dashboard details.
*/

class HomePage extends StatefulWidget {
  HomePage();
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //SideMenu Bloc
  SideMenuBloc _sideMenuBloc = SideMenuBloc();
  //Text Items in drawer Menu
  List _drawerMenuItems = [
    Constants.TEXT_SAFETY_INCIDENTS,
    Constants.TEXT_DASHBOARD,
    // Constants.TEXT_NOTIFICATION,
    Constants.TEXT_MODULES,
    Constants.TEXT_FLEET_TRACKER,
    Constants.TEXT_SETTLEMENTS,
    //  Constants.TEXT_REFERRAL_PROGRAM,
    Constants.TEXT_NOTIFICATION_OF_UNAVALIABILITY,
    Constants.TEXT_COMPANY_NEWS,
    Constants.TEXT_PROFILE,
    Constants.TEXT_SETTINGS,
    Constants.TEXT_LOGOUT
  ];
  //Image Items in drawer Menu
  List _imageNames = [
    'images/ic_safety&incident.png',
    'images/ic_dashboard.png',
    //'images/ic_notification.png',
    'images/ic_notification.png',
    'images/ic_fleet_tracker.png',
    'images/ic_settlement.png',
    //'images/ic_referral_program.png',
    'images/ic_notification_unavailability.png',
    'images/ic_company_news.png',
    'images/ic_profile.png',
    'images/ic_settings.png',
    'images/ic_logout.png'
  ];
  //Selected Image Items in drawer Menu
  List _selectedItemImages = [
    'images/ic_safety&incident_active.png',
    'images/ic_dashboard_active.png',
    'images/ic_notification.png',
    //'images/ic_notification_active.png',
    'images/ic_fleet_tracker_active.png',
    'images/ic_settings_active.png',
    //'images/ic_referral_program_active.png',
    'images/ic_notification_unavailability_active.png',
    'images/ic_company_news_active.png',
    'images/ic_profile_active.png',
    'images/ic_settings_active.png',
    'images/ic_logout_active.png'
  ];
  //Selected index
  int _selectedIndex = 0;
  //Expand Flag
  bool expandFlag = false;
  //Expanded List index
  int _expandedListIndex = 0;

  //Initial State
  @override
  initState() {
    super.initState();
    _sideMenuBloc.dispatch(DisplayInitiallyEvent());
  }

  //To Dispose the SideMenu Bloc
  @override
  void dispose() {
    _sideMenuBloc.dispose();
    super.dispose();
  }

  //To display versionNumber
  Text _versionNumberWidget() {
    return Text(
      Constants.TEXT_VERSION_NUMBER + _sideMenuBloc.versionNumer,
      style: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: Constants.FONT_FAMILY_ROBOTO,
          fontSize: 10,
          color: AppColors.colorRed),
    );
  }

  //To display report list versionNumber
  _buildRowExpandedRows(int index) {
    String title = '';
    switch (index) {
      case 0:
        title = Constants.TEXT_REPORT_ACCIDENT;
        break;
      case 1:
        title = Constants.TEXT_REPORT_BREAKDOWN;
        break;
      case 2:
        title = Constants.TEXT_VIEW_HISTORY;
        break;
    }
    return Container(
      padding: EdgeInsets.only(left: 47),
      height: 40,
      child: Material(
        color: Colors.transparent,
        child: new ListTile(
          leading: Container(
            child: Text(title,
                style: new TextStyle(
                  fontSize: 15.0,
                  fontWeight: _expandedListIndex == index
                      ? FontWeight.w600
                      : FontWeight.normal,
                  fontFamily: Constants.FONT_FAMILY_ROBOTO,
                  color: Colors.black,
                )),
          ),
          onTap: () {
            _sideMenuBloc.dispatch(SafetyIncidentsEvent(selectedIndex: index));
          },
        ),
      ),
    );
  }

  //To display SAFETY AND ACCIDENT widget
  Widget _safetyAndAccidentsExpandableWidget(int index) {
    final _titleStyle = TextStyle(
        fontFamily: Constants.FONT_FAMILY_ROBOTO,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.colorBlack);
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _sideMenuBloc.dispatch(ExpandEvent(expandFlag: expandFlag));
              },
              child: Container(
                height: 45,
                child: Container(
                  color: _selectedIndex == index
                      ? AppColors.redColorWithTwentyOpacity
                      : Colors.white,
                  child: Material(
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 5,
                            color: _selectedIndex != null &&
                                    _selectedIndex == index
                                ? Colors.red
                                : Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: SizedBox(
                                width: 24,
                                height: 24,
                                child: Image.asset(_selectedIndex == index
                                    ? _selectedItemImages[index]
                                    : _imageNames[index])),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(_drawerMenuItems[index],
                                style: _titleStyle),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          ExpandableContainer(
            expanded: expandFlag,
            child: new ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return new Container(child: _buildRowExpandedRows(index));
              },
              itemCount: 3,
            ),
          ),
        ],
      ),
    );
  }

  //To Display the items inside ListView
  Widget _buildRow(int index) {
    final _titleStyle = TextStyle(
        fontFamily: Constants.FONT_FAMILY_ROBOTO,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.colorBlack);
    final _moduleTitleStyle = TextStyle(
        fontFamily: Constants.FONT_FAMILY_ROBOTO,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.colorGrey);
    //For Safety and Incidents
    if (index == 0) {
      return _safetyAndAccidentsExpandableWidget(index);
    }
    //For Modules
    else if (index == 2) {
      //3) {
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 13),
            height: 45,
            color: Colors.white,
            child: ListTile(
              title: Text(
                _drawerMenuItems[index],
                style: _moduleTitleStyle,
              ),
            ),
          ),
        ],
      );
    }
    //Release 1: For Notification and Company News
    //Recent: For Dashboard and Company News
    else if (index == 1 || index == 6) {
      //(index == 2 || index == 8) {
      return Column(
        children: <Widget>[
          Container(
            height: 45,
            color: _selectedIndex != null && _selectedIndex == index
                ? AppColors.redColorWithTwentyOpacity
                : Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200])),
              ),
              child: Material(
                child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 5,
                          color:
                              _selectedIndex != null && _selectedIndex == index
                                  ? AppColors.colorRed
                                  : Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: SizedBox(
                              width: 24,
                              height: 24,
                              child: Image.asset(_selectedIndex == index
                                  ? _selectedItemImages[index]
                                  : _imageNames[index])),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child:
                              Text(_drawerMenuItems[index], style: _titleStyle),
                        ),
                      ],
                    ),
                    onTap: () {
                      expandFlag = false;
                      _expandedListIndex = 0;
                      _sideMenuBloc.dispatch(NavigationEvent(
                          selectedIndex: index, expandFlag: false));
                    }),
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      );
    }
    //For the other items
    else {
      return Container(
        height: 45,
        child: Container(
          color: _selectedIndex != null && _selectedIndex == index
              ? AppColors.redColorWithTwentyOpacity
              : Colors.white,
          child: Material(
            child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 5,
                      color: _selectedIndex != null && _selectedIndex == index
                          ? AppColors.colorRed
                          : Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset(_selectedIndex == index
                              ? _selectedItemImages[index]
                              : _imageNames[index])),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(_drawerMenuItems[index], style: _titleStyle),
                    ),
                  ],
                ),
                onTap: () {
                  expandFlag = false;
                  _expandedListIndex = 0;
                  _sideMenuBloc.dispatch(
                      NavigationEvent(selectedIndex: index, expandFlag: false));
                }),
            color: Colors.transparent,
          ),
        ),
      );
    }
  }

  //This return UI of Drawer Menu and Dasboard
  @override
  Widget build(BuildContext context) {
    //To provide text style to the appBarText
    final _appBarStyle = TextStyle(
        fontFamily: Constants.FONT_FAMILY_ROBOTO,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white);

    return new Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: false,
        title: new Text(
          Constants.TEXT_DASHBOARD,
          style: _appBarStyle,
        ),
        backgroundColor: AppColors.colorAppBar,
        actions: <Widget>[
          //To display the notification Icon
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('images/ic_notfication_white.png')),
            ),
            onTap: () {
              navigateToFeatureComingSoonPage();
            },
          ),
//          //To display the more Icon
//          InkWell(
//            child: SizedBox(
//                width: 30,
//                height: 30,
//                child: Image.asset('images/ic_more.png')),
//            onTap: () {
//              navigateToFeatureComingSoonPage();
//            },
//          ),
        ],
      ),
      //To Display the Dashboard
      body: DashboardPage(),
      //To Display the DrawerMenu
      drawer: new Drawer(
          child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child:
                  //BlocListener to check condition according to state
                  //Basically it used to navigate to page
                  BlocListener<SideMenuBloc, SideMenuStates>(
                bloc: _sideMenuBloc,
                condition: (previousState, currentState) {
                  return true;
                },
                listener: (context, state) {
                  //LoggedOut state
                  if (state is LoggedOutState) {
                    navigateToLginPage();
                  }
                  //Navigation option
                  else if (state is NavigationState) {
                    final index =
                        state.selectedIndex == null ? 0 : state.selectedIndex;
                    switch (index) {
                      case 0:
                        break;
                      case 1:
                        {
                          Navigator.pop(context);
                        }
                        break;
                      case 9: //11:
                        {
                          //Log out
                          _sideMenuBloc.dispatch(LogoutEvent());
                        }
                        break;
                      default:
                        {
                          navigateToFeatureComingSoonPage();
                        }
                        break;
                    }
                  }
                },
                //BlocBuilder - Used to return a widget
                child: BlocBuilder<SideMenuBloc, SideMenuStates>(
                  bloc: _sideMenuBloc,
                  condition: (previousState, currentState) {
                    return true;
                  },
                  builder: (context, state) {
                    //Expanded Items inside Safety Incidents
                    if (state is ExpandState) {
                      _selectedIndex =
                          state.selectedIndex == null ? 0 : state.selectedIndex;
                      expandFlag =
                          state.expandFlag == null ? false : state.expandFlag;
                    }
                    //Navigateion State
                    if (state is NavigationState) {
                      _selectedIndex =
                          state.selectedIndex == null ? 0 : state.selectedIndex;
                    }
                    //To Expand Safety Incidents Items
                    if (state is SafetyIncidentState) {
                      _expandedListIndex =
                          state.selectedIndex == null ? 0 : state.selectedIndex;
                    }
                    //Returns Side Menu Options
                    return ListView(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            //Background Image of the Top Widget
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("images/img_bg_top_login.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            //Version Number
                            Positioned(
                                bottom: 0,
                                right: 10,
                                child: _versionNumberWidget()),

                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ListTile(
                                //Profile Image
                                leading: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: new CircleAvatar(
                                      child: Image.asset(
                                          'images/ic_profile_pic.png')),
                                ),
                                //User Name Text
                                title: Container(
                                    padding: EdgeInsets.only(top: 15),
                                    height: 40,
                                    child: Text(
                                      _sideMenuBloc.userDetails.fullName == null
                                          ? 'User Name'
                                          : _sideMenuBloc.userDetails.fullName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          color: Colors.white),
                                    )),
                                //User Role Text
                                subtitle: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      Constants.TEXT_FLEET_OWNER,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontFamily:
                                              Constants.FONT_FAMILY_ROBOTO,
                                          fontSize: 16,
                                          color: Colors.white),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        //Holder of the DrawerMenu
                        ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => _buildRow(index),
                          itemCount: _drawerMenuItems.length,
                        ),
                      ],
                    );
                  },
                ),
              ))),
    );
  }

  // To navigate to the Login screen
  void navigateToLginPage() {
    Navigator.pop(context, true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );

//    Navigator.push(
//        context,
//        PageTransition(
//            type: PageTransitionType.fade, child: LoginPage()));
  }

  // To navigate to the Feature Coming soon screen
  void navigateToFeatureComingSoonPage() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade, child: FeaturesComingSoonPage()));
  }
}
