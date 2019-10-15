import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/blocs/barrels/load_details.dart';
import 'package:forwardair_fleet_management/components/no_internet_connection.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/components/shimmer/list_shimmer.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/components/top_widget_fuel.dart';
import 'package:forwardair_fleet_management/components/top_widget_loads.dart';
import 'package:forwardair_fleet_management/components/tractor_fuel_details_item.dart';
import 'package:forwardair_fleet_management/components/tractor_loads_details_item.dart';
import 'package:forwardair_fleet_management/models/Tractor_settlement_model.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';

class TractorDetailsPage extends StatefulWidget {
  //Tractor data model
  final Tractor tractorData;

  //Dashboard data model
  final Dashboard_DB_Model dashboardData;

  // Page name
  final PageName pageName;

  TractorDetailsPage(this.pageName, this.tractorData, this.dashboardData);

  @override
  _TractorDetailsPageState createState() => _TractorDetailsPageState(
      this.pageName, this.tractorData, this.dashboardData);
}

class _TractorDetailsPageState extends State<TractorDetailsPage> {
  //page Name
  PageName pageName;

  //tractor data model
  Tractor tractorData;

  //Dashboard data model
  Dashboard_DB_Model dashboardData;

  //Bloc object
  TractorDetailBloc _loadDetailsBloc = TractorDetailBloc();

  _TractorDetailsPageState(this.pageName, this.tractorData, this.dashboardData);

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
              : pageName == PageName.LOAD_PAGE
                  ? "Tractor ID Loads"
                  : pageName == PageName.FUEL_PAGE
                      ? 'Tractor ID Fuel'
                      : 'Tractor ID Revenue',
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
      ),
      backgroundColor: AppColors.colorDashboard_Bg,
      body: BlocBuilder<TractorDetailBloc, dynamic>(
        bloc: _loadDetailsBloc,
        builder: (context, state) {
          if (state is DetailsErrorState) {
            if (state.errorMessage == Constants.NO_INTERNET_FOUND) {
              return NoInternetFoundWidget();
            } else {
              return NoResultFoundWidget();
            }
          }
          //If state is success for loads and miles then show data in list
          if (state is LoadMilesSuccessState) {
            if (state.tractorDetailsModel.loadDetails != null) {
              return _mainWidget(state);
            } else {
              return NoResultFoundWidget();
            }
          }
          //If state is success for fuel details then show data in list
          if (state is FuelSuccessState) {
            if (state.fuelDetailsModel.fuelDetails != null) {
              return _mainWidget(state);
            } else {
              return NoResultFoundWidget();
            }
          }
          //If state is success for settlement details then show data in list
          if (state is SettlementSuccessState) {
            if (state.settlementDetailsModel.settlementDetails != null) {
              return _mainWidget(state);
            } else {
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

  Widget _listViewWidget(TractorDetailsState state) {
    return Container(
        child: state is LoadMilesSuccessState
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.tractorDetailsModel.loadDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return TractorLoadsDetailsItem(
                    pageName: pageName,
                    loads: state.tractorDetailsModel.loadDetails[index],
                  );
                },
              )
            : state is FuelSuccessState
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.fuelDetailsModel.fuelDetails.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TractorFuelDetailsList(
                        pageName: pageName,
                        fuelModel: state.fuelDetailsModel.fuelDetails[index],
                      );
                    },
                  )
                : state is SettlementSuccessState
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state
                            .settlementDetailsModel.settlementDetails.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TractorFuelDetailsList(
                            pageName: pageName,
                            settlementModel: state.settlementDetailsModel
                                .settlementDetails[index],
                          );
                          ;
                        },
                      )
                    : NoResultFoundWidget());
  }

  //Main Widget
  Widget _mainWidget(TractorDetailsState state) {
    return Stack(
      children: <Widget>[
        // Background widget for overlapping of list widget
        new Column(
          children: <Widget>[
            new Container(
              height: MediaQuery.of(context).size.height * .18,
              color: AppColors.colorAppBar,
              child: Padding(
                  padding: EdgeInsets.only(top: 10), child: _topWidget(state)),
            ),
          ],
        ),
        //This container return a list view with overlapping the background widget
        Container(
            alignment: Alignment.topCenter,
            padding: new EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .12,
            ),
            child: _listViewWidget(state))
      ],
    );
  }

  //Widget to set TOTAL, EMPTY and LOADED Data
  Widget _topWidget(TractorDetailsState state) {
    TractorSettlementModel data;
    if(state is SettlementSuccessState ){
      data=state.settlementDetailsModel;
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            child: (pageName == PageName.LOAD_PAGE ||
                    pageName == PageName.MILES_PAGE)
                ? TopWidgetForLoads(
                    isDetailsPage: true,
                    pageName: pageName,
                    totalMiles: tractorData.totalMiles,
                    totalLoads: tractorData.totalLoads,
                    loadedMiles: tractorData.loadedMiles,
                    loadedLoads: tractorData.loadedLoads,
                    emptyMiles: tractorData.emptyMiles,
                    emptyLoads: tractorData.emptyLoads,
                  )
                : TopWidgetForFuel(
                    pageName: pageName,
                    totalTractorGallons: tractorData.totalTractorGallons,
                    totalFuelCost: tractorData.totalFuelCost,
                    deductions: pageName==PageName.COMPENSATION_PAGE?_loadDetailsBloc.getDeduction(data.settlementDetails):0.0,
                    grossAmount: pageName==PageName.COMPENSATION_PAGE? _loadDetailsBloc.getEarning(data.settlementDetails):0.0,
                  ),
          )
        ],
      ),
    );
  }
}
