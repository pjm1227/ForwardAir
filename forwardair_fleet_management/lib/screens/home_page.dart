import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import 'package:forwardair_fleet_management/blocs/events/sidemenu_events.dart';
import 'package:forwardair_fleet_management/blocs/states/sidemenu_state.dart';
import 'package:forwardair_fleet_management/screens/login_screen.dart';
import 'package:forwardair_fleet_management/screens/dashboard_page.dart';
import 'package:forwardair_fleet_management/screens/featurecomingsoon.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/customwidgets/expandablecontainer.dart';
import 'package:forwardair_fleet_management/blocs/sidemenu_bloc.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';

/*
  HomePage is the Holder of the DrawerMenu and Dashboard details.
*/

class HomePage extends StatefulWidget {
  HomePage();
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey _scaffold = GlobalKey();
  //SideMenu Bloc
  SideMenuBloc _sideMenuBloc = SideMenuBloc();


  //Selected index
  int _selectedIndex = 1;
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
    _sideMenuBloc.drawerMenuItems = [];
    _sideMenuBloc.expandedSafetyItems = [];
    _sideMenuBloc.dispose();
    super.dispose();
  }

  //To display versionNumber
  Widget _versionNumberWidget() {
    var versionString =
        _sideMenuBloc.versionNumer != null ? _sideMenuBloc.versionNumer : '';
    return TextWidget(
      text: Constants.TEXT_VERSION_NUMBER + versionString,
      colorText: AppColors.colorRed,
      textType: TextType.TEXT_XSMALL,
    );
  }

  //To display report list versionNumber
  _buildRowExpandedRows(int index) {
    return Container(
      padding: EdgeInsets.only(left: 47),
      height: 40,
      child: Material(
        color: Colors.transparent,
        child: new ListTile(
          leading: Container(
            child: TextWidget(
              text: _sideMenuBloc.expandedSafetyItems[index][Constants.TEXT_SAFETY_AND_INCIDENT_EXPENDED_TITLE],
              textType: TextType.TEXT_SMALL,
              isBold: _expandedListIndex == index ? true : false,
              colorText: AppColors.colorBlack,
            ),
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
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _sideMenuBloc.dispatch(
                    ExpandEvent(expandFlag: expandFlag, selectedIndex: index));
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
                                        ? (_sideMenuBloc.drawerMenuItems[index][
                                            Constants
                                                .TEXT_SELECTED_ICON]) //_sideMenuBloc._selectedItemImages[index]
                                        : (_sideMenuBloc.drawerMenuItems[index][
                                            Constants
                                                .TEXT_UNSELECTED_ICON]) // _imageNames[index]
                                    )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: TextWidget(
                              text: _sideMenuBloc.drawerMenuItems[index]
                                  [Constants.TEXT_SIDE_MENU_TITLE], //[index],
                              colorText: AppColors.colorBlack,
                              textType: TextType.TEXT_MEDIUM,
                            ),
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
            expandedHeight: _sideMenuBloc.expandedSafetyItems.length == 1 ? 50 : 130,
            expanded: expandFlag,
            child: new ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return new Container(child: _buildRowExpandedRows(index));
              },
              itemCount: _sideMenuBloc.expandedSafetyItems.length,
            ),
          ),
        ],
      ),
    );
  }

  _buildWidgetForDashboardAndCompanyNews(
    int index,
  ) {
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
                                    ? _sideMenuBloc.drawerMenuItems[index][Constants
                                        .TEXT_SELECTED_ICON] //_selectedItemImages[index]
                                    : _sideMenuBloc.drawerMenuItems[index][Constants
                                        .TEXT_UNSELECTED_ICON] //_imageNames[index]
                                )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: TextWidget(
                            text: _sideMenuBloc.drawerMenuItems[index][Constants.TEXT_SIDE_MENU_TITLE],  //_drawerMenuItems[index],
                            colorText: AppColors.colorBlack,
                            textType: TextType.TEXT_MEDIUM,
                          )),
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

  //To Display the items inside ListView
  Widget _buildRow(int index) {

    final _menuTitle = _sideMenuBloc.drawerMenuItems[index][Constants.TEXT_SIDE_MENU_TITLE];

    if (_menuTitle == Constants.TEXT_SAFETY_INCIDENTS) {
      return _safetyAndAccidentsExpandableWidget(index);
    }

    else if (_menuTitle == Constants.TEXT_DASHBOARD || _menuTitle == Constants.TEXT_COMPANY_NEWS) {
      return _buildWidgetForDashboardAndCompanyNews(index);
    }

    else if (_menuTitle == Constants.TEXT_MODULES) {
      return _moduleWidget(index);
    }

    else if (_menuTitle == Constants.TEXT_FLEET_TRACKER ||
             _menuTitle == Constants.TEXT_SETTLEMENTS ||
             _menuTitle == Constants.TEXT_NOTIFICATION_OF_UNAVALIABILITY ||
             _menuTitle == Constants.TEXT_PROFILE ||
             _menuTitle == Constants.TEXT_SETTINGS ||
             _menuTitle == Constants.TEXT_LOGOUT) {
      return _otherMenuWidget(index);
    } else {
      return Container();
    }
  }

  Widget _moduleWidget(int index) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 13),
          height: 45,
          color: Colors.white,
          child: ListTile(
            title: TextWidget(
              text: _sideMenuBloc.drawerMenuItems[index][Constants.TEXT_SIDE_MENU_TITLE],//_drawerMenuItems[index],
              colorText: AppColors.colorGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _otherMenuWidget(int index) {
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
                            ? _sideMenuBloc.drawerMenuItems[index][Constants.TEXT_SELECTED_ICON] //_selectedItemImages[index]
                            :  _sideMenuBloc.drawerMenuItems[index][Constants.TEXT_UNSELECTED_ICON])), //_imageNames[index])),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: TextWidget(
                        text: _sideMenuBloc.drawerMenuItems[index][Constants.TEXT_SIDE_MENU_TITLE],//_drawerMenuItems[index],
                        colorText: AppColors.colorBlack,
                        textType: TextType.TEXT_MEDIUM,
                      )),
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

  //Scaffold Widget
  Widget _scaffoldWidget() {
    return Scaffold(
      key: _scaffold,
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: false,
        //AppBar Title
        title: TextWidget(
          text: Constants.TEXT_DASHBOARD,
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
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
                  if (state is LoggedOutState) {
                    showAlertDialog(_scaffold.currentContext);
                  }

                  //Navigation option
                  if (state is NavigationState) {
                    final index =
                        state.selectedIndex == null ? 0 : state.selectedIndex;
                    String _menuTitle = _sideMenuBloc.drawerMenuItems[index][Constants.TEXT_SIDE_MENU_TITLE];
                    switch (_menuTitle) { //(index) {
                      case Constants.TEXT_SAFETY_INCIDENTS:
                        break;
                      case Constants.TEXT_DASHBOARD:
                        {
                          Navigator.pop(context);
                        }
                        break;
                      case Constants.TEXT_LOGOUT: //11:
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
                    if (state is LoggedOutState) {
                      _selectedIndex = 1;
                    }
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
                              padding: const EdgeInsets.only(top: 15.0),
                              child: ListTile(
                                //Profile Image
                                leading: SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                                //User Name Text
                                title: Container(
                                    padding: EdgeInsets.only(bottom: 10, right:8),
                                    child: TextWidget(
                                      text: _sideMenuBloc.userDetails != null
                                          ? _sideMenuBloc
                                                      .userDetails.fullName ==
                                                  null
                                              ? 'User Name'
                                              : _sideMenuBloc
                                                  .userDetails.fullName
                                          : 'User Name',
                                      isBold: true,
                                      colorText: AppColors.colorWhite,
                                      textType: TextType.TEXT_SMALL,
                                    )),
                                //User Role Text
                                subtitle: Container(
                                  child: TextWidget(
                                    text: _sideMenuBloc.userDetails != null
                                        ? _sideMenuBloc.userDetails.usertype ==
                                                null
                                            ? ''
                                            : _sideMenuBloc
                                                .convertUserTypeToText(
                                                    _sideMenuBloc
                                                        .userDetails.usertype)
                                        : '',
                                    colorText: AppColors.colorWhite,
                                    textType: TextType.TEXT_SMALL,
                                  ),
                                ),
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
                          itemCount: _sideMenuBloc.drawerMenuItems.length,
                        ),
                      ],
                    );
                  },
                ),
              ))),
    );
  }

  //This return UI of Drawer Menu and Dasboard
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _scaffoldWidget();
    } else {
      return SafeArea(
        child: _scaffoldWidget(),
      );
    }
  }

  showAlertDialog(BuildContext context) {
    Navigator.of(context).pop();
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () async {
        await _sideMenuBloc.logoutAction();
        navigateToLginPage();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to Logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // To navigate to the Login screen
  void navigateToLginPage() {
    Navigator.pop(context, true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // To navigate to the Feature Coming soon screen
  void navigateToFeatureComingSoonPage() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade, child: FeaturesComingSoonPage()));
  }
}
