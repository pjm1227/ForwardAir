import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/blocs/events/load_detail_events.dart';
import 'package:forwardair_fleet_management/blocs/load_detail_bloc.dart';
import 'package:forwardair_fleet_management/blocs/states/load_details_states.dart';
import 'package:forwardair_fleet_management/components/shimmer/list_shimmer.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';

import 'package:forwardair_fleet_management/models/loadDetails/load_detail_model.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

class LoadDetailsPage extends StatefulWidget {
  bool isMilePage;
  Tractor tractorData;
  Dashboard_DB_Model dashboardData;
  PageName pageName;

  LoadDetailsPage(pageName,this.tractorData, this.dashboardData);

  @override
  _LoadDetailsPageState createState() => _LoadDetailsPageState(
      this.isMilePage, this.tractorData, this.dashboardData);
}

class _LoadDetailsPageState extends State<LoadDetailsPage> {
  bool isMilePage;
  Tractor tractorData;
  Dashboard_DB_Model dashboardData;
  LoadDetailBloc _loadBloc = LoadDetailBloc();

  _LoadDetailsPageState(this.isMilePage, this.tractorData, this.dashboardData);

  LoadDetailModel loadDetailsData;

  @override
  Widget build(BuildContext context) {
    if (dashboardData.weekStart != null) {
      _loadBloc.dispatch(FetchLoadDetailsEvent(
          weekStart: dashboardData.weekStart,
          weekEnd: dashboardData.weekEnd,
          month: 0,
          year: "",
          tractorId: tractorData.tractorId));
    } else {
      _loadBloc.dispatch(FetchLoadDetailsEvent(
          weekStart: dashboardData.weekStart,
          weekEnd: dashboardData.weekEnd,
          month: dashboardData.month,
          year: dashboardData.year,
          tractorId: tractorData.tractorId));
    }

    if (Platform.isAndroid) {
      return SafeArea(child: scaffoldWidget());
    } else {
      return scaffoldWidget();
    }
  }

