import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/components/upcoming_and_past_leaves_item.dart';
import 'package:forwardair_fleet_management/screens/Unavailability/unavailability_detail_page.dart';
import 'package:forwardair_fleet_management/utility/theme.dart';
import 'package:page_transition/page_transition.dart';

import 'package:forwardair_fleet_management/blocs/barrels/unavailability.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';
import 'package:forwardair_fleet_management/screens/Unavailability/leave_calendar_page.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';

//To display unavailability Page
class UnavailabilityListPage extends StatefulWidget {
  final String usertype;
  UnavailabilityListPage({this.usertype, Key key}) : super(key: key);
  @override
  UnavailabilityListState createState() {
    return UnavailabilityListState(this.usertype);
  }
}

class UnavailabilityListState extends State<UnavailabilityListPage>
    with SingleTickerProviderStateMixin {

  final String usertype;
  UnavailabilityListState(this.usertype);

  //Tab bar Controller for Upcoming and Past Items.
  TabController _tabController;
  //UnavailabilityBloc
  UnavailabilityBloc _unavailabilityBloc = UnavailabilityBloc();
  //Upcoming Unavailability List
  List<UnavailabilityDataModelDetail> upcomingItems = [];
  //Past Unavailability List
  List<UnavailabilityDataModelDetail> pastItems = [];
  //To find out Active index
  int _activeTabIndex = 0;

  @override
  void initState() {
    //Calling API
    _unavailabilityBloc.dispatch(GetUnavailabilityDataEvent());
    //Tab Controller to navigate b/w Upcoming and Past items.
    _tabController = new TabController(length: 2, vsync: this);
    // To find out active index of Tab bar
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

  //Navigate to Leave Detail Page
  void openLeaveDetailsPage(
      UnavailabilityDataModelDetail unavailabilityDataModelDetail) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: UnavailabilityDetailsPage(
                unavailabilityDataModelDetail: unavailabilityDataModelDetail)));
  }

  //Main Widget to hold the page of the unavailability
  _scaffoldWidget() {
    return Scaffold(
      //To display Plus button widget
      floatingActionButton: usertype == '' ? Container() : this.usertype != Constants.TEXT_FO_TYPE ? FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: AppColors.colorWhite,
        ),
        backgroundColor: AppColors.colorRed,
      ) : Container(),
      //BlocListener to check condition according to state
      //Basically it used to navigate to page
      body: BlocListener<UnavailabilityBloc, UnavailabilityStates>(
        listener: (context, state) {
          if (state is TappedonLeaveListItemState) {
            openLeaveDetailsPage(state.dataModelDetail);
          }
        },
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
            return Column(
              children: <Widget>[
                Material(
                  color: CustomColors.blue[900],
                  child: TabBar(
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
                ),
                Expanded(
                    flex: 1,
                    child: TabBarView(
                      children: [
                        upcomingItems.length == 0
                            ? NoResultFoundWidget()
                            : upcomingAndPastListView(this.upcomingItems),
                        pastItems.length == 0
                            ? NoResultFoundWidget()
                            : upcomingAndPastListView(this.pastItems)
                      ],
                      controller: _tabController,
                    ))
              ],
            );
          },
        ),
      ),
    );
  }

  void openLeaveCalendarBasedOnTheTabBarItem() {
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

  //This widget display Upcoming and Past List items
  Widget upcomingAndPastListView(
      List<UnavailabilityDataModelDetail> upcomingOrPastItems) {
    return ListView.builder(
        itemCount: upcomingOrPastItems.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              print(upcomingOrPastItems[index]);
              _unavailabilityBloc.dispatch(
                  TappedonLeaveListItemEvent(dataModelDetail: upcomingOrPastItems[index]));
            },
            child: UpcomingAndPastLeavesItem(
              unavailabilityBloc: _unavailabilityBloc,
              unavailabilityDataModelDetail: upcomingOrPastItems[index],
            ),
          );
        });
  }
}
