import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/blocs/barrels/load_details.dart';
import 'package:forwardair_fleet_management/components/no_internet_connection.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/components/shimmer/list_shimmer.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';

import 'package:forwardair_fleet_management/models/loadDetails/load_detail_model.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

class LoadDetailsPage extends StatefulWidget {
  //Tractor data model
  final Tractor tractorData;

  //Dashboard data model
  final Dashboard_DB_Model dashboardData;

  // Page name
  final PageName pageName;

  LoadDetailsPage(this.pageName, this.tractorData, this.dashboardData);

  @override
  _LoadDetailsPageState createState() => _LoadDetailsPageState(
      this.pageName, this.tractorData, this.dashboardData);
}

class _LoadDetailsPageState extends State<LoadDetailsPage> {
  //page Name
  PageName pageName;

  //tractor data model
  Tractor tractorData;

  //Dashboard data model
  Dashboard_DB_Model dashboardData;

  //Bloc object
  LoadDetailBloc _loadDetailsBloc = LoadDetailBloc();

  _LoadDetailsPageState(this.pageName, this.tractorData, this.dashboardData);

  @override
  void initState() {
    //Call Api For Tractor data and Chart data
    //Check condition i.e for week data or month data
    if (dashboardData != null &&
        (dashboardData.dashboardPeriod ==
            Constants.TEXT_DASHBOARD_PERIOD_THIS_MONTH)) {
      _loadDetailsBloc.dispatch(FetchTractorDataEvent(
          pageName: pageName,
          tractorId: tractorData.tractorId,
          month: dashboardData.month,
          year: int.parse(dashboardData.year),
          weekEnd: null,
          weekStart: null));
    } else {
      _loadDetailsBloc.dispatch(FetchTractorDataEvent(
          tractorId: tractorData.tractorId,
          pageName: pageName,
          month: 0,
          year: 0,
          weekEnd: dashboardData.weekEnd,
          weekStart: dashboardData.weekStart));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return SafeArea(child: _initialWidget());
    } else {
      return _initialWidget();
    }
  }

