import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/components/pager_widget.dart';
import 'package:forwardair_fleet_management/components/pie_chart_widget.dart';
import 'package:forwardair_fleet_management/components/shimmer/load_page_shimmer.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/blocs/barrels/load.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'load_detail.dart';

class LoadPage extends StatefulWidget {
  //True if coming from Load Page
  final bool isLoadPage;
  final Dashboard_DB_Model dashboardData;

  const LoadPage({Key key, this.isLoadPage, this.dashboardData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoadScreen(isLoadPage, dashboardData);
  }
}

class LoadScreen extends State<LoadPage> {
  final bool isLoadPage;
  final Dashboard_DB_Model dashboardData;
  final loadBloc = LoadBloc();
  final _controller = new PageController();
  static const _duration = const Duration(milliseconds: 300);
  static const _curve = Curves.ease;
  var tractorData;

  static Map<String, double> dataMap = Map<String, double>();

  List<Widget> _pages = <Widget>[
    PieChartWidget(
      colorList: AppColors.colorListPieChart,
      dataMap: dataMap,
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child:
          new FlutterLogo(style: FlutterLogoStyle.stacked, colors: Colors.red),
    ),
  ];

  LoadScreen(this.isLoadPage, this.dashboardData);

  @override
  void initState() {
    //Call Api For Tractor data and Chart data
    //Check condition i.e for week data or month data
    if (dashboardData != null &&
        (dashboardData.dashboardPeriod ==
            Constants.TEXT_DASHBOARD_PERIOD_THIS_MONTH)) {
      loadBloc.dispatch(GetTractorDataEvent(
          isMiles: isLoadPage,
          month: dashboardData.month,
          year: int.parse(dashboardData.year),
          weekEnd: null,
          weekStart: null));
    } else {
      loadBloc.dispatch(GetTractorDataEvent(
          isMiles: isLoadPage,
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
          text: !isLoadPage ? 'Load' : 'Miles',
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
      ),
      body: BlocListener<LoadBloc, LoadStates>(
        listener: (context, state) {
          if (state is SuccessState) {
            var subList = state.tractorData.tractors.length > 10
                ? state.tractorData.tractors.sublist(0, 10)
                : state.tractorData.tractors;
            if (isLoadPage) {
              subList.forEach((v) => dataMap.putIfAbsent(
                  "${v.tractorId}", () => v.totalLoadsPercent));
            } else {
              subList.forEach((v) => dataMap.putIfAbsent(
                  "${v.tractorId}", () => v.totalMilesPercent));
            }
          }
        },
        bloc: loadBloc,
        child: BlocBuilder<LoadBloc, LoadStates>(
            bloc: loadBloc,
            builder: (context, state) {
              if (state is ErrorState) {
                return Container(
                  child: Center(child: Text("Error")),
                );
              }
              if (state is ShimmerState) {
                return LoadPageShimmer();
              }

              if (state is SuccessState) {
                return _initialWidget(state.tractorData);
              }
              return LoadPageShimmer();
            }),
      ),
    );
  }

  Widget _initialWidget(TractorData tractorData) {
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
                itemCount: 2,
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
            _listView(tractorData.tractors.length > 10
                ? tractorData.tractors.sublist(0, 10)
                : tractorData.tractors),
            //Widget for Other Text
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColors.colorDashboard_Bg,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 12, bottom: 12),
                child: TextWidget(
                  text: 'Others',
                  isBold: true,
                  textType: TextType.TEXT_MEDIUM,
                ),
              ),
            ),
            _listView(tractorData.tractors.length > 10
                ? tractorData.tractors.sublist(10, tractorData.tractors.length)
                : tractorData.tractors),
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
            text: dashboardData.weekStart != null ? 'This Week' : 'This Month',
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
                          text: !isLoadPage
                              ? '${dashboardData.totalLoads}'
                              : '${dashboardData.totalMiles}',
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
                          color: Colors.blue,
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
                  text: "Top Contributors",
                  isBold: true,
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      child: TextWidget(
                        text: 'Sort By',
                        textType: TextType.TEXT_MEDIUM,
                      ),
                      onTap: () {
                        _sortByOptionsWidget();
                      },
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                )
              ]),
        ),
      ),
    );
  }

  //empty and load percentage for top rows
  String _calculateEmptyPercentage() {
    if (!isLoadPage) {
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
    if (!isLoadPage) {
      return ((dashboardData.loadedMiles * 100) / dashboardData.totalMiles)
              .toStringAsFixed(2) +
          '%';
    } else {
      return ((dashboardData.loadedLoads * 100) / dashboardData.totalLoads)
              .toStringAsFixed(2) +
          '%';
    }
  }

  //This widget return a list view for tractor details
  Widget _listView(List<Tractor> modelData) {
    print(modelData.length);
    return Container(
      color: AppColors.colorWhite,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: modelData.length,
        itemBuilder: (context, index) {
          // var post = modelData[index];
          return InkWell(
            child: Padding(
              padding: EdgeInsets.only(left: 4.0, right: 4.0),
              child: Card(
                child: Container(
                  height: 65,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    ClipOval(
                                      child: Container(
                                        color: AppColors.colorDOT,
                                        height: 8.0,
                                        width: 8.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextWidget(
                                        text:
                                            'Tractor ID :  ${modelData[index].tractorId}',
                                        textType: TextType.TEXT_MEDIUM,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8.0),
                                  child: TextWidget(
                                    textType: TextType.TEXT_MEDIUM,
                                    text: !isLoadPage
                                        ? 'Contribution(%) :  ${modelData[index].totalLoadsPercent}'
                                        : 'Contribution(%) :  ${modelData[index].totalMilesPercent}',
                                  ),
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 3,
                          child: Container(
                            height: 65,
                            color: AppColors.colorListItem,
                            child: Center(
                              child: TextWidget(
                                text: !isLoadPage
                                    ? '${modelData[index].totalLoads}'
                                    : '${modelData[index].totalMiles}',
                                colorText: AppColors.colorWhite,
                                textType: TextType.TEXT_MEDIUM,
                                isBold: true,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: LoadDetailsPage(
                          isLoadPage, modelData[index], dashboardData)));
            },
          );
        },
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
                return TextWidget(
                  textType: TextType.TEXT_MEDIUM,
                  padding: EdgeInsets.all(8.0),
                  text: sortFilterOptions[index],
                );
              },
            ),
          );
        });
  }
}
