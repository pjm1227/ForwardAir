import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:forwardair_fleet_management/blocs/barrels/settlement.dart';
import 'package:forwardair_fleet_management/components/shimmer/settlement_shimmer.dart';
import 'package:forwardair_fleet_management/screens/featurecomingsoon.dart';
import 'package:forwardair_fleet_management/screens/sidemenu.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:forwardair_fleet_management/models/settlement_data_model.dart';
import 'package:forwardair_fleet_management/components/no_internet_connection.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/blocs/settlement_bloc.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
/*
  SettlementPage to display Settlement details.
*/

class SettlementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettlementPageState();
  }
}

class SettlementPageState extends State<SettlementPage> {
  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  //Dashboard Bloc
  SettlementBloc _settlementBloc = SettlementBloc();
  SettlementModel _settlementModel = SettlementModel();
  List<SettlementCheck> filteredSettlementChecks = [];
  int _selectedMonth = 0;
  int _selectedYear = 0;
  DateTime _fromDateTime = new DateTime.now();

  //To Dispose
  @override
  void dispose() {
    _settlementBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //Call Api For Settlement data
    var now = _fromDateTime;
    _settlementBloc.dispatch(GetSettlementDataEvent(month: 03, year: now.year));
    super.initState();
  }

  //This returns Dashboard Page
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

  //To navigate to FeatureComingSoonPage
  void navigateToFeatureComingSoonPage() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade, child: FeaturesComingSoonPage()));
  }

  //This is the main widget for this page
  Widget _mainWidget() {
    return Scaffold(
      key: _scaffold,
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: false,
        //AppBar Title
        title: TextWidget(
          text: Constants.TEXT_SETTLEMENTS,
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
      ),
      drawer: SideMenuPage(
        scaffold: _scaffold,
      ),
      body: BlocListener<SettlementBloc, SettlementStates>(
        listener: (context, state) {
          if (state is PickedDateState) {
            _fromDateTime = state.pickedDate;
            String pickedDateText = Utils.pickerDateToFormat(_fromDateTime);
            filteredSettlementChecks = [];
            for (var aSettlementCheck in _settlementModel.settlementChecks) {
              String pickedMonthText = Utils.pickOnlyMonthInCheckList(aSettlementCheck.checkDt);
              if (pickedMonthText == pickedDateText) {
                filteredSettlementChecks.add(aSettlementCheck);
              }
            }
          }
        },
        bloc: _settlementBloc,
        child: BlocBuilder<SettlementBloc, SettlementStates>(
            bloc: _settlementBloc,
            builder: (context, state) {
              print("State Settlement Screen $state");
              if (state is ErrorState) {
                if (state.errorMessage == Constants.NO_INTERNET_FOUND) {
                  return NoInternetFoundWidget();
                } else {
                  return NoResultFoundWidget();
                }
              } else if (state is ShimmerState) {
                return SettlementShimmerPage();
              } else if (state is SuccessState) {
                if (state.settlementData != null) {
                  if (state.settlementData.settlementChecks != null &&
                      state.settlementData.settlementChecks.length != 0) {
                    //Populate List Data
                    _settlementModel = state.settlementData;
                    return mainListWidget(_settlementModel.settlementChecks);
                  } else {
                    return NoResultFoundWidget();
                  }
                } else {
                  return NoResultFoundWidget();
                }
              } else if (state is PickedDateState) {
                _fromDateTime = state.pickedDate;
                if (filteredSettlementChecks.length == 0) {
                  return ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        _buildThisWeekWidget(
                            Utils.dateNowToFormat(_fromDateTime)),
                        Center(child: (Text('No Matching Data Found.')))
                      ]);
                } else {
                  return mainListWidget(filteredSettlementChecks);
                }
              } else {
                return NoResultFoundWidget();
              }
            }),
      ),
    );
  }

  Widget mainListWidget(List<SettlementCheck> settlementChecks) {
    return ListView(scrollDirection: Axis.vertical, children: <Widget>[
      _buildThisWeekWidget(Utils.dateNowToFormat(_fromDateTime)),
      _listViewWidget(settlementChecks)
    ]);
  }

  Future<Null> _selectDate(BuildContext context) async {

    showMonthPicker(
        context: context,
        firstDate: DateTime( DateTime.now().year - 2 , 5),
        lastDate: DateTime( DateTime.now().year + 1, 9 ),
        initialDate: _fromDateTime
    ).then((picked) {
      if (picked != null && picked != _fromDateTime) {
        _settlementBloc.dispatch(PickedDateEvent(pickedDate: picked));
      }
    });


//    final DateTime picked = await showDatePicker(
//
//      initialDatePickerMode: DatePickerMode.year,
//
//        context: context,
//        initialDate: _fromDateTime,
//        firstDate: new DateTime(2019),
//        lastDate: new DateTime(2020));
//    if (picked != null && picked != _fromDateTime) {
//      _settlementBloc.dispatch(PickedDateEvent(pickedDate: picked));
//    }
  }

  Widget _listViewWidget(List<SettlementCheck> settlementChecks) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: settlementChecks.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItemsWidget(settlementChecks[index]);
      },
    );
  }

  _buildListItemsWidget(SettlementCheck _settlementCheck) {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 12, left: 10, right: 10, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(
                  textOverFlow: TextOverflow.ellipsis,
                  text: _settlementBloc
                      .startAndEndDateCheckDate(_settlementCheck),
                  textType: TextType.TEXT_SMALL,
                  colorText: AppColors.colorBlack,
                ),
                TextWidget(
                  textOverFlow: TextOverflow.ellipsis,
                  text: _settlementBloc.getCheckAmount(_settlementCheck),
                  textType: TextType.TEXT_SMALL,
                  colorText: AppColors.colorBlack,
                  isBold: true,
                ),
              ],
            ),
          ),
          Divider(
            height: 0.5,
          ),
          Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextWidget(
                    textAlign: TextAlign.left,
                    textOverFlow: TextOverflow.ellipsis,
                    text: 'Check ID',
                    textType: TextType.TEXT_SMALL,
                    colorText: AppColors.colorGrey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextWidget(
                      textAlign: TextAlign.left,
                      textOverFlow: TextOverflow.ellipsis,
                      text: _settlementCheck.checkNbr,
                      textType: TextType.TEXT_SMALL,
                      colorText: AppColors.darkColorBlue,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  //This return the This week Filter widget
  _buildThisWeekWidget(String aTitle) {
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
                text: aTitle,
                textType: TextType.TEXT_MEDIUM,
                isBold: true,
                colorText: AppColors.colorWhite),
            onTap: () {
              _selectDate(context);
            },
          ),
        ),
      ),
    );
  }
}
