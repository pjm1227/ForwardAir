import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/components/upcoming_and_past_leaves_item.dart';
import 'package:page_transition/page_transition.dart';

import 'package:forwardair_fleet_management/blocs/barrels/unavailability.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';
import 'package:forwardair_fleet_management/screens/leave_calendar_page.dart';
import 'package:forwardair_fleet_management/screens/sidemenu.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';

//To display unavailability Page
class UnavailabilityListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UnavailabilityListState();
  }
}

class UnavailabilityListState extends State<UnavailabilityListPage>
    with SingleTickerProviderStateMixin {
  //Scaffold Global Key
 // GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  //Tab bar Controller for Upcoming and Past Items.
  TabController _tabController;
  //UnavailabilityBloc
  UnavailabilityBloc _unavailabilityBloc = UnavailabilityBloc();
  //Upcoming Unavailability List
  List<UnavailabilityDataModelDetail> upcomingItems = [];
  //Past Unavailability List
  List<UnavailabilityDataModelDetail> pastItems = [];
  //To findout Active index
  int _activeTabIndex = 0;

  @override
  void initState() {
    //Calling API
    _unavailabilityBloc.dispatch(GetUnavailabilityDataEvent());
    //Tab Controller to navigate b/w Upcoming and Past items.
    _tabController = new TabController(length: 2, vsync: this);
    // To findout active index of Tabbar
    _tabController.addListener(_setActiveTabIndex);
    super.initState();
  }

  void _setActiveTabIndex() {
    _activeTabIndex = _tabController.index;
  }

  @override
  void dispose() {
    //To Dispose unavailability Bloc
    _unavailabilityBloc.dispose();
    super.dispose();
  }

  //Main Widget to hold the page of the unavailability
  _scaffoldWidget() {
    return Scaffold(
      //To display Plus button widget
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: AppColors.colorWhite,
        ),
        backgroundColor: AppColors.colorRed,
      ),
      //To display appbar
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: false,
        //AppBar Title
        title: TextWidget(
          text: Constants.TEXT_NOTIFICATION_OF_UNAVALIABILITY,
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
        //To display TabBar under appbar widget
        bottom: TabBar(
          unselectedLabelColor: AppColors.colorWhite.withOpacity(0.7),
          labelColor: AppColors.colorWhite,
          tabs: [
            new Tab(text: Constants.TEXT_UPCOMING),
            new Tab(text: Constants.TEXT_PAST),
          ],
          indicatorWeight: 3.0,
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
        actions: <Widget>[
          //To display the calendar Icon widget
          InkWell(
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
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: _activeTabIndex == 0
                          ? LeaveCalendarPage(
                        this.upcomingItems,
                      )
                          : LeaveCalendarPage(
                        this.pastItems,
                      )));
            },
          ),
        ],
      ),
      //Scaffold global key
      //key: _scaffold,
      //Side Menu
     // drawer: SideMenuPage(),
      //BlocListener to check condition according to state
      //Basically it used to navigate to page
      body: BlocListener<UnavailabilityBloc, UnavailabilityStates>(
        listener: (context, state) {},
        bloc: _unavailabilityBloc,
        child: BlocBuilder<UnavailabilityBloc, UnavailabilityStates>(
          bloc: _unavailabilityBloc,
          builder: (context, state) {
            if (state is SuccessState) {
              //After getting Data from API.
              if (state.unavailabilityDataModel != null) {
                if (state.upcomingUnavailabilityList != null &&
                    state.upcomingUnavailabilityList.length != 0) {
                  this.upcomingItems = state.upcomingUnavailabilityList;
                }
                if (state.pastUnavailabilityList != null &&
                    state.pastUnavailabilityList.length != 0) {
                  this.pastItems = state.pastUnavailabilityList;
                }
              }
            }
            if (state is ErrorState) {
              if (state.errorMessage == Constants.NO_INTERNET_FOUND) {
                //This displays No internet Found Widget
                upcomingItems = [];
              } else {
                //This displays No Result Found Widget
                pastItems = [];
              }
            }
            return TabBarView(
              children: [
                upcomingItems.length == 0
                    ? NoResultFoundWidget()
                    : upcomingAndPastListView(this.upcomingItems),
                pastItems.length == 0
                    ? NoResultFoundWidget()
                    : upcomingAndPastListView(this.pastItems)
              ],
              controller: _tabController,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Platform Checking for Safearea.
    if (Platform.isAndroid) {
      return SafeArea(
        child: _scaffoldWidget(),
      );
    } else {
      return _scaffoldWidget();
    }
  }

//  Widget _displayIconAndTextInRow(
//      Icon icon, String title, Color color, TextType textType) {
//    return Padding(
//        padding: EdgeInsets.only(top: 10, bottom: 5, left: 5),
//        child: Row(
//          children: <Widget>[
//            icon,
//            Padding(
//              padding: const EdgeInsets.only(left: 8.0),
//              child: TextWidget(
//                text: title,
//                colorText: color,
//                textType: textType,
//              ),
//            ),
//          ],
//        ));
//  }

  //This widget display Upcoming and Past List items
  Widget upcomingAndPastListView(
      List<UnavailabilityDataModelDetail> upcomingOrPastItems) {
    return ListView.builder(
        itemCount: upcomingOrPastItems.length,
        itemBuilder: (context, index) {
          return UpcomingAndPastLeavesItem(
            unavailabilityBloc: _unavailabilityBloc,
            unavailabilityDataModelDetail: upcomingOrPastItems[index],
          );
//            Container(
//            padding: EdgeInsets.all(10),
//            margin: new EdgeInsets.only(
//                left: 10.0, right: 10, top: 5.0, bottom: 5.0),
//            decoration: new BoxDecoration(
//              color: Colors.white,
//              shape: BoxShape.rectangle,
//              borderRadius: new BorderRadius.all(
//                Radius.circular(5.0),
//              ),
//              boxShadow: <BoxShadow>[
//                new BoxShadow(
//                  color: Color.fromRGBO(0, 0, 0, 0.16),
//                  blurRadius: 10.0,
//                  offset: new Offset(0.0, 10.0),
//                ),
//              ],
//            ),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                TextWidget(
//                  text: Constants.TEXT_TIME_OFF,
//                  textType: TextType.TEXT_SMALL,
//                  colorText: AppColors.colorBlue,
//                  isBold: true,
//                ),
//                _displayIconAndTextInRow(
//                    Icon(
//                      Icons.calendar_today,
//                      size: 15,
//                      color: AppColors.colorBlue,
//                    ),
//                    _unavailabilityBloc.combineStartAndEndDate(
//                        upcomingOrPastItems[index].leaveStartDate,
//                        upcomingOrPastItems[index].leaveEndDate),
//                    AppColors.colorBlack,
//                    TextType.TEXT_SMALL),
//                _displayIconAndTextInRow(
//                    Icon(
//                      Icons.location_on,
//                      color: AppColors.colorBlue,
//                      size: 15,
//                    ),
//                    _unavailabilityBloc.combineCityAndState(
//                        upcomingOrPastItems[index].city,
//                        upcomingOrPastItems[index].state),
//                    AppColors.colorBlack,
//                    TextType.TEXT_SMALL),
//                _displayIconAndTextInRow(
//                    Icon(
//                      Icons.description,
//                      color: AppColors.colorBlue,
//                      size: 15,
//                    ),
//                    upcomingOrPastItems[index].reason,
//                    AppColors.colorBlack,
//                    TextType.TEXT_SMALL),
//                _displayIconAndTextInRow(
//                    Icon(
//                      Icons.person_outline,
//                      color: AppColors.colorBlue,
//                      size: 15,
//                    ),
//                    _unavailabilityBloc.combineSubmittedDateTimeAndId(
//                        upcomingOrPastItems[index].submittedDateAndTime,
//                        upcomingOrPastItems[index].sumittedId),
//                    AppColors.colorGrey,
//                    null),
//              ],
//            ),
//          );
        });
  }
}
