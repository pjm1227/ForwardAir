import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:forwardair_fleet_management/screens/tractor_details_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:forwardair_fleet_management/screens/settlement_detail_page.dart';
import 'package:forwardair_fleet_management/blocs/barrels/settlement.dart';
import 'package:forwardair_fleet_management/components/shimmer/settlement_shimmer.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:forwardair_fleet_management/models/settlement_data_model.dart';
import 'package:forwardair_fleet_management/components/no_internet_connection.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
/*
  SettlementPage to display Settlement list.
*/

class SettlementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettlementPageState();
  }
}

class SettlementPageState extends State<SettlementPage> {
  //Settlement Bloc
  SettlementBloc _settlementBloc = SettlementBloc();
  //Settlement Model
  SettlementModel _settlementModel = SettlementModel();
  //Filtered List
  List<SettlementCheck> filteredSettlementChecks = [];
  //Picker Date
  DateTime _fromDateTime = new DateTime.now();

  //To Dispose Bloc
  @override
  void dispose() {
    _settlementBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //Call Api For Settlement data
    _settlementBloc.dispatch(GetSettlementDataEvent(month: _fromDateTime.month, year: _fromDateTime.year));
    super.initState();
  }

  //This returns Settlement Page
  @override
  Widget build(BuildContext context) {
    //Check conditions for Status bar
    if (Platform.isAndroid) {
      return SafeArea(
        child: _mainWidget(),
      );
    } else {
      return _mainWidget();
    }
  }

  //To navigate to FeatureComingSoonPage
  void navigateToSettlementDetailPage(
      SettlementCheck _checkModel, String appBarTitle) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: SettlementDetailsPage(
              settlementCheck: _checkModel,
              appBarTitle: appBarTitle,
            )));
  }

  Widget dateNotFoundWidgetWithCalendarTopBar(String errorMsg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildThisWeekWidget(
            Utils.dateNowToFormat(_fromDateTime)),
        Expanded(
          child: errorMsg == Constants.NO_INTERNET_FOUND ? NoInternetFoundWidget() : NoResultFoundWidget(),
        )
      ],
    );
  }

  //This is the main widget for this page
  Widget _mainWidget() {
    return Scaffold(
      //BlocListener to check condition according to state
      //Basically it used to navigate to page
      body: BlocListener<SettlementBloc, SettlementStates>(
        listener: (context, state) {
          if (state is PickedDateState) {
            _fromDateTime = state.pickedDate;
            filteredSettlementChecks = [];
            if (_settlementModel.settlementChecks != null && _settlementModel.settlementChecks.length > 0) {
              filteredSettlementChecks =
                  _settlementBloc.applyPickerDateToSettlementList(
                      _fromDateTime, _settlementModel);
            }
          } else if (state is NavigateToDetailPageState) {
            //To navigate to Detail Page
            _navigateToSettlementDetailsPage( _settlementModel.settlementChecks[state.selectedIndex]);
//            navigateToSettlementDetailPage(
//                _settlementModel.settlementChecks[state.selectedIndex],
//                state.appBarTitle);
          }
        },
        bloc: _settlementBloc,
        //BlocBuilder to check condition according to state
        //Basically it used to update widget
        child: BlocBuilder<SettlementBloc, SettlementStates>(
            bloc: _settlementBloc,
            builder: (context, state) {
              print("State Settlement Screen $state");
              if (state is ErrorState) {
                return dateNotFoundWidgetWithCalendarTopBar(state.errorMessage);
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
                    //This displays No Result Found Widget
                    return dateNotFoundWidgetWithCalendarTopBar('');
                  }
                } else {
                  //This displays No Result Found Widget
                  return dateNotFoundWidgetWithCalendarTopBar('');
                }
              }
              else if (state is PickedDateState) {
                //Picked date from Month Picker
                _fromDateTime = state.pickedDate;
                if (filteredSettlementChecks.length == 0) {
                  //This displays all items without filter
                  return dateNotFoundWidgetWithCalendarTopBar('');
                } else {
                  //To display filtered Widget
                  return mainListWidget(filteredSettlementChecks);
                }
              } else if (state is NavigateToDetailPageState) {
                //To maintain a state while navigating to the Details Page.
                _settlementModel = state.settlementModel;
                return mainListWidget(_settlementModel.settlementChecks);
              } else {
                //This displays No Result Found Widget
                return dateNotFoundWidgetWithCalendarTopBar('');
              }
            }),
      ),
    );
  }

  //Main Widget
  Widget mainListWidget(List<SettlementCheck> settlementChecks) {
    return ListView(scrollDirection: Axis.vertical, children: <Widget>[
      _buildThisWeekWidget(Utils.dateNowToFormat(_fromDateTime)),
      _listViewWidget(settlementChecks)
    ]);
  }

  //This displays Month Picker
  Future<Null> _selectDate(BuildContext context) async {
    showMonthPicker(
            context: context,
            firstDate: DateTime(DateTime.now().year - 2, 5),
            lastDate: DateTime(DateTime.now().year + 1, 9),
            initialDate: _fromDateTime)
        .then((picked) {
      if (picked != null && picked != _fromDateTime) {
        //Picker Event
         _fromDateTime = picked;
        _settlementBloc.dispatch(GetSettlementDataEvent(month: _fromDateTime.month, year: _fromDateTime.year));
       // _settlementBloc.dispatch(PickedDateEvent(pickedDate: picked));
      }
    });
  }

  //This displays all items in settlements model in a List View.
  Widget _listViewWidget(List<SettlementCheck> settlementChecks) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: settlementChecks.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItemsWidget(settlementChecks[index], index);
      },
    );
  }

  //List View Items
  _buildListItemsWidget(SettlementCheck _settlementCheck, int index) {
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
      child: InkWell(
        //Navigate To Details Page
        onTap: () {
          _settlementBloc.dispatch(NavigateToDetailPageEvent(
              selectedIndex: index,
//              appBarTitle:
//                  _settlementBloc.startAndEndDateCheckDate(_settlementCheck),
              settlementModel: _settlementModel));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(top: 12, left: 10, right: 10, bottom: 12),
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

  //TractorDetailsPage(this.pageName, this.tractorData, this.dashboardData, {this.settlementCheck, this.settlementModel});
  _navigateToSettlementDetailsPage(SettlementCheck settlementCheck) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: TractorDetailsPage(PageName.SETTLEMENTS_PAGE,
                null, null, settlementModel: this._settlementModel, settlementCheck: settlementCheck,)));
  }
}
