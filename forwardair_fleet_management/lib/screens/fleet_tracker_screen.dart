import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/components/no_internet_connection.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/components/shimmer/list_shimmer.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/fleetTracker/fleet_tracker_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:forwardair_fleet_management/blocs/barrels/fleet_tracker.dart';
import 'package:page_transition/page_transition.dart';

import 'fleet_location_screen.dart';

class FleetTrackerPage extends StatefulWidget {
  @override
  _FleetTrackerPage createState() => _FleetTrackerPage();
}

class _FleetTrackerPage extends State<FleetTrackerPage> {
  FleetTrackerBloc _fleetBloc = FleetTrackerBloc();

  @override
  void initState() {
    _fleetBloc.dispatch(FetchFleetDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return SafeArea(
        child: _scaffoldWidget(),
      );
    } else {
      return _scaffoldWidget();
    }
  }

  //this is scaffold widget to display widget based on state
  Widget _scaffoldWidget() {
    return Scaffold(
      body: BlocListener<FleetTrackerBloc, FleetTrackerState>(
        listener: (context, state) {},
        bloc: _fleetBloc,
        child: BlocBuilder<FleetTrackerBloc, FleetTrackerState>(
          bloc: _fleetBloc,
          builder: (context, state) {
            if (state is FleetErrorState) {
              if (state.errorMessage == Constants.NO_INTERNET_FOUND) {
                return NoInternetFoundWidget();
              } else {
                return NoResultFoundWidget();
              }
            }
            //If state is success then show data in list
            if (state is FleetSuccessState) {
              if (state.fleetData != null) {
                return _mainWidget(state.fleetData);
              } else {
                return NoResultFoundWidget();
              }
            }
            return ListViewShimmer(
              listLength: 10,
            );
          },
        ),
      ),
    );
  }

  //this is the main widget which contains listView builder to create listView
  Widget _mainWidget(List<CurrentPositions> dataModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 8, right: 8),
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: dataModel.length,
        itemBuilder: (BuildContext context, int index) {
          return _listItem(dataModel[index], context);
        },
      ),
    );
  }

  //this widget holds the listItem and component of listView
  Widget _listItem(CurrentPositions fleetData, BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Row widget to show dot,unitNbr,ignition status and unavailable or active
            Padding(
              padding:
                  const EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 4),
              child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      color: fleetData.ignitionOnOff == 'ON'
                          ? Colors.green
                          : AppColors.colorRed,
                      height: 8.0,
                      width: 8.0,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      //column is required for unitNbr and ignition widget
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextWidget(
                            text: fleetData.unitNbr != null
                                ? 'Unit: ${fleetData.unitNbr}'
                                : "N/A",
                            colorText: AppColors.colorBlack,
                            textType: TextType.TEXT_SMALL,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: TextWidget(
                              text: fleetData.ignitionOnOff != null
                                  ? 'Ignition: ${fleetData.ignitionOnOff}'
                                  : "N/A",
                              colorText: AppColors.colorBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Active and NonActive Text Widget
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: TextWidget(
                        text: (fleetData.Driver1NextTimeOffBeginDt == null ||
                                fleetData.Driver1NexTimeOffEndDt == null)
                            ? ""
                            : _fleetBloc.compareDate(
                                    fleetData.Driver1NextTimeOffBeginDt,
                                    fleetData.Driver1NexTimeOffEndDt)
                                ? "Active"
                                : "Unavailable", //'\$' + amount,
                        colorText:
                            (fleetData.Driver1NextTimeOffBeginDt == null ||
                                    fleetData.Driver1NexTimeOffEndDt == null)
                                ? Colors.yellow
                                : _fleetBloc.compareDate(
                                        fleetData.Driver1NextTimeOffBeginDt,
                                        fleetData.Driver1NexTimeOffEndDt)
                                    ? Colors.green
                                    : AppColors.colorRed,
                        isBold: true,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Divider
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 4, right: 4),
              child: Divider(
                height: 1,
                color: AppColors.colorGrey,
              ),
            ),

            //this widget hold current location text
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: TextWidget(
                      text: 'Location',
                      colorText: AppColors.colorGrey,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextWidget(
                        text: fleetData.placeName != null
                            ? '${fleetData.placeName}'
                            : 'N/A',
                        colorText: AppColors.colorBlack,
                        isBold: true,
                        textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),

            //this widget holds the destination location text
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8, right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: TextWidget(
                      text: 'Destination',
                      colorText: AppColors.colorGrey,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextWidget(
                      text:
                          fleetData.dest != null ? '${fleetData.dest}' : "N/A",
                      colorText: AppColors.colorBlack,
                      isBold: true,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),

            //this widget holds Current Load text
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: TextWidget(
                      text: 'Current Load',
                      colorText: AppColors.colorGrey,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextWidget(
                        text: fleetData.order != null
                            ? '${fleetData.order}'
                            : 'N/A',
                        colorText: AppColors.colorBlack,
                        isBold: true,
                        textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),

            //this widget holds Expected time of arrival text
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: TextWidget(
                      text: 'ETA',
                      colorText: AppColors.colorGrey,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextWidget(
                        text: fleetData.etaDt != null
                            ? Utils.formatTimeFromString(fleetData.etaDt)
                            : "N/A",
                        isBold: true,
                        textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),

            //this widget holds next order text
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: TextWidget(
                      text: 'Next Load',
                      colorText: AppColors.colorGrey,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextWidget(
                        text: fleetData.nextOrder != null
                            ? '${fleetData.nextOrder}'
                            : 'N/A',
                        isBold: true,
                        textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),

            //this widget holds next schedule departure text
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, top: 8.0, bottom: 8.0, right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: TextWidget(
                      text: 'Sch. Depart',
                      colorText: AppColors.colorGrey,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextWidget(
                        text: fleetData.nextOrderScheduledDepartDt != null
                            ? Utils.formatTimeFromString(
                                fleetData.nextOrderScheduledDepartDt)
                            : "N/A",
                        isBold: true,
                        textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          //To navigate to Map screen
          navigateToMapPage(fleetData, context);
        },
      ),
    );
  }

  void navigateToMapPage(CurrentPositions fleetData, BuildContext context) {

    //calling map screen with fleetData to perform action based on lat,long in Map Screen
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: FleetLocationPage(fleetData: fleetData)));
  }
}
