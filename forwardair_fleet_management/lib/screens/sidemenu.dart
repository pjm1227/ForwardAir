import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/components/appbar_widget.dart';
import 'package:forwardair_fleet_management/screens/Unavailability/unavailabilty_list_page.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import 'package:forwardair_fleet_management/screens/settlement_screen.dart';
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

import 'safetyandincidents/report_accident_screen.dart';
import 'safetyandincidents/report_breakdown_screen.dart';
import 'safetyandincidents/view_history_screen.dart';

GlobalKey<UnavailabilityListState> globalKey = GlobalKey();

class SideMenuPage extends StatefulWidget {
  @override
  _SideMenuPageState createState() => new _SideMenuPageState();
}

class _SideMenuPageState extends State<SideMenuPage> {
  GlobalKey _scaffold = GlobalKey();

  //SideMenu Bloc
  SideMenuBloc _sideMenuBloc = SideMenuBloc();

  //Selected index
  int _selectedIndex = 1;

  //Expand Flag
  bool expandFlag = false;

  //Expanded List index
  int _expandedListIndex = 0;

  //Menu Title
  String sideMenuTitle = Constants.TEXT_DASHBOARD;

  //Initial State
  @override
  initState() {
    super.initState();
    //Event to get side menu data
    _sideMenuBloc.dispatch(DisplayInitiallyEvent());
  }

  @override
  void dispose() {
    //To Dispose the drawerMenuItem
    _sideMenuBloc.drawerMenuItems = [];
    //To Dispose the Safety Item List
    _sideMenuBloc.expandedSafetyItems = [];
    //To Dispose the SideMenu Bloc
    _sideMenuBloc.dispose();
    super.dispose();
  }

  //This widget is to display app version
  Widget _versionNumberWidget() {
    //Fetch Version from Bloc
    var versionString =
        _sideMenuBloc.versionNumer != null ? _sideMenuBloc.versionNumer : '';
    //Display the Version
    return TextWidget(
      text: Constants.TEXT_VERSION_NUMBER + versionString,
      colorText: AppColors.colorRed,
      textType: TextType.TEXT_XSMALL,
    );
  }

  //This widget to display Safety Incident List Items
  _buildRowExpandedRows(int index) {
    return Container(
      padding: EdgeInsets.only(left: 47),
      height: 40,
      child: Material(
        color: Colors.transparent,
        child: new ListTile(
          leading: Container(
            child:
                //This displays the View History, Safety Incident
                // Reporting and Breakdown Reporting Widget.
                TextWidget(
              text: _sideMenuBloc.expandedSafetyItems[index]
                  [Constants.TEXT_SAFETY_AND_INCIDENT_EXPENDED_TITLE],
              textType: TextType.TEXT_SMALL,
              isBold: _expandedListIndex == index ? true : false,
              colorText: AppColors.colorBlack,
            ),
          ),
          onTap: () {
            //To update the Expanded Row based on the user tap event.
            _sideMenuBloc.dispatch(SafetyIncidentsEvent(
                selectedIndex: index, expandFlag: expandFlag));
          },
        ),
      ),
    );
  }

