import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/components/donut_chart.dart';
import 'package:forwardair_fleet_management/components/top_widget_fuel.dart';
import 'package:forwardair_fleet_management/components/top_widget_loads.dart';
import 'package:forwardair_fleet_management/components/tractor_list_widget.dart';
import 'package:forwardair_fleet_management/components/no_internet_connection.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/components/pager_widget.dart';
import 'package:forwardair_fleet_management/components/pie_chart_widget.dart';
import 'package:forwardair_fleet_management/components/shimmer/load_page_shimmer.dart';
import 'package:forwardair_fleet_management/components/stacked_bar_chart.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/chart_data_model.dart';
import 'package:forwardair_fleet_management/models/chart_data_month.dart';
import 'package:forwardair_fleet_management/models/chart_data_weeks.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/blocs/barrels/load.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:forwardair_fleet_management/utility/utils.dart';

import '../test.dart';

class LoadPage extends StatefulWidget {
  //True if coming from Load Page
  final PageName pageName;
  final Dashboard_DB_Model dashboardData;

  const LoadPage({Key key, this.pageName, this.dashboardData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoadScreen(pageName, dashboardData);
  }
}

class LoadScreen extends State<LoadPage> {
  //Page name enum
  final PageName pageName;

  //Dashboard data model object
  final Dashboard_DB_Model dashboardData;

  //Bloc object
  final loadBloc = LoadBloc();

  //Page controller for charts
  final _controller = new PageController();

  //Duration for page controller
  static const _duration = const Duration(milliseconds: 300);

  //curve for dots
  static const _curve = Curves.ease;

  //List for Bar Chart
  static List<charts.Series<ChartDataModel, String>> seriesListBarChart =
      List<charts.Series<ChartDataModel, String>>();

  //List for Pie Chart
  static List<charts.Series<ChartDataModel, String>> seriesListPieChart =
      List<charts.Series<ChartDataModel, String>>();

  //List for List view
  List<Map<Tractor, Color>> listTractorData = List<Map<Tractor, Color>>();

  //Text for top contribution
  String _topContribution = Constants.TEXT_HIGHTOLOW;

  //boolean variables to check if user press Fuel Gallons and Total Fuel Amount for Fuel Screen
  bool isGallonClicked = false, isTotalAmountClicked = false;

  //TractorData
  TractorData _tractorData;

  //Chart data for Bar Chart
  dynamic _chartData;

  LoadScreen(this.pageName, this.dashboardData);

  @override
  void initState() {
    print("Page Name is : $pageName");
    //Call Api For Tractor data and Chart data
    //Check condition i.e for week data or month data
    if (dashboardData != null &&
        (dashboardData.dashboardPeriod ==
            Constants.TEXT_DASHBOARD_PERIOD_THIS_MONTH)) {
      loadBloc.dispatch(GetTractorDataEvent(
          month: dashboardData.month,
          year: int.parse(dashboardData.year),
          weekEnd: null,
          weekStart: null,
          pageName: pageName));
    } else {
      loadBloc.dispatch(GetTractorDataEvent(
          pageName: pageName,
          month: 0,
          year: 0,
          weekEnd: dashboardData.weekEnd,
          weekStart: dashboardData.weekStart));
    }
    loadBloc.dispatch(
        FuelGallonsEvent(isGallonClicked: true, isTotalAmountClicked: false));
    // loadBloc.dispatch(GetTractorDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Check conditions for Status bar
    //It's platform specific
    if (Platform.isAndroid) {
      return SafeArea(
        child: _mainWidget(),
      );
    } else {
      return _mainWidget();
    }
  }