  Widget scaffoldWidget() {
    return Scaffold(
      backgroundColor: AppColors.colorDashboard_Bg,
      body: BlocBuilder<LoadDetailBloc, dynamic>(
        bloc: _loadBloc,
        builder: (context, state) {
          print('${state}');
          if (state is LoadDataError) {
            return Center(
              child: Text('Failed to fetch details'),
            );
          } else if (state is LoadDataLoaded) {
//            _refreshController.refreshCompleted();
            print('Entering to the UI part');
            if (state.loadDetails != null) {
              loadDetailsData = state.loadDetails;
            }
            return Scaffold(
                appBar: AppBar(
                  centerTitle: false,
                  backgroundColor: Color.fromRGBO(15, 43, 52, 1),
                  title: TextWidget(
                    text: isMilePage ? "Tractor ID Miles" : "Tractor ID Loads",
                    colorText: Color.fromRGBO(255, 255, 255, 1),
                    textType: TextType.TEXT_MEDIUM,
                    isBold: true,
                  ),
                  leading: InkWell(
                    child: Icon(Icons.arrow_back, color: Colors.white),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: SafeArea(
                  child: Stack(
                    children: <Widget>[
                      // The containers in the background
                      new Column(
                        children: <Widget>[
                          new Container(
                            height: MediaQuery.of(context).size.height * .18,
                            color: Color.fromRGBO(15, 43, 52, 1),
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: rectangleWidget(),
                            ),
                          ),
                        ],
                      ),

                      new Container(
                        alignment: Alignment.topCenter,
                        padding: new EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .12,
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: loadDetailsData.loadDetails.length,
                          itemBuilder: (BuildContext context, int index) {
                            return getCard(loadDetailsData.loadDetails[index]);
                          },
                        ),
                      )
                    ],
                  ),
                ));
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(15, 43, 52, 1),
              title: TextWidget(
                text: isMilePage ? "Tractor ID Miles" : "Tractor ID Loads",
                colorText: Color.fromRGBO(255, 255, 255, 1),
                textType: TextType.TEXT_MEDIUM,
                isBold: true,
              ),
              leading: InkWell(
                child: Icon(Icons.arrow_back, color: Colors.white),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Center(
              child: ListViewShimmer(
                listLength: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getCard(Loads loadData) {
    return Card(
      elevation: 4.0,
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(100.0)),
        child: getListtile(loadData),
      ),
    );
  }

  Widget getListtile(Loads loadData) {
    String miles;
    Color dot = (loadData.loadedMiles != 0)
        ? Color.fromRGBO(45, 135, 151, 1)
        : Color.fromRGBO(207, 29, 43, 1);
    if (isMilePage) {
      miles = loadData.loadedMiles == 0
          ? '(${Utils().formatDecimalToWholeNumber(loadData.emptyMiles)}mi)'
          : '(${Utils().formatDecimalToWholeNumber(loadData.loadedMiles)}mi)';
    } else {
      miles = '';
    }

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),

      title: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
          child: Row(children: <Widget>[
            ClipOval(
              child: Container(
                color: dot,
                height: 10.0,
                width: 10.0,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Order No. ${loadData.orderNbr}",
                  style: TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(118, 119, 120, 1),
                      fontFamily: 'Roboto'),
                )),
          ])),

      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextWidget(
                      text: loadData.originCity != null
                          ? '${loadData.originCity},${loadData.originSt}'
                          : 'NA',
                      colorText: Color.fromRGBO(23, 87, 99, 1),
                      textType: TextType.TEXT_SMALL,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 10),
                    child: TextWidget(
                      text: Utils.formatDateFromString(loadData.dispatchDt),
                      colorText: Color.fromRGBO(118, 119, 120, 1),
                      textType: TextType.TEXT_NORMAL,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 8, right: 8.0, bottom: 24),
                child: Icon(Icons.arrow_forward),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextWidget(
                            text: '${loadData.destCity},${loadData.destSt}',
                            colorText: Color.fromRGBO(23, 87, 99, 1),
                            textType: TextType.TEXT_SMALL,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TextWidget(
                              text: miles,
                              colorText: Color.fromRGBO(0, 0, 0, 1),
                              textType: TextType.TEXT_SMALL,
                              isBold: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextWidget(
                      text: loadData.settlementPaidDt != null
                          ? Utils.formatDateFromString(
                              loadData.settlementPaidDt)
                          : "N/A",
                      colorText: Color.fromRGBO(118, 119, 120, 1),
                      textType: TextType.TEXT_NORMAL,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            color: Colors.black38,
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextWidget(
                    text: "Driver Details",
                    textAlign: TextAlign.start,
                    colorText: Color.fromRGBO(118, 119, 120, 1),
                    textType: TextType.TEXT_NORMAL),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: TextWidget(
                    text: loadData.driver2Id == null
                        ? '${loadData.driver1FirstName} ${loadData.driver1LastName} from ${loadData.driverOriginCity},${loadData.driverOriginSt}'
                        : "${loadData.driver1FirstName} ${loadData.driver1LastName}, ${loadData.driver2FirstName} ${loadData.driver2LastName}  from ${loadData.driverOriginCity},${loadData.driverOriginSt}",
                    textAlign: TextAlign.start,
                    colorText: Color.fromRGBO(0, 0, 0, 1),
                    textType: TextType.TEXT_XSMALL),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container rectangleWidget() {
    return new Container(
      height: 80.0,
      color: Color.fromRGBO(15, 43, 52, 1),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Center(
                child: Row(
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        color: Colors.white,
                        height: 12.0,
                        width: 12.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: TextWidget(
                        text: isMilePage
                            ? "${Utils().formatDecimalToWholeNumber(tractorData.totalMiles)}"
                            : '${Utils().formatDecimalToWholeNumber(tractorData.totalLoads)}',
                        colorText: Color.fromRGBO(255, 255, 255, 1),
                        textType: TextType.TEXT_MEDIUM,
                        isBold: true,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('TOTAL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(255, 255, 255, 1))),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0, bottom: 70),
                child: VerticalDivider(
                  color: Color.fromRGBO(213, 213, 213, 1),
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Row(
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        color: Colors.red,
                        height: 10.0,
                        width: 10.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: TextWidget(
                        text: isMilePage
                            ? "${Utils().formatDecimalToWholeNumber(tractorData.emptyMiles)}"
                            : '${Utils().formatDecimalToWholeNumber(tractorData.emptyLoads)}',
                        colorText: Color.fromRGBO(255, 255, 255, 1),
                        textType: TextType.TEXT_MEDIUM,
                        isBold: true,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('EMPTY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(255, 255, 255, 1))),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0, bottom: 70),
                child: VerticalDivider(
                  color: Color.fromRGBO(213, 213, 213, 1),
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Row(
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        color: Colors.blue,
                        height: 12.0,
                        width: 12.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: TextWidget(
                        text: isMilePage
                            ? "${Utils().formatDecimalToWholeNumber(tractorData.loadedMiles)}"
                            : '${Utils().formatDecimalToWholeNumber(tractorData.loadedLoads)}',
                        colorText: Color.fromRGBO(255, 255, 255, 1),
                        textType: TextType.TEXT_MEDIUM,
                        isBold: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('LOADED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(255, 255, 255, 1))),
              )
            ],
          ),
        ],
      ),
    );
  }
}
