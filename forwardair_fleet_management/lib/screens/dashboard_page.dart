import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:page_transition/page_transition.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:forwardair_fleet_management/blocs/events/dashboardevent.dart';
import 'package:forwardair_fleet_management/blocs/states/dashboardstate.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/screens/featurecomingsoon.dart';
import 'package:forwardair_fleet_management/utility/callandmailservice.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/blocs/dashboard_bloc.dart';
import 'package:forwardair_fleet_management/screens/drill_down_screen.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';

/*
  DashboardPage to display dashboard details.
*/

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

  //To Dispose the DashboardBloc
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
      return Center(child: CircularProgressIndicator());
    } else if (state is DashboardError) {
      //If any error occurs, while fetching teh data
      return Center(child: Text('Failed to fetch details'));
    } else if (state is DashboardLoaded ||
        state is OpenQuickContactsState ||
        state is QuickContactsMailState ||
        state is QuickContactsCallState) {
      //To update the ListView, once data comes
      if (state.dashboardData != null) {
        //To populate This Month data initially
        for (var i = 0; i < state.dashboardData.length; i++) {
          if (state.dashboardData[i].dashboardPeriod ==
              Constants.TEXT_DASHBOARD_PERIOD) {
            _dashboardDataModel = state.dashboardData[i];
          }
        } //End
        if (_dashboardDataModel.dashboardPeriod != null) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              //To display This Week filter widget
              if (index == 0) {
                return _buildThisWeekWidget();
              }
              //To display Total loads and Total Miles widget
              if (index == 1) {
                return _buildWidgetTotalLoadsAndMiles(
                    _dashboardDataModel.totalLoads != null
                        ? '${Utils().formatDecimalToWholeNumber(_dashboardDataModel.totalLoads)}'
                        : 'NA',
                    _dashboardDataModel.totalMiles != null
                        ? '${Utils().formatDecimalToWholeNumber(_dashboardDataModel.totalMiles)}'
                        : 'NA');
              }
              //To display Fuel widget
              else if (index == 2) {
                return _buildFuelWidget(
                    _dashboardDataModel.totalTractorGallons != null
                        ? '${Utils().formatDecimalToWholeNumber(_dashboardDataModel.totalTractorGallons)}'
                        : 'NA',
                    _dashboardDataModel.totalFuelCost != null
                        ? '${Utils().formatDecimalToWholeNumber(_dashboardDataModel.totalFuelCost)}'
                        : 'NA');
              }
              //To Display NetCompensation and Deductions Widget
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
        } else {
          //If any error occurs, while fetching teh data
          return Center(child: Text('Failed to fetch details'));
        }
      } else {
        //If any error occurs, while fetching teh data
        return Center(child: Text('Failed to fetch details'));
      }
    }
  }

  //This returns the Widget of Dashboard Page
  @override
  Widget build(BuildContext context) {
    //To fetch the data Initially
    _dashboardBloc.dispatch(FetchDashboardEvent());
    //This returns the Dashboard Widget
    return Scaffold(
      backgroundColor: AppColors.colorDashboard_Bg,
      //BlocBuilder
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
                  _service.sendEmail(_quickContactEmails[0]);
                }
                break;
              case 1:
                {
                  _service.sendEmail(_quickContactEmails[1]);
                }
                break;
              case 2:
                {
                  _service.sendEmail(_quickContactEmails[2]);
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
          }
        },
        child: BlocBuilder<DashboardBloc, dynamic>(
          bloc: _dashboardBloc,
          builder: (context, state) {
            //Pull Refresh Option
            return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                header: MaterialClassicHeader(),
                onRefresh: () {
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

  //Qucik Constacts Widget
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
                  //To show the Quick Contact Details
                  _dashboardBloc.dispatch(OpenQuickContactsEvent());

                  // _buildBottomSheet(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  //This return the This week Filter widget
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
            leading: TextWidget(
                text: Constants.TEXT_THISMONTH,
                textType: TextType.TEXT_MEDIUM,
                isBold: true,
                colorText: AppColors.colorWhite),
            onTap: () {
              _weekModalBottomSheet(context);
            },
          ),
        ),
      ),
    );
  }

  //This return the Text of the This week Filter
  Widget _weekFilterWidget(String title) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: TextWidget(
        text: title,
        textType: TextType.TEXT_MEDIUM,
        colorText: AppColors.colorBlack,
      ),
    );
  }

  //This return the Bottom sheet when user taps on This week Filter
  Widget _weekModalBottomSheet(context) {
    //To Align a Text
    final centerTextAlign = TextAlign.center;
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
      colorText: AppColors.colorRed,
      textAlign: centerTextAlign,
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
    final _subTitleStyle = TextStyle(
        fontFamily: Constants.FONT_FAMILY_ROBOTO,
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: AppColors.darkColorBlue);

    return Expanded(
      child: new InkWell(
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
                      child: TextWidget(
                        text: aTitle,
                        textType: TextType.TEXT_SMALL,
                        colorText: AppColors.colorBlue,
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
        onTap: () {
          navigateToDrillDownPage(
              aTitle == Constants.TEXT_TOTAL_LOADS ? false : true);
          print(aTitle == Constants.TEXT_TOTAL_LOADS ? 'Loads' : 'Miles');
        },
      ),
    );
  }

  //This returns Fuel Widget
  _buildFuelWidget(String totalGallons, String totalFuelAmount) {
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
                  child: TextWidget(
                    text: Constants.TEXT_FUEL,
                    textType: TextType.TEXT_SMALL,
                    colorText: AppColors.colorBlue,
                  ),
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
                            child: TextWidget(
                              text: totalGallons,
                              colorText: AppColors.darkColorBlue,
                              textType: TextType.TEXT_XLARGE,
                              isBold: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: TextWidget(
                                text: Constants.TEXT_TOTAL_GALLONS,
                                colorText: AppColors.colorTotalGallons),
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
                            child: AutoSizeText(totalFuelAmount + '\$',
                                style: _subTitleStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: TextWidget(
                                text: Constants.TEXT_TOTAL_FUEL_AMOUNT,
                                colorText: AppColors.colorTotalGallons),
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
                        text: aSubTitle + '\$',
                        colorText: AppColors.darkColorBlue,
                        textType: TextType.TEXT_XLARGE,
                        isBold: true,
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
                    grossCompensation + '\$',
                    true),
                grossCompensationAndDeductionsWiget(
                    Constants.TEXT_DEDUCTIONS, deductions + '\$', false),
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
                  TextWidget(
                    text: title,
                    isBold: true,
                    colorText: AppColors.colorBlue,
                  ),
                  TextWidget(
                      text: sTitle,
                      isBold: true,
                      textType: TextType.TEXT_LARGE,
                      colorText: AppColors.darkColorBlue),
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

  void _buildBottomSheet(context) {
    final _textSubStyle = TextStyle(
        fontFamily: Constants.FONT_FAMILY_ROBOTO,
        fontSize: 11,
        fontWeight: FontWeight.normal,
        color: AppColors.lightBlack);

    final quickContactList = [
      Constants.TEXT_DISPATCH,
      Constants.TEXT_SAFETY_OFFICER,
      Constants.TEXT_REFERRAL_AND_DRIVERRELATION
    ];

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
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
                              height: 90,
                              child: new ListTile(
                                leading: _userIconWidget(),
                                title: TextWidget(
                                  text: quickContactList[index],
                                  textType: TextType.TEXT_MEDIUM,
                                  colorText: AppColors.lightBlack,
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: new Text(
                                              _quickContactEmails[index],
                                              style: _textSubStyle,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: new Text(
                                                _quickContactPhoneNumbers[
                                                    index],
                                                style: _textSubStyle),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: _roundedIconsRow(index),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ));
        });
  }

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
            padding: const EdgeInsets.only(left: 5, right: 12.0),
            child: SizedBox(
              height: 40,
              width: 40,
              child: Image.asset('images/ic_mail_1.png'),
            ),
          ),
          onTap: () {
            _dashboardBloc
                .dispatch(QuickContactTapsOnMailEvent(selectedIndex: index));
//            switch (index) {
//              case 0:
//                {
//                  _service.sendEmail(Constants.TEXT_DISPATCH_QUCKCONTACT_EMAIL);
//                }
//                break;
//              case 1:
//                {
//                  _service.sendEmail(Constants.TEXT_SAFETY_QUCKCONTACT_EMAIL);
//                }
//                break;
//              case 2:
//                {
//                  _service.sendEmail(
//                      Constants.TEXT_DRIVER_RELATIONS_QUCKCONTACT_EMAIL);
//                }
//                break;
//            }
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
            _dashboardBloc
                .dispatch(QuickContactTapsOnCallEvent(selectedIndex: index));

//            switch (index) {
//              case 0:
//                {
//                  _service.call(Constants.TEXT_DISPATCH_PHONENUMBER);
//                }
//                break;
//              case 1:
//                {
//                  _service.call(Constants.TEXT_SAFETY_PHONENUMBER);
//                }
//                break;
//              case 2:
//                {
//                  _service.call(Constants.TEXT_DRIVER_RELATIONS_PHONENUMBER);
//                }
//                break;
//            }
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

  void navigateToDrillDownPage(bool isMiles) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: LoadsPage(isMiles, _dashboardDataModel)));
  }
}