  //This is the main widget for this page
  Widget _mainWidget() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.colorWhite),
        title: TextWidget(
          text: pageName == PageName.LOAD_PAGE
              ? 'Loads'
              : pageName == PageName.MILES_PAGE
                  ? 'Miles'
                  : pageName == PageName.FUEL_PAGE
                      ? 'Fuel'
                      : 'Net Compensation',
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
      ),
      body: BlocListener<LoadBloc, LoadStates>(
        listener: (context, state) {
          if (state is SuccessState) {
            //Set data in Stacked Bar chart
            createDataForBarChart(true);
            //Get tractor model from state
            _tractorData = state.tractorData;
            //Get chart Model from State
            _chartData = state.loadChartData;
            //Create Pie chart
            createPieChart(true);
            loadBloc.dispatch(SortHighToLowEvent(
                pageName: pageName, tractorData: listTractorData));
          }
          if (state is SortState) {
            //Create Pie chart
            //  createPieChart(state.tractorData);
          }
          if (state is FuelGallonsAmountState) {
            isGallonClicked = state.isGallonClicked;
            isTotalAmountClicked = state.isTotalAmountClicked;
            createPieChart(isGallonClicked);
            createDataForBarChart(isGallonClicked);
          }
        },
        bloc: loadBloc,
        child: BlocBuilder<LoadBloc, LoadStates>(
            bloc: loadBloc,
            builder: (context, state) {
              print("State Load Scree $state");
              if (state is ErrorState) {
                if (state.errorMessage == Constants.NO_INTERNET_FOUND) {
                  return NoInternetFoundWidget();
                } else {
                  return NoResultFoundWidget();
                }
              }
              if (state is ShimmerState) {
                return LoadPageShimmer();
              }

              if (state is SuccessState) {
                if (state.tractorData.tractors != null) {
                  return _initialWidget();
                } else {
                  return NoResultFoundWidget();
                }
              }
              if (state is SortState) {
                return _initialWidget();
              }
              return _initialWidget();
            }),
      ),
    );
  }

  //Initial Widget
  Widget _initialWidget() {
    var pager = new PageController();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: AppColors.colorAppBar,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Top widget
            _topWidget(),
            //Widget to show Fuel Gallons and Total Fuel Amount, This widget will be
            //visible for Fuel and Compensation page
            Container(
              child: pageName == PageName.FUEL_PAGE
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: TextWidget(
                                  text: 'Fuel Gallons',
                                  colorText: AppColors.colorWhite,
                                  isBold: isGallonClicked,
                                )),
                                SizedBox(
                                  width: 70,
                                  child: Container(
                                    child: isGallonClicked
                                        ? Divider(
                                            color: AppColors.colorWhite,
                                            height: 10,
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            loadBloc.dispatch(FuelGallonsEvent(
                                isGallonClicked: true,
                                isTotalAmountClicked: false));
                          },
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: TextWidget(
                                  text: 'Total Fuel Amount',
                                  colorText: AppColors.colorWhite,
                                  isBold: isTotalAmountClicked,
                                )),
                                SizedBox(
                                  width: 100,
                                  child: isTotalAmountClicked
                                      ? Container(
                                          child: Divider(
                                            color: AppColors.colorWhite,
                                            height: 10,
                                          ),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            loadBloc.dispatch(FuelGallonsEvent(
                                isGallonClicked: false,
                                isTotalAmountClicked: true));
                          },
                        ),
                      ],
                    )
                  : null,
            ),
            //Widget for Pie chart
            Container(
              height: 220,
              child: PageView.builder(
                itemCount: 2,
                physics: new AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  return _pagerWidgets(index);
                },
              ),
            ),
            //Widget for Dots indicator
            Container(
              child: new Center(
                child: new DotsIndicator(
                  controller: _controller,
                  itemCount: 2,
                  onPageSelected: (int page) {
                    _controller.animateToPage(
                      page,
                      duration: _duration,
                      curve: _curve,
                    );
                  },
                ),
              ),
            ),
            //Widget to show Header for sort by options
            _sortByHeader(),
            //List View Widget
            TractorListWidget(
                tractorList: listTractorData,
                pageName: pageName,
                dashboardData: dashboardData),
          ],
        ),
      ),
    );
  }

  //Widget to set TOTAL, EMPTY and LOADED Data
  Widget _topWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          TextWidget(
            text: dashboardData.dashboardPeriod != null
                ? dashboardData.dashboardPeriod ==
                        Constants.TEXT_DASHBOARD_PERIOD_THIS_MONTH
                    ? "This Month"
                    : dashboardData.dashboardPeriod ==
                            Constants.TEXT_DASHBOARD_PERIOD_LAST_WEEK
                        ? "Last Week"
                        : dashboardData.dashboardPeriod ==
                                Constants.TEXT_DASHBOARD_PERIOD_THIS_WEEK
                            ? "This Week"
                            : dashboardData.dashboardPeriod ==
                                    Constants
                                        .TEXT_DASHBOARD_PREVIOUS_SETTLEMENT_PERIOD
                                ? "Previous Settelement Period"
                                : 'N/A'
                : "N/A",
            colorText: AppColors.colorWhite,
            textType: TextType.TEXT_SMALL,
            //  padding: EdgeInsets.all(8.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              height: 2,
              color: Colors.white,
            ),
          ),
          //Here we're checking condition to change the Widget for Loads/Miles and Fuel/Compensation page
          Container(
              child: (pageName == PageName.LOAD_PAGE ||
                      pageName == PageName.MILES_PAGE)
                  ? TopWidgetForLoads(
                      isDetailsPage: false,
                      pageName: pageName,
                      emptyLoads: dashboardData.emptyLoads,
                      emptyMiles: dashboardData.emptyMiles,
                      loadedLoads: dashboardData.loadedLoads,
                      loadedMiles: dashboardData.loadedMiles,
                      totalLoads: dashboardData.totalLoads,
                      totalMiles: dashboardData.totalMiles,
                    )
                  : TopWidgetForFuel(
                      pageName: pageName,
                      grossAmount: dashboardData.grossAmt,
                      deductions: dashboardData.deductions,
                      totalFuelCost: dashboardData.totalFuelCost,
                      totalTractorGallons: dashboardData.totalTractorGallons,
                    ) //_topRowForFuel(),
              ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              height: 2,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  //This widget return the header widget for sort by options
  Widget _sortByHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        color: AppColors.colorDashboard_Bg,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(
                  text: _topContribution,
                  isBold: true,
                ),
                InkWell(
                  child: Row(
                    children: <Widget>[
                      TextWidget(
                        text: 'Sort By',
                        textType: TextType.TEXT_MEDIUM,
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                  onTap: () {
                    _sortByOptionsWidget();
                  },
                )
              ]),
        ),
      ),
    );
  }

  //This method show the bottom options for sorting
  _sortByOptionsWidget() {
    //To Align a Text
    final centerTextAlign = TextAlign.center;
    //List of options in filter bottom sheet
    final sortFilterOptions = [
      Constants.TEXT_HIGHTOLOW,
      Constants.TEXT_LOWTOHIGH,
      Constants.TEXT_ASCENDING,
      Constants.TEXT_DESCENDING,
    ];
    //This Returns bottom sheet
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * .35,
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: sortFilterOptions.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        textType: TextType.TEXT_MEDIUM,
                        colorText: _topContribution == sortFilterOptions[index]
                            ? AppColors.colorRed
                            : null,
                        padding:
                            EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
                        text: sortFilterOptions[index],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Icon(
                          _topContribution == sortFilterOptions[index]
                              ? Icons.done
                              : null,
                          color: AppColors.colorRed,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _topContribution = sortFilterOptions[index];
                      // _controller.jumpTo(1);
                    });
                    if (index == 0) {
                      loadBloc.dispatch(SortHighToLowEvent(
                          pageName: pageName, tractorData: listTractorData));
                    } else if (index == 1) {
                      loadBloc.dispatch(SortLowToHighEvent(
                          pageName: pageName, tractorData: listTractorData));
                    } else if (index == 2) {
                      loadBloc.dispatch(SortAscendingTractorIDEvent(
                          pageName: pageName, tractorData: listTractorData));
                    } else {
                      loadBloc.dispatch(SortDescendingTractorIDEvent(
                          pageName: pageName, tractorData: listTractorData));
                    }
                    Navigator.pop(context);
                  },
                );
              },
            ),
          );
        });
  }

  //This method called when we set data in bar chart, Firstly we will check data
  //Type i.e weeks data or month data
  void createDataForBarChart(bool isFuelGallons) {
    //clear the list first
    seriesListBarChart.clear();
    //Create loaded data List
    var loadedDataList = List<ChartDataModel>();
    //Create Empty data List
    var emptyDataList = List<ChartDataModel>();
    //Create a list with the week names, as we are not getting week names from
    //API
    var weekList = List<String>();
    //Add week names in List
    weekList.add("Su");
    weekList.add("Mo");
    weekList.add("Tu");
    weekList.add("We");
    weekList.add("Th");
    weekList.add("Fr");
    weekList.add("Sa");
    var count = 0; // will use in for each loop
    //Check if we get data for weeks
    if (_chartData is ChartDataWeeks) {
      //Here data belongs to weeks
      var weekData = _chartData.days;
      //Create chart data model for empty data, loaded data and Total
      if (weekData != null) {
        weekData.forEach((item) {
          var chartModelLoaded = ChartDataModel(
              name: weekList[count] +
                  '\n${pageName == PageName.LOAD_PAGE ? Utils.formatDecimalToWholeNumber(item.totalLoads) : pageName == PageName.MILES_PAGE ? Utils.formatDecimalToWholeNumber(item.totalMiles) : pageName == PageName.FUEL_PAGE ? Utils.formatDecimalToWholeNumber(item.totalTractorGallons) : Utils.formatDecimalToWholeNumber(item.totalFuelCost)}',
              loadsValue: pageName == PageName.LOAD_PAGE
                  ? item.loadedLoads
                  : pageName == PageName.MILES_PAGE
                      ? item.loadedMiles
                      : pageName == PageName.FUEL_PAGE
                          ? isFuelGallons
                              ? item.totalTractorGallons.toInt()
                              : item.totalFuelCost.toInt()
                          : item.totalFuelCost.toInt());
          var chartModelEmpty = ChartDataModel(
              name: weekList[count] +
                  '\n${pageName == PageName.LOAD_PAGE ? Utils.formatDecimalToWholeNumber(item.totalLoads) : pageName == PageName.MILES_PAGE ? Utils.formatDecimalToWholeNumber(item.totalMiles) : pageName == PageName.FUEL_PAGE ? Utils.formatDecimalToWholeNumber(item.totalTractorGallons) : Utils.formatDecimalToWholeNumber(item.totalFuelCost)}',
              loadsValue: pageName == PageName.LOAD_PAGE
                  ? item.emptyLoads
                  : pageName == PageName.MILES_PAGE
                      ? item.emptyMiles
                      : pageName == PageName.FUEL_PAGE ? 0 : 0);
          //Add data models into respective list
          loadedDataList.add(chartModelLoaded);
          emptyDataList.add(chartModelEmpty);
          // totalDataList.add(chartModelTotal);
          count++;
        });
      }
      //Check if chart data is for month
    } else if (_chartData is ChartDataMonth) {
      //Here data belongs to weeks
      var monthData = _chartData.weeks;
      //Create chart data model for empty data, loaded data and total
      monthData.forEach((item) {
        var chartModelLoaded = ChartDataModel(
            name: 'Week ${count + 1}' +
                '\n${pageName == PageName.LOAD_PAGE ? Utils.formatDecimalToWholeNumber(item.totalLoads) : pageName == PageName.MILES_PAGE ? Utils.formatDecimalToWholeNumber(item.totalMiles) : pageName == PageName.FUEL_PAGE ? Utils.formatDecimalToWholeNumber(item.totalTractorGallons) : Utils.formatDecimalToWholeNumber(item.totalFuelCost)}',
            loadsValue: pageName == PageName.LOAD_PAGE
                ? item.loadedLoads
                : pageName == PageName.MILES_PAGE
                    ? item.loadedMiles
                    : pageName == PageName.FUEL_PAGE
                        ? isFuelGallons
                            ? item.totalTractorGallons.toInt()
                            : item.totalFuelCost.toInt()
                        : item.totalFuelCost.toInt());
        var chartModelEmpty = ChartDataModel(
            name: 'Week ${count + 1}' +
                '\n${pageName == PageName.LOAD_PAGE ? Utils.formatDecimalToWholeNumber(item.totalLoads) : pageName == PageName.MILES_PAGE ? Utils.formatDecimalToWholeNumber(item.totalMiles) : pageName == PageName.FUEL_PAGE ? Utils.formatDecimalToWholeNumber(item.totalTractorGallons) : Utils.formatDecimalToWholeNumber(item.totalFuelCost)}',
            loadsValue: pageName == PageName.LOAD_PAGE
                ? item.emptyLoads
                : pageName == PageName.MILES_PAGE
                    ? item.emptyMiles
                    : pageName == PageName.FUEL_PAGE ? 0 : 0);
        //Add data models into respective list
        loadedDataList.add(chartModelLoaded);
        emptyDataList.add(chartModelEmpty);
        // totalDataList.add(chartModelTotal);
        count++;
      });
    }
    var emptyChartData = charts.Series<ChartDataModel, String>(
      id: 'Empty',
      domainFn: (ChartDataModel chartData, _) => chartData.name,
      measureFn: (ChartDataModel chartData, _) => chartData.loadsValue,
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      data: emptyDataList,
    );
    var loadedChartData = charts.Series<ChartDataModel, String>(
      id: 'Loaded',
      domainFn: (ChartDataModel chartData, _) => chartData.name,
      measureFn: (ChartDataModel chartData, _) => chartData.loadsValue,
      colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
      data: loadedDataList,
    );
//Add final model data in series list to show chart
    seriesListBarChart.add(loadedChartData);
    seriesListBarChart.add(emptyChartData);
    //seriesList.add(totalChartData);
  }

  //This method is used to set data in pie chart
  // The Pie chart shows 11 divisions of the chart area representing the top 10
  // load contributors & one division area representing the consolidated load
  // count of remaining contributors.
  void createPieChart(bool isFuelGallons) {
    //Check if List have more then 10 data, then take a sublist if first 10 elements
    // And show them into pie chart
    //first clear the series List for pie chart
    seriesListPieChart.clear();
    //Clear the tractor data list
    listTractorData.clear();
    //Create  data List
    var chartDataList = List<ChartDataModel>();
    if (_tractorData.tractors.length > 10) {
      var subTractorList = _tractorData.tractors.sublist(0, 10);
      for (int i = 0; i < subTractorList.length; i++) {
        var chartModel = ChartDataModel(
            name: subTractorList[i].tractorId,
            value: pageName == PageName.LOAD_PAGE
                ? subTractorList[i].totalLoadsPercent
                : pageName == PageName.MILES_PAGE
                    ? subTractorList[i].totalMilesPercent
                    : pageName == PageName.FUEL_PAGE
                        ? isFuelGallons
                            ? subTractorList[i].totalGallonsPercent
                            : subTractorList[i].totalFuelCost
                        : subTractorList[i].totalNetPercent,
            color: AppColors.colorListPieChart[i]);
        chartDataList.add(chartModel);
        //Create a map object to map Tractor data with color code for dot
        var mapOBJ = Map<Tractor, Color>();
        mapOBJ.putIfAbsent(
            subTractorList[i], () => AppColors.colorListForDots[i]);
        //Add data in Tractor list to show in list view
        listTractorData.add(mapOBJ);
      }
      //Now we have to show 11th division of pie chart, i.e the total percentage
      // of remaining items, So check first if we have items in list
      var remainingItemList =
          _tractorData.tractors.sublist(10, _tractorData.tractors.length);

      double sum = 0.0;
      remainingItemList.forEach((item) {
        sum = sum +
            (pageName == PageName.LOAD_PAGE
                ? item.totalLoadsPercent
                : pageName == PageName.MILES_PAGE
                    ? item.totalMilesPercent
                    : pageName == PageName.FUEL_PAGE
                        ? isFuelGallons
                            ? item.totalGallonsPercent
                            : item.totalFuelCost
                        : item.totalNetPercent);
      });
      //Add the sum of remaining loads in to data map list for pie chart
      chartDataList.add(ChartDataModel(
          value: num.parse(sum.toStringAsFixed(2)),
          name: "11th",
          color: charts.Color(r: 255, g: 255, b: 255)));
      //Now Add remaining Items in Tractor list to show data data
      remainingItemList.forEach((item) {
        var mapOBJ = Map<Tractor, Color>();
        mapOBJ.putIfAbsent(item, () => AppColors.colorWhite);
        //Add data in Tractor list to show in list view
        listTractorData.add(mapOBJ);
      });
      //If list size if less then 10 then set the list data in chart
    } else {
      //For loop to add tractor data into list for chart
      for (int i = 0; i < _tractorData.tractors.length; i++) {
        var chartModel = ChartDataModel(
            name: _tractorData.tractors[i].tractorId,
            value: pageName == PageName.LOAD_PAGE
                ? _tractorData.tractors[i].totalLoadsPercent
                : _tractorData.tractors[i].totalMilesPercent,
            color: AppColors.colorListPieChart[i]);
        chartDataList.add(chartModel);
        //Create a map object to map Tractor data with color code for dot
        var mapOBJ = Map<Tractor, Color>();
        mapOBJ.putIfAbsent(
            _tractorData.tractors[i], () => AppColors.colorListForDots[i]);
        //Add data in Tractor list to show in list view
        listTractorData.add(mapOBJ);
      }
    }

    //Create pie chart basic properties here
    var pieChart = charts.Series<ChartDataModel, String>(
      id: 'TopContributor',
      domainFn: (ChartDataModel sales, _) => sales.name,
      measureFn: (ChartDataModel sales, _) => sales.value,
      data: chartDataList,
      // Set a label accessor to control the text of the arc label.
      labelAccessorFn: (ChartDataModel row, _) => '${row.value}',
      colorFn: (ChartDataModel clickData, _) => clickData.color,
      insideLabelStyleAccessorFn: (_, __) =>
          charts.TextStyleSpec(color: charts.Color(r: 255, g: 255, b: 255)),
      outsideLabelStyleAccessorFn: (ChartDataModel sales, _) {
        return new charts.TextStyleSpec(
            color: charts.Color(r: 255, g: 255, b: 255));
      },
    );
    //Add chart data into series list
    seriesListPieChart.add(pieChart);
  }

  //This method returns widgets for PagerView
  Widget _pagerWidgets(int index) {
    Widget _widget;

    switch (index) {
      case 0:
        _widget = Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: PieChartWidget(
                seriesListPieChart,
                animate: true,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
        break;
      case 1:
        _widget = Padding(
          padding: const EdgeInsets.all(8.0),
          child: pageName == PageName.COMPENSATION_PAGE
              ? DonutPieChart(
                  grossAmount: dashboardData.grossAmt,
                  deductions: dashboardData.deductions,
                )
              : StackedBarChart(
                  seriesList: seriesListBarChart,
                  animate: true,
                ),
        );
        break;
    }
    return _widget;
  }
}