  //This widget displays SAFETY AND ACCIDENT
  Widget _safetyAndAccidentsExpandableWidget(int index) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                //Expand and Collapse Event
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
                          //This widget display left side selected/unselected color
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
                                //This widget display selected/unselected images
                                child: Image.asset(_selectedIndex == index
                                    ? (_sideMenuBloc.drawerMenuItems[index]
                                        [Constants.TEXT_SELECTED_ICON])
                                    : (_sideMenuBloc.drawerMenuItems[index]
                                        [Constants.TEXT_UNSELECTED_ICON]))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child:
                                //To display the Side Menu Title
                                TextWidget(
                              text: _sideMenuBloc.drawerMenuItems[index]
                                  [Constants.TEXT_SIDE_MENU_TITLE],
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
          //To display the Expandable Widget for Safety Incidents
          ExpandableContainer(
            expandedHeight:
                _sideMenuBloc.expandedSafetyItems.length == 1 ? 50 : 130,
            expanded: expandFlag,
            child: new ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                //This display the Items in Safety Incident
                return new Container(child: _buildRowExpandedRows(index));
              },
              itemCount: _sideMenuBloc.expandedSafetyItems.length,
            ),
          ),
        ],
      ),
    );
  }

  //This widget displays the Dashboard and Company News
  _buildWidgetForDashboardAndCompanyNews(int index) {
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
                      //This display the left side color based on the Select/UnSelect of the Widget.
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
                            //This display the image based on the Select/UnSelect of the Widget.
                            child: Image.asset(_selectedIndex == index
                                ? _sideMenuBloc.drawerMenuItems[index]
                                    [Constants.TEXT_SELECTED_ICON]
                                : _sideMenuBloc.drawerMenuItems[index]
                                    [Constants.TEXT_UNSELECTED_ICON])),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child:
                              //This display the Title of the Side Menu Widget.
                              TextWidget(
                            text: _sideMenuBloc.drawerMenuItems[index]
                                [Constants.TEXT_SIDE_MENU_TITLE],
                            colorText: AppColors.colorBlack,
                            textType: TextType.TEXT_MEDIUM,
                          )),
                    ],
                  ),
                  onTap: () {
                    expandFlag = false;
                    _expandedListIndex = 0;
                    // To navigate to dashboard/Company News Page
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

  //This widget displays all items in SideMenu.
  Widget _buildRow(int index) {
    //Fetching Side Menu Title from Bloc
    final _menuTitle =
        _sideMenuBloc.drawerMenuItems[index][Constants.TEXT_SIDE_MENU_TITLE];
    if (_menuTitle == Constants.TEXT_SAFETY_INCIDENTS) {
      //This widget displays SAFETY INCIDENTS.
      return _safetyAndAccidentsExpandableWidget(index);
    } else if (_menuTitle == Constants.TEXT_DASHBOARD ||
        _menuTitle == Constants.TEXT_COMPANY_NEWS) {
      //This widget displays Dashboard and Company News.
      return _buildWidgetForDashboardAndCompanyNews(index);
    } else if (_menuTitle == Constants.TEXT_MODULES) {
      //This widget displays Module.
      return _moduleWidget(index);
    } else if (_menuTitle == Constants.TEXT_FLEET_TRACKER ||
        _menuTitle == Constants.TEXT_SETTLEMENTS ||
        _menuTitle == Constants.TEXT_NOTIFICATION_OF_UNAVALIABILITY ||
        _menuTitle == Constants.TEXT_PROFILE ||
        _menuTitle == Constants.TEXT_SETTINGS ||
        _menuTitle == Constants.TEXT_LOGOUT) {
      /*This Widget displays a Fleet Tracker, Settlements,
       Unavailability, Profile, Settings, Logout */
      return _otherMenuWidget(index);
    } else {
      //Displays Empty Container. This is for safer case.
      return Container();
    }
  }

  //This widget displays Module.
  Widget _moduleWidget(int index) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 13),
          height: 45,
          color: Colors.white,
          child: ListTile(
            title: TextWidget(
              text: _sideMenuBloc.drawerMenuItems[index]
                  [Constants.TEXT_SIDE_MENU_TITLE],
              colorText: AppColors.colorGrey,
            ),
          ),
        ),
      ],
    );
  }

  /*This Widget displays a Fleet Tracker, Settlements,
       Unavailability, Profile, Settings, Logout */
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
                  //This display the left side color based on the Select/UnSelect of the Widget.
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
                        //This display the image based on the Select/UnSelect of the Widget
                        child: Image.asset(_selectedIndex == index
                            ? _sideMenuBloc.drawerMenuItems[index]
                                [Constants.TEXT_SELECTED_ICON]
                            : _sideMenuBloc.drawerMenuItems[index]
                                [Constants.TEXT_UNSELECTED_ICON])),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child:
                          //This display the Title of the Widget
                          TextWidget(
                        text: _sideMenuBloc.drawerMenuItems[index]
                            [Constants.TEXT_SIDE_MENU_TITLE],
                        colorText: AppColors.colorBlack,
                        textType: TextType.TEXT_MEDIUM,
                      )),
                ],
              ),
              onTap: () {
                expandFlag = false;
                _expandedListIndex = 0;
                if (index == _sideMenuBloc.drawerMenuItems.length - 1) {
                  _sideMenuBloc.dispatch(TappedOnLogoutEvent());
                } else {
                  _sideMenuBloc.dispatch(
                      NavigationEvent(selectedIndex: index, expandFlag: false));
                }
              }),
          color: Colors.transparent,
        ),
      ),
    );
  }

  //App Bar Action Items
  Widget _appBarActionWidget() {
    switch (sideMenuTitle) {
      case Constants.TEXT_DASHBOARD:
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('images/ic_notfication_white.png')),
          ),
          onTap: () {
            //To navigate to new feature page.
            navigateToFeatureComingSoonPage();
          },
        );
        break;
      case Constants.TEXT_NOTIFICATION_OF_UNAVALIABILITY:
        return InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.calendar_today,
                color: AppColors.colorWhite,
                size: 22,
              ),
            ),
            onTap: () {
              //To navigate to calendar page.
              globalKey.currentState.openLeaveCalendarBasedOnTheTabBarItem();
            });
        break;
      default:
        return Container();
        break;
    }
  }

  _appBarWidget(String title) {
    return BaseAppBar(
      height: AppBar().preferredSize.height,
      //This widget displays the AppBar Title
      title: title == Constants.TEXT_VIEW_HISTORY
          ? 'Safety & Incident History'
          : title,
      widgets: <Widget>[
        //To display the notification Icon widget
        _appBarActionWidget()
      ],
    );
  }

  //To navigate to other pages
  _navigationOptions() {
    switch (sideMenuTitle) {
      case Constants.TEXT_DASHBOARD:
        return DashboardPage();
        break;
      case Constants.TEXT_SETTLEMENTS:
       // return SettlementPage();
        return FeaturesComingSoonPage(false);
        break;
      case Constants.TEXT_NOTIFICATION_OF_UNAVALIABILITY:
      /*  return UnavailabilityListPage(
          key: globalKey,
          usertype: _sideMenuBloc.userDetails != null
              ? _sideMenuBloc.userDetails.usertype != null
                  ? _sideMenuBloc.userDetails.usertype
                  : ''
              : '',
        );*/
        return FeaturesComingSoonPage(false);
        break;
      case Constants.TEXT_LOGOUT:
        break;
      case Constants.TEXT_VIEW_HISTORY:
        return FeaturesComingSoonPage(false);
      //  return ViewHistoryPage();
      case Constants.TEXT_REPORT_ACCIDENT:
      return FeaturesComingSoonPage(false);
        //return ReportAccidentPage();
      case Constants.TEXT_REPORT_BREAKDOWN:
       // return ReportBreakdownPage();
      return FeaturesComingSoonPage(false);
      default:
        return FeaturesComingSoonPage(false);
        break;
    }
  }

  //Main Widget of Side Menu
  Widget _sideMenuWidget() {
    return BlocListener(
        listener: (context, state) {
          if (state is SafetyIncidentState) {
            //To get SafetyIncident Expanded List Item Title.
            String _safetyMenuTitle =
                _sideMenuBloc.expandedSafetyItems[state.selectedIndex]
                    [Constants.TEXT_SAFETY_AND_INCIDENT_EXPENDED_TITLE];
            sideMenuTitle = _safetyMenuTitle;
            Navigator.pop(context);
          }
          //To Display the Logout Alert Dialogue.
          if (state is LoggedOutState) {
            showAlertDialog(_scaffold.currentContext);
          }
          //To Clear all items in the local db.
          if (state is TappedOnLogoutState) {
            _sideMenuBloc.dispatch(LogoutEvent(selectedIndex: _selectedIndex));
          }
          //To Navigate to corresponding pages.
          if (state is NavigationState) {
            // To update selected rows widget
            final index = state.selectedIndex == null ? 0 : state.selectedIndex;
            //To get the selected Side Menu Title
            String _menuTitle = _sideMenuBloc.drawerMenuItems[index]
                [Constants.TEXT_SIDE_MENU_TITLE];
            sideMenuTitle = _menuTitle;
            switch (_menuTitle) {
              case Constants.TEXT_LOGOUT:
                break;
              default:
                Navigator.pop(context);
                break;
            }
          }
        },
        bloc: _sideMenuBloc,
        child: BlocBuilder<SideMenuBloc, SideMenuStates>(
            bloc: _sideMenuBloc,
            condition: (previousState, currentState) {
              return true;
            },
            builder: (context, state) {
              print(state);
              if (state is ExpandState) {
                _selectedIndex =
                    state.selectedIndex == null ? 0 : state.selectedIndex;
                expandFlag =
                    state.expandFlag == null ? false : state.expandFlag;
              }
              //To update selected widget in Navigation State
              if (state is NavigationState) {
                _selectedIndex =
                    state.selectedIndex == null ? 0 : state.selectedIndex;
              }
              //To update ui in Safety Incidents List
              if (state is SafetyIncidentState) {
                _expandedListIndex =
                    state.selectedIndex == null ? 0 : state.selectedIndex;
              }
              return Scaffold(
                  key: _scaffold,
                  appBar: _appBarWidget(sideMenuTitle),
                  body: _navigationOptions(),
                  drawer: new Drawer(
                      child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: ListView(
                      padding: Platform.isIOS ? EdgeInsets.all(0.0) : null,
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
                            //This widget displays App Version
                            Positioned(
                                bottom: 0,
                                right: 10,
                                child: _versionNumberWidget()),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15,
                                  top: Platform.isIOS
                                      ? MediaQuery.of(context).padding.top
                                      : 15,
                                  right: 8),
                              child: ListTile(
                                //This widget displays the UserName
                                title: Container(
                                    padding: EdgeInsets.only(bottom: 5, top: 8),
                                    child: TextWidget(
                                      text: _sideMenuBloc.userDetails != null
                                          ? _sideMenuBloc
                                                      .userDetails.fullName ==
                                                  null
                                              ? 'N/A'
                                              : _sideMenuBloc
                                                  .userDetails.fullName
                                          : 'N/A',
                                      isBold: true,
                                      colorText: AppColors.colorWhite,
                                      textType: TextType.TEXT_SMALL,
                                    )),
                                subtitle: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        //This widget displays UserRole
                                        TextWidget(
                                          text: _sideMenuBloc.userDetails !=
                                                  null
                                              ? _sideMenuBloc.userDetails
                                                          .usertype ==
                                                      null
                                                  ? 'N/A'
                                                  : _sideMenuBloc
                                                      .convertUserTypeToText(
                                                          _sideMenuBloc
                                                              .userDetails
                                                              .usertype)
                                              : 'N/A',
                                          colorText: AppColors.colorWhite,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      child: Row(
                                        children: <Widget>[
                                          //This widget displays ContractorCode
                                          TextWidget(
                                            text: _sideMenuBloc.userDetails !=
                                                    null
                                                ? _sideMenuBloc.userDetails
                                                            .contractorcd ==
                                                        null
                                                    ? 'N/A'
                                                    : _sideMenuBloc.userDetails
                                                        .contractorcd
                                                : 'N/A',
                                            colorText: AppColors.colorWhite,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        //This display the Holder of the DrawerMenu
                        ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => _buildRow(index),
                          itemCount: _sideMenuBloc.drawerMenuItems.length,
                        ),
                      ],
                    ),
                  )));
            }));
  }

  //This return UI of Drawer Menu and Dashboard
  @override
  Widget build(BuildContext context) {
    //Checking condition for Platforms to include Safe Area.
    if (Platform.isIOS) {
      return _sideMenuWidget();
    } else {
      return SafeArea(
        child: _sideMenuWidget(),
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
        //To clear all data in local db.
        await _sideMenuBloc.logoutAction();
        //Then to navigate to Login Page.
        navigateToLoginPage();
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
    // show the alert dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // To navigate to the Login screen
  void navigateToLoginPage() {
    //To remove Alert Dialogue
    Navigator.pop(context, true);
    //To Navigate To Login Screen.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage()),
      ModalRoute.withName('/login'),
    );
  }

  //To navigate to the Feature Coming soon page.
  void navigateToFeatureComingSoonPage() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: FeaturesComingSoonPage(true)));
  }

  //this method is used to navigate as per passed widget name
  void navigateToNextWidget(Widget widgetName) {
    Navigator.push(context,
        PageTransition(type: PageTransitionType.fade, child: widgetName));
  }
}
