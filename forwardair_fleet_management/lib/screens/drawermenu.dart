import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/blocs/barrels/login.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/main.dart';
import 'package:forwardair_fleet_management/screens/login_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:package_info/package_info.dart';

import 'package:forwardair_fleet_management/screens/dashboard_page.dart';
import 'package:forwardair_fleet_management/screens/featurecomingsoon.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/customwidgets/expandablecontainer.dart';
import 'package:forwardair_fleet_management/models/login_model.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';

class HomePage extends StatefulWidget {
  HomePage();
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _drawerMenuItems = [
    Constants.TEXT_SAFETY_INCIDENTS,
    Constants.TEXT_DASHBOARD,
    Constants.TEXT_NOTIFICATION,
    Constants.TEXT_MODULES,
    Constants.TEXT_FLEET_TRACKER,
    Constants.TEXT_SETTLEMENTS,
    Constants.TEXT_REFERRAL_PROGRAM,
    Constants.TEXT_NOTIFICATION_OF_UNAVALIABILITY,
    Constants.TEXT_COMPANY_NEWS,
    Constants.TEXT_PROFILE,
    Constants.TEXT_SETTINGS,
    Constants.TEXT_LOGOUT
  ];
  List _imageNames = [
    'images/ic_safety&incident.png',
    'images/ic_dashboard.png',
    'images/ic_notification.png',
    'images/ic_notification.png',
    'images/ic_fleet_tracker.png',
    'images/ic_settlement.png',
    'images/ic_referral_program.png',
    'images/ic_notification_unavailability.png',
    'images/ic_company_news.png',
    'images/ic_profile.png',
    'images/ic_settings.png',
    'images/ic_logout.png'
  ];

  List _selectedItemImages = [
    'images/ic_safety&incident_active.png',
    'images/ic_dashboard_active.png',
    'images/ic_notification.png',
    'images/ic_notification_active.png',
    'images/ic_fleet_tracker_active.png',
    'images/ic_settings_active.png',
    'images/ic_referral_program_active.png',
    'images/ic_notification_unavailability_active.png',
    'images/ic_company_news_active.png',
    'images/ic_profile_active.png',
    'images/ic_settings_active.png',
    'images/ic_logout_active.png'
  ];

  int _selectedIndex = 0;
  bool expandFlag = false;
  int _expandedListIndex = 0;
  String versionNumer = '';
  UserDetails _userDetails = UserDetails();

  //Initial State
  @override
  initState() {
    super.initState();
    _fetchUserDetails();
    _getVersionNumberOfTheApp();
  }

  //Fetch Loggin User Data
  Future<UserDetails> _fetchUserDetails() async {
    var userManager = UserManager();
    _userDetails = await userManager.getData();
    setState(() {});
    return _userDetails;
  }

  //Fetch Version of the app
  Future<String> _getVersionNumberOfTheApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionNumer = packageInfo.version;
    });
    return versionNumer;
  }

  //To update the index
  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Index of Expanded List
  _onExpandedListViewIndex(int index) {
    setState(() {
      _expandedListIndex = index;
    });
  }

  //To display versionNumber
  Text _versionNumberWidgte() {
    return Text(
      Constants.TEXT_VERSION_NUMBER + versionNumer,
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
//      case 0:
//        title = Constants.TEXT_REPORT_ACCIDENT;
//        break;
      case 0:
        title = Constants.TEXT_REPORT_BREAKDOWN;
        break;
      case 1:
        title = Constants.TEXT_REPORT_INCIDENTOROTHER;
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
            _onExpandedListViewIndex(index);
            // navigateToFeatureComingSoonPage();
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
                _onSelected(index);
                if (expandFlag == false) {
                  _expandedListIndex = 0;
                }
                setState(() {
                  expandFlag = !expandFlag;
                });
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

    if (index == 0) {
      return _safetyAndAccidentsExpandableWidget(index);
    } else if (index == 3) {
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
    } else if (index == 2 || index == 8) {
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
                      _onSelected(index);

                      navigateToFeatureComingSoonPage();
                    }),
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      );
    } else {
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
                  _onSelected(index);
                  switch (index) {
                    case 1:
                      {
                        Navigator.pop(context);
                      }
                      break;
                    case 11:
                      {
                        logoutAction();

                        //Logout
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: DrivingConfirmation()));
                      }
                      break;
                    default:
                      {
                        navigateToFeatureComingSoonPage();
                      }
                      break;
                  }
                }),
            color: Colors.transparent,
          ),
        ),
      );
    }
  }

  //Log out
  Future logoutAction() async {
    final userManager = UserManager();
    return await userManager.deleteAll();
  }

  @override
  Widget build(BuildContext context) {

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
          InkWell(
            child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('images/ic_notfication_white.png')),
            onTap: () {
              navigateToFeatureComingSoonPage();
            },
          ),
          InkWell(
            child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('images/ic_more.png')),
            onTap: () {
              navigateToFeatureComingSoonPage();
            },
          ),
        ],
      ),
      body: DashboardPage(),
      drawer: new Drawer(
          child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/img_bg_top_login.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0, right: 10, child: _versionNumberWidgte()),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: new CircleAvatar(
                          child: Image.asset('images/ic_profile_pic.png')),
                    ),
                    title: Container(
                        padding: EdgeInsets.only(top: 15),
                        height: 40,
                        child: Text(
                          _userDetails.fullName == null
                              ? 'User Name'
                              : _userDetails.fullName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: Colors.white),
                        )),
                    subtitle: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          Constants.TEXT_FLEET_OWNER,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: Constants.FONT_FAMILY_ROBOTO,
                              fontSize: 16,
                              color: Colors.white),
                        )),
                  ),
                ),
              ],
            ),
            ListView.builder(
              padding: EdgeInsets.only(top: 10),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _buildRow(index),
              itemCount: _drawerMenuItems.length,
            ),
          ],
        ),
      )),
    );
  }

  void navigateToFeatureComingSoonPage() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade, child: FeaturesComingSoonPage()));
  }
}
