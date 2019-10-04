import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:page_transition/page_transition.dart';

import 'package:forwardair_fleet_management/components/no_internet_connection.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/components/shimmer/dashboard_shimmer.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:forwardair_fleet_management/blocs/events/dashboardevent.dart';
import 'package:forwardair_fleet_management/blocs/states/dashboardstate.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/screens/featurecomingsoon.dart';
import 'package:forwardair_fleet_management/utility/callandmailservice.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/blocs/dashboard_bloc.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'load_screen.dart';

/*
  DashboardPage to display dashboard details.
*/

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<DashboardPage> {
  //Dashboard Bloc
  DashboardBloc _dashboardBloc = DashboardBloc();
  //To make a call and send mail
  var _service = CallsAndMailService();
  //Selected Index in Filter
  int _selectedIndex = 3;
  //Pull to refresh
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Dashboard_DB_Model _dashboardDataModel = Dashboard_DB_Model();
  final _quickContactEmails = [
    Constants.TEXT_DISPATCH_QUCKCONTACT_EMAIL,
    Constants.TEXT_SAFETY_QUCKCONTACT_EMAIL,
    Constants.TEXT_DRIVER_RELATIONS_QUCKCONTACT_EMAIL
  ];
  final _quickContactPhoneNumbers = [
    Constants.TEXT_DISPATCH_PHONENUMBER,
    Constants.TEXT_SAFETY_PHONENUMBER,
    Constants.TEXT_DRIVER_RELATIONS_PHONENUMBER
  ];
  //To handle Call button Tap in Quick contacts
  bool _isTappable = false;

  //To Dispose
  @override
  void dispose() {
    _dashboardBloc.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  //Child Widgets of the Refresh Controller
  Widget _childWidgetToRefresh(dynamic state) {
    _refreshController.refreshCompleted();
    if (state is InitialState) {
      //Initial State
      _dashboardBloc.isAPICalling = true;
      return Center(child: DashBoardShimmer());
    } else if (state is DashboardError) {
      //Error State
      if (_dashboardBloc.noInternetText != '') {
        _dashboardBloc.isAPICalling = false;
        return NoInternetFoundWidget();
      } else {
        _dashboardBloc.isAPICalling = false;
        return NoResultFoundWidget();
      }
    } // Success State
    else if (state is DashboardLoaded ||
        state is OpenQuickContactsState ||
        state is QuickContactsMailState ||
        state is QuickContactsCallState ||
        state is DrillDownPageState) {
      if (state.dashboardData != null) {
        _dashboardDataModel = state.dashboardData;
        //Fetched Data
        if (_dashboardDataModel.dashboardPeriod != null) {
          _dashboardBloc.isAPICalling = false;
          return _listViewWidget();
        } else {
          //No Data Found
          _dashboardBloc.isAPICalling = false;
          return NoResultFoundWidget();
        }
      } else {
        //No Data Found
        _dashboardBloc.isAPICalling = false;
        return NoResultFoundWidget();
      }
    } //ApplyFilter State
    else if (state is ApplyFilterState) {
      _dashboardDataModel = state.aModel;
      _selectedIndex = state.selectedIndex;
      _dashboardBloc.isAPICalling = false;
      return _listViewWidget();
    } else {
      //No Data Found
      _dashboardBloc.isAPICalling = false;
      return NoResultFoundWidget();
    }
  }

  Widget _listViewWidget() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        //Filter widget
        if (index == 0) {
          final filterPeriod = _dashboardBloc
              .convertPeriodToTitle(_dashboardDataModel.dashboardPeriod);
          return _buildThisWeekWidget(filterPeriod);
        }
        //Total loads and Total Miles widget
        if (index == 1) {
          return _buildWidgetTotalLoadsAndMiles(
              _dashboardDataModel.totalLoads != null
                  ? '${Utils.formatDecimalToWholeNumber(_dashboardDataModel.totalLoads)}'
                  : 'NA',
              _dashboardDataModel.totalMiles != null
                  ? '${Utils.formatDecimalToWholeNumber(_dashboardDataModel.totalMiles)}'
                  : 'NA');
        }
        //Fuel widget
        else if (index == 2) {
          return _buildFuelWidget(
              _dashboardDataModel.totalTractorGallons != null
                  ? '${Utils.formatDecimalToWholeNumber(_dashboardDataModel.totalTractorGallons)}'
                  : 'NA',
              _dashboardDataModel.totalFuelCost != null
                  ? '${Utils.formatDecimalToWholeNumber(_dashboardDataModel.totalFuelCost)}'
                  : 'NA');
        }
        //NetCompensation and Deductions Widget
        else {
          return _buildNetCompensationWidget(
              Constants.TEXT_NET_CONPENSATION,
              _dashboardDataModel.netAmt != null
                  ? '${Utils().formatDecimalsNumber(_dashboardDataModel.netAmt)}'
                  : 'NA',
              _dashboardDataModel.grossAmt != null
                  ? '${Utils().formatDecimalsNumber(_dashboardDataModel.grossAmt)}'
                  : 'NA',
              _dashboardDataModel.deductions != null
                  ? '${Utils().formatDecimalsNumber(_dashboardDataModel.deductions)}'
                  : 'NA');
        }
      },
    );
  }

  //This returns Dashboard Page
  @override
  Widget build(BuildContext context) {
    //To fetch the data Initially
    _dashboardBloc.dispatch(FetchDashboardEvent());
    return Scaffold(
      backgroundColor: AppColors.colorDashboard_Bg,
      //BlocListener
      body: BlocListener<DashboardBloc, dynamic>(
        bloc: _dashboardBloc,
        condition: (previousState, currentState) {
          return true;
        },
        listener: (context, state) {
          if (state is OpenQuickContactsState) {
            _buildBottomSheet(context);
          } else if (state is QuickContactsMailState) {
            switch (state.selectedIndex) {
              case 0:
                {
                  _service.sendEmail(_quickContactEmails[0],
                      Constants.TEXT_QC_DISPATCH_MAIL_SUBJECT);
                }
                break;
              case 1:
                {
                  _service.sendEmail(_quickContactEmails[1],
                      Constants.TEXT_QC_SAFETY_MAIL_SUBJECT);
                }
                break;
              case 2:
                {
                  _service.sendEmail(_quickContactEmails[2],
                      Constants.TEXT_QC_DRIVER_RELATIONS_MAIL_SUBJECT);
                }
                break;
            }
          } else if (state is QuickContactsCallState) {
            switch (state.selectedIndex) {
              case 0:
                {
                  _service.call(_quickContactPhoneNumbers[0]);
                }
                break;
              case 1:
                {
                  _service.call(_quickContactPhoneNumbers[1]);
                }
                break;
              case 2:
                {
                  _service.call(_quickContactPhoneNumbers[2]);
                }
                break;
            }
          } else if (state is DrillDownPageState) {
            navigateToDrillDownPage(state.pageName);
          }

          if (state is QuickContactsCallState) {
            if (Platform.isIOS) {
              print('delaying');
              Future.delayed(const Duration(seconds: 1), () {
                print('after 1 sec');
                _isTappable = true;
              });
            } else {
              _isTappable = true;
            }
          }
        },
        //BlocBuilder
        child: BlocBuilder<DashboardBloc, dynamic>(
          bloc: _dashboardBloc,
          builder: (context, state) {
            //Pull Refresh Option
            return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                header: MaterialClassicHeader(),
                onRefresh: () {
                  _dashboardBloc.isAPICalling = true;
                  _dashboardBloc.dispatch(PullToRefreshDashboardEvent());
                },
                child: _childWidgetToRefresh(state));
          },
        ),
      ),
      //Quick Contacts
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }

  //Quick Contacts Widget
  Widget _bottomNavigationBarWidget() {
    return BottomAppBar(
      elevation: 0,
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
              child: _handleTapEventForQuickContact(),
            ),
          ),
        ),
      ),
    );
  }

  Widget redColorBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TextWidget(
                text: Constants.TEXT_QUICK_CONTACT,
                colorText: AppColors.colorWhite,
                textType: TextType.TEXT_SMALL,
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(children: [
              Container(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Image(
                      image: new AssetImage('images/ic_mail.png'),
                      fit: BoxFit.fill),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 20.0),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Image(
                      image: new AssetImage('images/ic_call.png'),
                      fit: BoxFit.fill),
                ),
              )
            ])
          ],
        )
      ],
    );
  }

  //Open Quick Tap Handler
  Widget _handleTapEventForQuickContact() {
    return InkWell(
      onDoubleTap: () {},
      child: redColorBottomBar(),
      onTap: () {
        if (_dashboardBloc.isAPICalling == false) {
          _isTappable = true;
          _dashboardBloc.dispatch(OpenQuickContactsEvent());
        } else {
          print('Ignoring Taps');
        }
      },
    );
  }

  //This return the This week Filter widget
  _buildThisWeekWidget(String aFilterTitle) {
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
            leading: TextWidget(
                textOverFlow: TextOverflow.ellipsis,
                text: aFilterTitle,
                textType: TextType.TEXT_MEDIUM,
                isBold: true,
                colorText: AppColors.colorWhite),
            onTap: () {
              if (_dashboardBloc.isAPICalling == false) {
                _weekModalBottomSheet(context);
              }
            },
          ),
        ),
      ),
    );
  }

  //This return the Bottom sheet when user taps on This week Filter
  Widget _weekModalBottomSheet(context) {
    //List of options in filter bootom sheet
    final weekFilterOptions = [
      Constants.TEXT_THISWEEK,
      Constants.TEXT_LASTWEEK,
      Constants.TEXT_PREV_SETTLEMENT_PERIOD,
      Constants.TEXT_THISMONTH,
      Constants.TEXT_CANCEL
    ];

    //Text Style of the Cancel Text
    final _cancelText = TextWidget(
      text: Constants.TEXT_CANCEL,
      textType: TextType.TEXT_MEDIUM,
      colorText: AppColors.colorBlack,
      textAlign: TextAlign.center,
    );
    //This Returns bottom sheet
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
                          ? _weekFilterWidget(weekFilterOptions[index], index)
                          : _cancelText,
                      onTap: () {
                        if (index == 4) {
                          Navigator.of(context).pop();
                        } else {
                          //Selected Filter in  Bottom Sheet
                          Navigator.of(context).pop();
                          var selectedPeriodText = _dashboardBloc
                              .convertTitleToPeriod(weekFilterOptions[index]);
                          _dashboardBloc.dispatch(ApplyFilterEvent(
                              selectedIndex: index,
                              selectedDashboardPeriod: selectedPeriodText));
                        }
                      },
                    ),
                  );
                },
              ));
        });
  }

  //Text of the Filter
  Widget _weekFilterWidget(String title, int index) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: TextWidget(
        textOverFlow: TextOverflow.ellipsis,
        text: title,
        textType: TextType.TEXT_MEDIUM,
        colorText:
            _selectedIndex == index ? AppColors.colorRed : AppColors.colorBlack,
      ),
    );
  }

  //This returns Holder of TotalLoadsAndMiles Widget
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

  //This returns TotalLoadsAndMiles Widget
  _totalLoadsAndMilesWidget(String aTitle, String aSubTitle) {
    return Expanded(
      child: new InkWell(
        child: Container(
          margin: aTitle == Constants.TEXT_TOTAL_LOADS
              ? EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 0)
              : EdgeInsets.only(top: 5, bottom: 5, right: 0, left: 5),
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
                      child: TextWidget(
                        textOverFlow: TextOverflow.ellipsis,
                        text: aTitle,
                        textType: TextType.TEXT_SMALL,
                        colorText: AppColors.colorBlue,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 5, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        child: TextWidget(
                          textOverFlow: TextOverflow.ellipsis,
                          text: aSubTitle,
                          textType: TextType.TEXT_MEDIUM,
                          colorText: AppColors.darkColorBlue,
                          isBold: true,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0, right: 5),
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
        onTap: () {
          _dashboardBloc.dispatch(DrillDownPageEvent(
              pageName: aTitle == Constants.TEXT_TOTAL_LOADS
                  ? PageName.LOAD_PAGE
                  : PageName.MILES_PAGE));
        },
      ),
    );
  }

  //This returns Fuel Widget
  _buildFuelWidget(String totalGallons, String totalFuelAmount) {
    return Container(
      margin: new EdgeInsets.only(top: 5, left: 10.0, bottom: 5, right: 10),
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
                  child: TextWidget(
                    text: Constants.TEXT_FUEL,
                    textType: TextType.TEXT_SMALL,
                    colorText: AppColors.colorBlue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: TextWidget(
                                    textOverFlow: TextOverflow.ellipsis,
                                    text: totalGallons,
                                    textType: TextType.TEXT_MEDIUM,
                                    colorText: AppColors.darkColorBlue,
                                    isBold: true,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextWidget(
                                    textOverFlow: TextOverflow.ellipsis,
                                    text: Constants.TEXT_TOTAL_GALLONS,
                                    colorText: AppColors.colorTotalGallons),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, right: 10, left: 5),
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
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(top: 5, right: 10),
                                  child: TextWidget(
                                    textOverFlow: TextOverflow.ellipsis,
                                    text: _dashboardBloc.appendDollarSymbol(
                                        totalFuelAmount), //'\$' + totalFuelAmount,
                                    textType: TextType.TEXT_MEDIUM,
                                    colorText: AppColors.darkColorBlue,
                                    isBold: true,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextWidget(
                                    textOverFlow: TextOverflow.ellipsis,
                                    text: Constants.TEXT_TOTAL_FUEL_AMOUNT,
                                    colorText: AppColors.colorTotalGallons),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0.0, top: 5),
                          child: Container(
                            padding: EdgeInsets.only(top: 5, left: 10),
                            height: 30,
                            width: 30,
                            child: Image(
                              image: AssetImage('images/img_fuel.png'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  //This returns NetCompensationWidget Widget
  _buildNetCompensationWidget(String aTitle, String aSubTitle,
      String grossCompensation, String deductions) {
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
                    TextWidget(
                      textOverFlow: TextOverflow.ellipsis,
                      text: aTitle,
                      textType: TextType.TEXT_SMALL,
                      colorText: AppColors.colorBlue,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextWidget(
                        textOverFlow: TextOverflow.ellipsis,
                        text: _dashboardBloc
                            .appendDollarSymbol(aSubTitle), //'\$' + aSubTitle,
                        colorText: AppColors.darkColorBlue,
                        textType: TextType.TEXT_MEDIUM,
                        isBold: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 3, bottom: 2),
                            height: 32,
                            width: 35,
                            child: Image.asset(
                              'images/img_net.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                grossCompensationAndDeductionsWiget(
                    Constants.TEXT_GROSS_COMPENSATION,
                    _dashboardBloc.appendDollarSymbol(
                        grossCompensation), //'\$' + grossCompensation,
                    true),
                grossCompensationAndDeductionsWiget(Constants.TEXT_DEDUCTIONS,
                    _dashboardBloc.addDollarAfterMinusSign(deductions), false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //This returns Gross Compensation And Deductions Wiget
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
                  Expanded(
                    child: TextWidget(
                      textOverFlow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      text: title,
                      isBold: true,
                      colorText: AppColors.colorBlue,
                    ),
                  ),
                  Expanded(
                    child: TextWidget(
                        textOverFlow: TextOverflow.ellipsis,
                        text: sTitle,
                        textAlign: TextAlign.right,
                        isBold: true,
                        textType: TextType.TEXT_MEDIUM,
                        colorText: AppColors.darkColorBlue),
                  ),
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

  //Quick Contact Modal Sheet
  Widget _quickContactModalSheet() {
    final quickContactList = [
      Constants.TEXT_DISPATCH,
      Constants.TEXT_SAFETY_OFFICER,
      Constants.TEXT_REFERRAL_AND_DRIVERRELATION
    ];
    return Container(
        height: MediaQuery.of(context).size.height * .40,
        child: Column(
          children: <Widget>[
            InkWell(
              child: Container(
                height: 30,
                width: 50,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.colorGreyInBottomSheet,
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: new BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 0.5,
                              color: AppColors.colorGreyInBottomSheet),
                        ),
                      ),
                      child: Container(
                        child: new ListTile(
                          leading: _userIconWidget(index),
                          title: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextWidget(
                              textOverFlow: TextOverflow.ellipsis,
                              text: quickContactList[index],
                              textType: TextType.TEXT_NORMAL,
                              colorText: AppColors.lightBlack,
                            ),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 5,
                                      ),
                                      child: TextWidget(
                                        textOverFlow: TextOverflow.ellipsis,
                                        text: _quickContactEmails[index],
                                        colorText: AppColors.lightBlack,
                                        textType: TextType.TEXT_XSMALL,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: TextWidget(
                                        textOverFlow: TextOverflow.ellipsis,
                                        text: _quickContactPhoneNumbers[index],
                                        colorText: AppColors.lightBlack,
                                        textType: TextType.TEXT_XSMALL,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: _roundedIconsRow(index),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ));
  }

  //Bottom Sheet
  void _buildBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return _quickContactModalSheet();
        });
  }

  //User Icons
  _userIconWidget(int index) {
    String imageName = '';
    switch (index) {
      case 0:
        imageName = 'images/ic_dispatch.png';
        break;
      case 1:
        imageName = 'images/ic_safety.png';
        break;
      case 2:
        imageName = 'images/ic_driver_relations.png';
        break;
    }
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      height: 40,
      width: 40,
      child: Image.asset(
        imageName,
      ),
    );
  }

  _roundedIconsRow(int index) {
    return Container(
      width: 100,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        InkWell(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 10.0),
            child: SizedBox(
              height: 35,
              width: 35,
              child: Image(
                  image: AssetImage('images/ic_mail.png'), fit: BoxFit.fill),
            ),
          ),
          onDoubleTap: () {},
          onTap: () {
            _dashboardBloc
                .dispatch(QuickContactTapsOnMailEvent(selectedIndex: index));
          },
        ),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5.0),
            child: SizedBox(
              height: 35,
              width: 35,
              child: Image(
                  image: AssetImage('images/ic_call.png'), fit: BoxFit.fill),
            ),
          ),
          onDoubleTap: () {},
          onTap: () {
            print('isTappable calue : $_isTappable');
            if (_isTappable) {
              _isTappable = false;
              _dashboardBloc
                  .dispatch(QuickContactTapsOnCallEvent(selectedIndex: index));
            }
          },
        )
      ]),
    );
  }

  //To navigate to FeatureComingSoonPage
  void navigateToFeatureComingSoonPage() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade, child: FeaturesComingSoonPage()));
  }

  //To navigate to Drill Down
  void navigateToDrillDownPage(PageName pageName) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: LoadPage(
                pageName: pageName, dashboardData: _dashboardDataModel)));
  }
}
