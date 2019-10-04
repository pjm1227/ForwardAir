import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/components/load_list_widget.dart';
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

  List<Widget> _pages = <Widget>[
    Column(
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
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: StackedBarChart(
        seriesList: seriesListBarChart,
        animate: true,
      ),
    ),
  ];

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
          text: pageName == PageName.LOAD_PAGE ? 'Load' : 'Miles',
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
      ),
      body: BlocListener<LoadBloc, LoadStates>(
        listener: (context, state) {
          if (state is SuccessState) {
            //Set data in Stacked Bar chart
            createDataForBarChart(state.loadChartData);
            //Create Pie chart
            createPieChart(state.tractorData);
            loadBloc.dispatch(SortHighToLowEvent(
                pageName: pageName, tractorData: listTractorData));
          }
          if (state is SortState) {
            //Create Pie chart
            //  createPieChart(state.tractorData);
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
              return LoadPageShimmer();
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
            //Widget for Pie chart
            Container(
              height: 220,
              child: PageView.builder(
                itemCount: _pages.length,
                physics: new AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  return _pages[index % _pages.length];
                },
              ),
            ),
            //Widget for Dots indicator
            Container(
              child: new Center(
                child: new DotsIndicator(
                  controller: _controller,
                  itemCount: _pages.length,
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
            LoadListViewWidget(
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
                              ? '${Utils.formatDecimalToWholeNumber(dashboardData.totalLoads)}'
                              : '${Utils.formatDecimalToWholeNumber(dashboardData.totalMiles)}',
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
                          text: _calculateEmptyPercentage(),
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
                          color: Colors.teal,
                          height: 8.0,
                          width: 8.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: TextWidget(
                          text: _calculateLoadPercentage(),
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

  //empty and load percentage for top rows
  String _calculateEmptyPercentage() {
    if (pageName == PageName.MILES_PAGE) {
      return ((dashboardData.emptyMiles * 100) / dashboardData.totalMiles)
              .toStringAsFixed(2) +
          '%';
    } else {
      return ((dashboardData.emptyLoads * 100) / dashboardData.totalLoads)
              .toStringAsFixed(2) +
          '%';
    }
  }

  //empty and load percentage for top rows
  String _calculateLoadPercentage() {
    if (pageName == PageName.MILES_PAGE) {
      return ((dashboardData.loadedMiles * 100) / dashboardData.totalMiles)
              .toStringAsFixed(2) +
          '%';
    } else {
      return ((dashboardData.loadedLoads * 100) / dashboardData.totalLoads)
              .toStringAsFixed(2) +
          '%';
    }
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
  void createDataForBarChart(dynamic chartData) {
    //clear the list first
    seriesListBarChart.clear();
    //Create loaded data List
    var loadedDataList = List<ChartDataModel>();
    //Create Empty data List
    var emptyDataList = List<ChartDataModel>();
    //Create total data List
    var totalDataList = List<ChartDataModel>();
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
    if (chartData is ChartDataWeeks) {
      //Here data belongs to weeks
      var weekData = chartData.days;
      //Create chart data model for empty data, loaded data and Total
      if (weekData != null) {
        weekData.forEach((item) {
          var chartModelLoaded = ChartDataModel(
              name: weekList[count] +
                  '\n${pageName == PageName.LOAD_PAGE ? Utils.formatDecimalToWholeNumber(item.totalLoads) : Utils.formatDecimalToWholeNumber(item.totalMiles)}',
              loadsValue: pageName == PageName.LOAD_PAGE
                  ? item.loadedLoads
                  : item.loadedMiles);
          var chartModelEmpty = ChartDataModel(
              name: weekList[count] +
                  '\n${pageName == PageName.LOAD_PAGE ? Utils.formatDecimalToWholeNumber(item.totalLoads) : Utils.formatDecimalToWholeNumber(item.totalMiles)}',
              loadsValue: pageName == PageName.LOAD_PAGE
                  ? item.emptyLoads
                  : item.emptyMiles);
          /* var chartModelTotal = ChartDataModel(
              name: weekList[count] +
                  '\n${pageName == PageName.LOAD_PAGE ? item.totalLoads : item.totalMiles}',
              value: pageName == PageName.LOAD_PAGE
                  ? item.totalLoads
                  : item.totalMiles);*/
          //Add data models into respective list
          loadedDataList.add(chartModelLoaded);
          emptyDataList.add(chartModelEmpty);
          // totalDataList.add(chartModelTotal);
          count++;
        });
      }
      //Check if chart data is for month
    } else if (chartData is ChartDataMonth) {
      //Here data belongs to weeks
      var monthData = chartData.weeks;
      //Create chart data model for empty data, loaded data and total
      monthData.forEach((item) {
        var chartModelLoaded = ChartDataModel(
            name: 'Week ${count + 1}' +
                '\n${pageName == PageName.LOAD_PAGE ? Utils.formatDecimalToWholeNumber(item.totalLoads) : Utils.formatDecimalToWholeNumber(item.totalMiles)}',
            loadsValue: pageName == PageName.LOAD_PAGE
                ? item.loadedLoads
                : item.loadedMiles);
        var chartModelEmpty = ChartDataModel(
            name: 'Week ${count + 1}' +
                '\n${pageName == PageName.LOAD_PAGE ? Utils.formatDecimalToWholeNumber(item.totalLoads) : Utils.formatDecimalToWholeNumber(item.totalMiles)}',
            loadsValue: pageName == PageName.LOAD_PAGE
                ? item.emptyLoads
                : item.emptyMiles);
        /* var chartModelTotal = ChartDataModel(
            name: 'Week ${count + 1}'
                '\n${pageName == PageName.LOAD_PAGE ? item.totalLoads : item.totalMiles}',
            value: item.totalLoads);*/
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
/*  var totalChartData = charts.Series<ChartDataModel, String>(
      id: 'Total',
      domainFn: (ChartDataModel chartData, _) => chartData.name,
      measureFn: (ChartDataModel chartData, _) => chartData.value,
      colorFn: (_, __) => charts.MaterialPalette.white,
      data: totalDataList,
    );*/
//Add final model data in series list to show chart
    seriesListBarChart.add(loadedChartData);
    seriesListBarChart.add(emptyChartData);
    //seriesList.add(totalChartData);
  }

  //This method is used to set data in pie chart
  // The Pie chart shows 11 divisions of the chart area representing the top 10
  // load contributors & one division area representing the consolidated load
  // count of remaining contributors.
  void createPieChart(TractorData tractorData) {
    //Check if List have more then 10 data, then take a sublist if first 10 elements
    // And show them into pie chart
    //first clear the series List for pie chart
    seriesListPieChart.clear();
    //Create  data List
    var chartDataList = List<ChartDataModel>();
    if (tractorData.tractors.length > 10) {
      var subTractorList = tractorData.tractors.sublist(0, 10);
      for (int i = 0; i < subTractorList.length; i++) {
        var chartModel = ChartDataModel(
            name: subTractorList[i].tractorId,
            value: pageName == PageName.LOAD_PAGE
                ? subTractorList[i].totalLoadsPercent
                : subTractorList[i].totalMilesPercent,
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
          tractorData.tractors.sublist(10, tractorData.tractors.length);

      double sum = 0.0;
      remainingItemList.forEach((item) {
        sum = sum +
            (pageName == PageName.LOAD_PAGE
                ? item.totalLoadsPercent
                : item.totalMilesPercent);
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
      for (int i = 0; i < tractorData.tractors.length; i++) {
        var chartModel = ChartDataModel(
            name: tractorData.tractors[i].tractorId,
            value: pageName == PageName.LOAD_PAGE
                ? tractorData.tractors[i].totalLoadsPercent
                : tractorData.tractors[i].totalMilesPercent,
            color: AppColors.colorListPieChart[i]);
        chartDataList.add(chartModel);
        //Create a map object to map Tractor data with color code for dot
        var mapOBJ = Map<Tractor, Color>();
        mapOBJ.putIfAbsent(
            tractorData.tractors[i], () => AppColors.colorListForDots[i]);
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
}
