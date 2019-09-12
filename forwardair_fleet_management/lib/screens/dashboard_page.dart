import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/blocs/events/dashboardevent.dart';
import 'package:forwardair_fleet_management/blocs/states/dashboardstate.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:forwardair_fleet_management/screens/featurecomingsoon.dart';
import 'package:forwardair_fleet_management/utility/callandmailservice.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/blocs/dashboard_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DashboardState();
  }
}

class DashboardState extends State<DashboardPage> {
  //Dashboard Bloc
  DashboardBloc _dashboardBloc = DashboardBloc();
  //To make a call and send mail
  var _service = CallsAndMailService();
  final RefreshController _refreshController = RefreshController(initialRefresh:  false);
  //To Dispose the DashboardBloc
  @override
  void dispose() {
    _dashboardBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _dashboardBloc.dispatch(FetchDashboardEvent());
    Dashboard_DB_Model _dashboardDataModel = Dashboard_DB_Model();

    return new Scaffold(
      backgroundColor: AppColors.colorDashboard_Bg,
      body:
        SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
          header: WaterDropHeader(),
        onRefresh: ()  {
          _dashboardBloc.dispatch(FetchDashboardEvent());
    },child:
      BlocBuilder<DashboardBloc, dynamic>(
          bloc: _dashboardBloc,
          builder: (context, state) {
            if (state is InitialState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DashboardError) {
              return Center(
                child: Text('Failed to fetch details'),
              );
            } else if (state is DashboardLoaded) {
               if (state.dashboardData != null) {
//                 if (state.dashboardData.isEmpty) {
//                   return Center(
//                     child: Text('no data'),
//                   );
//                 }
                 //To populate This Month data initially
                 for(var i = 0; i < state.dashboardData.length; i++) {
                   if (state.dashboardData[i].dashboardPeriod == Constants.TEXT_DASHBOARD_PERIOD) {
                     _dashboardDataModel = state.dashboardData[i];
                   }
                 } //End
               }

              return ListView.builder(

                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return _buildThisWeekWidget();
                        }
                        if (index == 1) {
                          return _buildWidgetTotalLoadsAndMiles( _dashboardDataModel.totalLoads != null ?
                              '${_dashboardDataModel.totalLoads}' : 'NA',
                              _dashboardDataModel.totalMiles != null ? '${_dashboardDataModel.totalMiles}' : 'NA');
                        } else if (index == 2) {
                          return _buildFuelWidget(
                              _dashboardDataModel.totalTractorGallons != null ? '${_dashboardDataModel.totalTractorGallons}' : 'NA',
                              _dashboardDataModel.totalFuelCost != null ? '${_dashboardDataModel.totalFuelCost}' : 'NA');
                        } else {
                          return _buildNetCompensationWidget(
                              Constants.TEXT_NET_CONPENSATION,
                              _dashboardDataModel.netAmt != null ? '${_dashboardDataModel.netAmt}' : 'NA',
                              _dashboardDataModel.grossAmt != null ? '${_dashboardDataModel.grossAmt}' : 'NA',
                              _dashboardDataModel.deductions != null ? '${_dashboardDataModel.deductions}' : 'NA');
                        }
                  },

              );
            }
          },
        ),),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }

  _refresh() {
     _dashboardBloc.dispatch(FetchDashboardEvent());
  }

  Widget _bottomNavigationBarWidget() {
    return BottomAppBar(
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: AppColors.colorDashboard_Bg,
        height: 100,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          decoration: new BoxDecoration(
            color: Color.fromRGBO(209, 17, 41, 1),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.all(Radius.circular(35)),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                blurRadius: 10.0,
                offset: new Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Container(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            Constants.TEXT_QUICK_CONTACT,
                            style: TextStyle(
                                fontFamily: Constants.FONT_FAMILY_ROBOTO,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: Image.asset('images/ic_mail.png'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: Image.asset('images/ic_call.png'),
                            ),
                          )
                        ])
                      ],
                    )
                  ],
                ),
                onTap: () {
                  //For Sprint 1, its not needed
                  //_buildBottomSheet(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildThisWeekWidget() {
    return Container(
      height: 50,
      decoration: new BoxDecoration(
        color: AppColors.colorBlue,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      margin: new EdgeInsets.only(top: 10, left: 10.0, bottom: 5, right: 10),
      child: Container(
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            trailing: SizedBox(
                width: 28,
                height: 30,
                child: Image.asset('images/ic_calendar.png')),
            leading: Text(
              Constants.TEXT_THISMONTH,
              style: TextStyle(
                  fontFamily: Constants.FONT_FAMILY_ROBOTO,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            onTap: () {
              _weekModalBottomSheet(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _weekFilterWidget(String title) {
    final _textStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontFamily: Constants.FONT_FAMILY_ROBOTO,
      fontSize: 16,
      color: Colors.black,
    );
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: new Text(title, style: _textStyle),
    );
  }

  Widget _weekModalBottomSheet(context) {
    final centerTextAlign = TextAlign.center;
    final weekFilterOptions = [
      Constants.TEXT_THISWEEK,
      Constants.TEXT_LASTWEEK,
      Constants.TEXT_PREV_SETTLEMENT_PERIOD,
      Constants.TEXT_THISMONTH,
      Constants.TEXT_CANCEL
    ];
    final _cancelText = Text(
      Constants.TEXT_CANCEL,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: Constants.FONT_FAMILY_ROBOTO,
        fontSize: 16,
        color: AppColors.colorRed,
      ),
      textAlign: centerTextAlign,
    );
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 300,
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: weekFilterOptions.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 44,
                    child: ListTile(
                      title: index != 4
                          ? _weekFilterWidget(weekFilterOptions[index])
                          : _cancelText,
                      onTap: () {
                        if (index == 4) {
                          Navigator.of(context).pop();
                        } else {
                          //Selected Filter in  Bottom Sheet
                          print(weekFilterOptions[index]);
                        }
                      },
                    ),
                  );
                },
              ));
        });
  }

  _buildWidgetTotalLoadsAndMiles(String totalLoads, String totalMiles) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child:
          new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _totalLoadsAndMilesWidget(Constants.TEXT_TOTAL_LOADS, totalLoads),
        _totalLoadsAndMilesWidget(Constants.TEXT_TOTAL_MILES, totalMiles),
      ]),
    );
  }

  _totalLoadsAndMilesWidget(String aTitle, String aSubTitle) {
    final _titleStyle = TextStyle(
        fontFamily: Constants.FONT_FAMILY_ROBOTO,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.colorBlue);
    final _subTitleStyle = TextStyle(
        fontFamily: Constants.FONT_FAMILY_ROBOTO,
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: AppColors.darkColorBlue);

    return Expanded(
      child: Container(
        margin: aTitle == Constants.TEXT_TOTAL_LOADS
            ? EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 0)
            : EdgeInsets.only(top: 5, bottom: 5, right: 0, left: 5),
        height: 80,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.16),
              blurRadius: 10.0,
              offset: new Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 10.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      aTitle,
                      style: _titleStyle,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 5, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  aTitle == Constants.TEXT_TOTAL_LOADS
                      ? SizedBox(
                          height: 37,
                          child: Text(aSubTitle, style: _subTitleStyle),
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 75.0,
                            maxWidth: 90.0,
                            minHeight: 37.0,
                            maxHeight: 37.0,
                          ),
                          child: AutoSizeText(
                            aSubTitle,
                            style: _subTitleStyle,
                          ),
                        ),
                  Container(
                    padding: EdgeInsets.only(top: 5.0),
                    height: 35,
                    width: 35,
                    child: aTitle == Constants.TEXT_TOTAL_LOADS
                        ? Image.asset(
                            'images/img_total_loads.png',
                          )
                        : Image.asset(
                            'images/img_total_miles.png',
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildFuelWidget(String totalGallons, String totalFuelAmount) {
    final _titleStyle = TextStyle(
      fontFamily: Constants.FONT_FAMILY_ROBOTO,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.colorBlue,
    );
    final _subTitleStyle = TextStyle(
        fontFamily: Constants.FONT_FAMILY_ROBOTO,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.darkColorBlue);

    return Container(
      margin: new EdgeInsets.only(top: 5, left: 10.0, bottom: 5, right: 10),
      height: 90,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 5),
        child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(Constants.TEXT_FUEL, style: _titleStyle),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 27.0,
                            child: Text(totalGallons, style: _subTitleStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text(
                              Constants.TEXT_TOTAL_GALLONS,
                              style: TextStyle(
                                  fontFamily: Constants.FONT_FAMILY_ROBOTO,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.colorTotalGallons),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5.0, right: 10, left: 5),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 35,
                            width: 0.5,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 75.0,
                              maxWidth: 100.0,
                              minHeight: 27.0,
                              maxHeight: 27.0,
                            ),
                            child: AutoSizeText('\$' + totalFuelAmount,
                                style: _subTitleStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text(
                              Constants.TEXT_TOTAL_FUEL_AMOUNT,
                              style: TextStyle(
                                  fontFamily: Constants.FONT_FAMILY_ROBOTO,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.colorTotalGallons),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 35,
                            width: 35,
                            child: Image.asset(
                              'images/img_fuel.png',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }

  _buildNetCompensationWidget(String aTitle, String aSubTitle,
      String grossCompensation, String deductions) {
    final _titleStyle = TextStyle(
      fontFamily: Constants.FONT_FAMILY_ROBOTO,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.colorBlue,
    );
    final _subTitleStyle = TextStyle(
        fontFamily: Constants.FONT_FAMILY_ROBOTO,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: AppColors.darkColorBlue);
    return Container(
      margin: new EdgeInsets.only(left: 10.0, right: 10, top: 5.0, bottom: 5.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 5, right: 5),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(aTitle, style: _titleStyle),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '\$' + aSubTitle,
                        style: _subTitleStyle,
                      ),
                    ),
                    Container(
                      height: 35,
                      width: 35,
                      child: Image.asset(
                        'images/img_net.png',
                      ),
                    ),
                  ],
                ),
                grossCompensationAndDeductionsWiget(
                    Constants.TEXT_GROSS_COMPENSATION,
                    '\$' + grossCompensation,
                    true),
                grossCompensationAndDeductionsWiget(
                    Constants.TEXT_DEDUCTIONS, '\$' + deductions, false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget grossCompensationAndDeductionsWiget(
      String title, String sTitle, bool isForGrossComp) {
    return new Container(
      child: Container(
        padding: EdgeInsets.only(
            left: 5,
            right: 10,
            top: isForGrossComp ? 30 : 10,
            bottom: isForGrossComp ? 10 : 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: new TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorBlue,
                        fontFamily: Constants.FONT_FAMILY_ROBOTO),
                  ),
                  Text(sTitle,
                      style: TextStyle(
                          fontFamily: Constants.FONT_FAMILY_ROBOTO,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkColorBlue)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Divider(
                height: 0.5,
                color: Colors.grey[400],
              ),
            )
          ],
        ),
      ),
    );
  }

//  void _buildBottomSheet(context) {
//    final _textStyle = TextStyle(
//        fontFamily: Constants.FONT_FAMILY_ROBOTO,
//        fontSize: 16,
//        fontWeight: FontWeight.normal,
//        color: Color.fromRGBO(0, 0, 0, 0.87));
//
//    final quickContactList = [
//      Constants.TEXT_DISPATCH,
//      Constants.TEXT_SAFETY_OFFICER,
//      Constants.TEXT_REFERRAL_AND_DRIVERRELATION
//    ];
//
//    showModalBottomSheet(
//        context: context,
//        builder: (BuildContext bc) {
//          return Container(
//              height: 250,
//              child: Column(
//                children: <Widget>[
//                  InkWell(
//                    child: Padding(
//                      padding: const EdgeInsets.only(top: 11.0),
//                      child: Center(
//                        child: Container(
//                          width: 40,
//                          height: 5,
//                          decoration: BoxDecoration(
//                              color: AppColors.colorGreyInBottomSheet,
//                              borderRadius:
//                                  BorderRadius.all(Radius.circular(12.0))),
//                        ),
//                      ),
//                    ),
//                    onTap: () {
//                      Navigator.pop(context);
//                    },
//                  ),
//                  Expanded(
//                    child: ListView.builder(
//                        itemCount: 3,
//                        itemBuilder: (BuildContext context, int index) {
//                          return Container(
//                            decoration: new BoxDecoration(
//                              border: Border(
//                                bottom: BorderSide(
//                                    width: 0.5,
//                                    color: AppColors.colorGreyInBottomSheet),
//                              ),
//                            ),
//                            child: new ListTile(
//                              leading: _userIconWidget(),
//                              title: new Text(quickContactList[index],
//                                  style: _textStyle),
//                              trailing: _roundedIconsRow(index),
//                            ),
//                          );
//                        }),
//                  )
//                ],
//              ));
//        });
//  }

  _userIconWidget() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      height: 40,
      width: 40,
      child: Image.asset(
        'images/ic_avatar_1.png',
      ),
    );
  }

  _roundedIconsRow(int index) {
    return Container(
      width: 150,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        InkWell(
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SizedBox(
              height: 35,
              width: 35,
              child: Image.asset('images/ic_mail_1.png'),
            ),
          ),
          onTap: () {
            switch (index) {
              case 0:
                {
                  _service.sendEmail(Constants.TEXT_DISPATCH_QUCKCONTACT_EMAIL);
                }
                break;
              case 1:
                {
                  _service.sendEmail(Constants.TEXT_SAFETY_QUCKCONTACT_EMAIL);
                }
                break;
              case 2:
                {
                  _service.sendEmail(
                      Constants.TEXT_DRIVER_RELATIONS_QUCKCONTACT_EMAIL);
                }
                break;
            }
          },
        ),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SizedBox(
              height: 35,
              width: 35,
              child: Image.asset('images/ic_call_1.png'),
            ),
          ),
          onTap: () {
            switch (index) {
              case 0:
                {
                  _service.call(Constants.TEXT_DISPATCH_PHONENUMBER);
                }
                break;
              case 1:
                {
                  _service.call(Constants.TEXT_SAFETY_PHONENUMBER);
                }
                break;
              case 2:
                {
                  _service.call(Constants.TEXT_DRIVER_RELATIONS_PHONENUMBER);
                }
                break;
            }
          },
        )
      ]),
    );
  }

  void navigateToFeatureComingSoonPage() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade, child: FeaturesComingSoonPage()));
  }
}
