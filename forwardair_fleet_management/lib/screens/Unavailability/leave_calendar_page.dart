import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/blocs/unavailability_bloc.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/components/upcoming_and_past_leaves_item.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';
import 'package:forwardair_fleet_management/screens/Unavailability/unavailability_detail_page.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:forwardair_fleet_management/blocs/barrels/leave_calendar.dart';

class LeaveCalendarPage extends StatefulWidget {
  //Upcoming/Past Unavailability List
  final List<UnavailabilityDataModelDetail> upcomingOrPastLeaves;
  //Constructor
  LeaveCalendarPage(@required this.upcomingOrPastLeaves) : super();

  @override
  LeaveCalendarState createState() =>
      LeaveCalendarState(this.upcomingOrPastLeaves);
}

class LeaveCalendarState extends State<LeaveCalendarPage>
    with TickerProviderStateMixin {
  //LeaveCalendarBloc
  LeaveCalendarBloc _leaveCalendarBloc = LeaveCalendarBloc();

  //Upcoming/Past Unavailability List
  final List<UnavailabilityDataModelDetail> upcomingOrPastLeaves;
  //Constructor
  LeaveCalendarState(@required this.upcomingOrPastLeaves);

  Map<DateTime, List<UnavailabilityDataModelDetail>> _events =
      Map<DateTime, List<UnavailabilityDataModelDetail>>();
  List _selectedEvents = [];
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    //Dispatching Event to get the Calendar events.
    _leaveCalendarBloc.dispatch(GetLeaveCalendarDataEvent(
        upcomingOrPastLeaves: this.upcomingOrPastLeaves));
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    //To dispose _animationController
    _animationController.dispose();
    //To dispose _calendarController
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    _leaveCalendarBloc.dispatch(TappedonDateEvent(events: events));
  }

  _scaffoldWidget() {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: false,
        title: TextWidget(
          text: 'Leave Calendar',
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
      ),
      //BlocListener
      body: BlocListener<LeaveCalendarBloc, LeaveCalendarStates>(
          listener: (context, state) {
            if (state is TappedonLeaveListItemState) {
              openLeaveDetailsPage(state.dataModelDetail);
            }
          },
          bloc: _leaveCalendarBloc,
          //To update the ui according to its  States.
          child: BlocBuilder<LeaveCalendarBloc, LeaveCalendarStates>(
              bloc: _leaveCalendarBloc,
              builder: (context, state) {
                print(state);
                if (state is GetLeaveCalendarSate) {
                  if (state.events != null) {
                    if (state.events.length > 0) {
                      this._events = state.events;
                      if (_events.length > 0) {
                        _selectedEvents = _events[DateTime.now()] ?? [];
                      }
                    }
                  }
                } else if (state is TappedonDateState) {
                  _selectedEvents = state.events;
                }

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //To display Table Calendar
                    _buildTableCalendar(),
                    const SizedBox(height: 8.0),
                    //To display List of Leaves.
                    Expanded(child: _buildEventList()),
                  ],
                );
              })),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Check platform for Safearea
    if (Platform.isIOS) {
      return _scaffoldWidget();
    } else {
      return SafeArea(
        child: _scaffoldWidget(),
      );
    }
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      //holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: AppColors.darkColorBlue,
        todayColor: AppColors.darkColorBlue,
        markersColor: AppColors.colorRed,
        outsideDaysVisible: true,
      ),
      availableCalendarFormats: {CalendarFormat.month: 'Month'},
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
    );
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

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
              child: InkWell(
                  onTap: () {
                    _leaveCalendarBloc.dispatch(
                        TappedonLeaveListItemEvent(dataModelDetail: event));
                    print('$event tapped!');
                  },
                  child: UpcomingAndPastLeavesItem(
                    unavailabilityBloc: UnavailabilityBloc(),
                    unavailabilityDataModelDetail: event,
                  ))))
          .toList(),
    );
  }
}