  //Initial widget
  Widget _initialWidget() {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.colorWhite),
        centerTitle: false,
        title: TextWidget(
          text: pageName == PageName.MILES_PAGE
              ? "Tractor ID Miles"
              : "Tractor ID Loads",
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
      ),
      backgroundColor: AppColors.colorDashboard_Bg,
      body: BlocBuilder<LoadDetailBloc, dynamic>(
        bloc: _loadDetailsBloc,
        builder: (context, state) {
          if (state is DetailsErrorState) {
            if (state.errorMessage == Constants.NO_INTERNET_FOUND) {
              return NoInternetFoundWidget();
            } else {
              return NoResultFoundWidget();
            }
          }
          //If state is success then show data in list
          if (state is SuccessState) {
            if (state.loadDetailsModel.loadDetails != null) {
              return Stack(
                children: <Widget>[
                  // Background widget for overlapping of list widget
                  new Column(
                    children: <Widget>[
                      new Container(
                        height: MediaQuery.of(context).size.height * .18,
                        color: AppColors.colorAppBar,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: _topWidget(),
                        ),
                      ),
                    ],
                  ),
                  //This container return a list view with overlapping the background widget
                  new Container(
                    alignment: Alignment.topCenter,
                    padding: new EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .12,
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.loadDetailsModel.loadDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _listItem(
                            state.loadDetailsModel.loadDetails[index]);
                      },
                    ),
                  )
                ],
              );
            }
            else
              {
                return NoResultFoundWidget();
              }
          }
          return ListViewShimmer(
            listLength: 10,
          );
        },
      ),
    );
  }

  //Widget to set TOTAL, EMPTY and LOADED Data
  Widget _topWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipOval(
                        child: Container(
                          color: Colors.white,
                          height: 8.0,
                          width: 8.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: TextWidget(
                          text: pageName == PageName.LOAD_PAGE
                              ? '${Utils.formatDecimalToWholeNumber(tractorData.totalLoads)}'
                              : '${Utils.formatDecimalToWholeNumber(tractorData.totalMiles)}',
                          textAlign: TextAlign.center,
                          colorText: AppColors.colorWhite,
                          textType: TextType.TEXT_MEDIUM,
                          isBold: true,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextWidget(
                        text: 'TOTAL',
                        colorText: AppColors.colorWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.08,
                child: VerticalDivider(
                  color: AppColors.colorWhite,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipOval(
                        child: Container(
                          color: Colors.red,
                          height: 8.0,
                          width: 8.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: TextWidget(
                          text: pageName == PageName.MILES_PAGE
                              ? "${Utils.formatDecimalToWholeNumber(tractorData.emptyMiles)}"
                              : '${Utils.formatDecimalToWholeNumber(tractorData.emptyLoads)}',
                          textAlign: TextAlign.center,
                          colorText: AppColors.colorWhite,
                          textType: TextType.TEXT_MEDIUM,
                          isBold: true,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidget(
                      text: 'EMPTY',
                      colorText: AppColors.colorWhite,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.08,
                child: VerticalDivider(
                  color: AppColors.colorWhite,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipOval(
                        child: Container(
                          color: AppColors.colorDOT,
                          height: 8.0,
                          width: 8.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: TextWidget(
                          text: pageName == PageName.MILES_PAGE
                              ? "${Utils.formatDecimalToWholeNumber(tractorData.loadedMiles)}"
                              : '${Utils.formatDecimalToWholeNumber(tractorData.loadedLoads)}',
                          textAlign: TextAlign.center,
                          colorText: AppColors.colorWhite,
                          textType: TextType.TEXT_MEDIUM,
                          isBold: true,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidget(
                      text: 'LOADED',
                      colorText: AppColors.colorWhite,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }

  //This widget return the list items widget
  Widget _listItem(Loads loadData) {
    return Card(
        elevation: 4.0,
        margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Row widget to show dot and order number
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      color: loadData.loadedMiles == 0
                          ? AppColors.colorRed
                          : AppColors.colorDOT,
                      height: 8.0,
                      width: 8.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextWidget(
                      text: 'Order No. ${loadData.orderNbr}',
                    ),
                  ),
                ],
              ),
            ),
            //Widget for Show origin city to destination city
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: pageName == PageName.LOAD_PAGE
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: TextWidget(
                            textOverFlow: TextOverflow.ellipsis,
                            colorText: AppColors.colorAppBar,
                            textType: TextType.TEXT_MEDIUM,
                            text: loadData.originCity != null
                                ? loadData.originCity
                                : 'N/A',
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: TextWidget(
                            colorText: AppColors.colorAppBar,
                            textOverFlow: TextOverflow.ellipsis,
                            textType: TextType.TEXT_MEDIUM,
                            text: loadData.destCity.isNotEmpty
                                ? loadData.destCity
                                : 'N/A',
                          ),
                        ),
                      ],
                    )
                  : _showMiles(loadData),
            ),
            //Widget for Set up dates
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: TextWidget(
                      text: loadData.settlementPaidDt != null
                          ? Utils.formatDateFromString(
                              loadData.settlementPaidDt)
                          : "N/A",
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: TextWidget(
                      text: loadData.settlementFinalDt != null
                          ? Utils.formatDateFromString(
                              loadData.settlementFinalDt)
                          : "N/A",
                    ),
                  ),
                ],
              ),
            ),
            //Divider
            Divider(
              color: AppColors.colorGrey,
            ),
            // Driver details Widget
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextWidget(text: 'Driver Details'),
            ),
            //Driver name widget
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextWidget(
                text: loadData.driver1FirstName.isNotEmpty
                    ? '${loadData.driver1FirstName} ${loadData.driver1LastName} from ${loadData.driverOriginCity},${loadData.driverOriginSt}'
                    : 'N/A',
              ),
            ),
          ],
        ));
  }

//This widget is used to show miles in braces
  Widget _showMiles(Loads loadData) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: TextWidget(
            textOverFlow: TextOverflow.ellipsis,
            colorText: AppColors.colorAppBar,
            textType: TextType.TEXT_MEDIUM,
            text: loadData.originCity != null ? loadData.originCity : 'N/A',
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Icon(
              Icons.arrow_forward,
              size: 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextWidget(
            colorText: AppColors.colorAppBar,
            textOverFlow: TextOverflow.ellipsis,
            textType: TextType.TEXT_MEDIUM,
            text: loadData.destCity.isNotEmpty ? loadData.destCity : 'N/A',
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: TextWidget(
              textOverFlow: TextOverflow.ellipsis,
              text: pageName == PageName.MILES_PAGE
                  ? '(${Utils.formatDecimalToWholeNumber(loadData.loadedMiles)}mi)'
                  : '',
              colorText: AppColors.colorBlack,
            ),
          ),
        ),
      ],
    );
  }
}
