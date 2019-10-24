import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:forwardair_fleet_management/blocs/barrels/unavailability_reporting.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/theme.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

class UnavailabilityReportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UnavailabilityReportState();
  }
}

class UnavailabilityReportState extends State<UnavailabilityReportPage> {
  //Report Unavailability Bloc
  UnavailabilityReportingBloc _reportingBloc = UnavailabilityReportingBloc();
  //Start Location
  var _textControllerLocation;
  //Leave Reason
  var _textControllerReason;
  final focus = FocusNode();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));

  @override
  void initState() {
    _textControllerLocation = TextEditingController();
    _textControllerReason = TextEditingController();
    super.initState();
  }

  //Returns Main Widget
  @override
  Widget build(BuildContext context) {
    //Checking platform condition for status bar.
    if (Platform.isAndroid) {
      return SafeArea(child: _scaffoldWidget());
    } else {
      return _scaffoldWidget();
    }
  }

  @override
  void dispose() {
    //To Dispose unavailability reporting Bloc
    _reportingBloc.dispose();
    super.dispose();
  }

  //This displays Month Picker
  Future<Null> _selectStartDatePicker(BuildContext context) async {
    showDatePicker(
            context: context,
            firstDate: DateTime(DateTime.now().year - 2, 5),
            lastDate: DateTime(DateTime.now().year + 1, 9),
            initialDate: _startDate)
        .then((picked) {
      if (picked != null) {
        //Picker Event
        _reportingBloc.dispatch(PickedStartDateEvent(pickedDate: picked));
      }
    });
  }

  //This displays Month Picker
  Future<Null> _selectEndDatePicker(BuildContext context) async {
    showDatePicker(
            context: context,
            firstDate: DateTime(DateTime.now().year - 2, 5),
            lastDate: DateTime(DateTime.now().year + 1, 9),
            initialDate: _endDate)
        .then((picked) {
      if (picked != null) {
        //Picker Event
        _reportingBloc.dispatch(PickedEndDateEvent(pickedDate: picked));
      }
    });
  }

  //This displays Month Picker
  Future<Null> _selectStartTimePicker(BuildContext context) async {
    _startTime = await showTimePicker(
      context: context,
      initialTime: _startTime != null ? _startTime : TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    //Picker Event
    if (_startTime != null) {
      _reportingBloc.dispatch(PickedStartTimeEvent(pickedTime: _startTime));
    }
  }

  //This displays Month Picker
  Future<Null> _selectEndTimePicker(BuildContext context) async {
    _endTime = await showTimePicker(
      context: context,
      initialTime: _endTime != null ? _endTime : TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (_endTime != null) {
      //Picker Event
      _reportingBloc.dispatch(PickedEndTimeEvent(pickedTime: _endTime));
    }
  }

  _scaffoldWidget() {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: false,
        //AppBar Title
        title: TextWidget(
          text: Constants.TEXT_NOTIFY_UNAVAILABILITY,
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
      ),
      body: BlocListener<UnavailabilityReportingBloc,
          UnavailabilityReportingStates>(
        listener: (context, state) {},
        bloc: _reportingBloc,
        child: BlocBuilder<UnavailabilityReportingBloc,
            UnavailabilityReportingStates>(
          bloc: _reportingBloc,
          builder: (context, state) {
            if (state is PickedStartDateState) {
              _startDate = state.pickedDate;
            } else if (state is PickedEndDateState) {
              _endDate = state.pickedDate;
            } else if (state is PickedStartTimeState) {
              _startTime = state.pickedTime;
            } else if (state is PickedEndTimeState) {
              _endTime = state.pickedTime;
            }
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView(children: <Widget>[
                    //Top Widget
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.colorGrey.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 15.0, left: 20, bottom: 15),
                        child: TextWidget(
                          text: Constants.TEXT_DETAILS_OF_UNAVAILABILITY,
                          textType: TextType.TEXT_MEDIUM,
                        ),
                      ),
                    ),
                    //Start and End Date Widget
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _pickerWiget(
                                Image(
                                    image: new AssetImage('images/ic_date_range.png'),
                                    fit: BoxFit.fill),
                                Utils.formatDateFromString(_startDate.toString()),
                                Constants.TEXT_START_DATE),
                            _pickerWiget(
                                Image(
                                    image: new AssetImage('images/ic_date_range.png'),
                                    fit: BoxFit.fill),
                                Utils.formatDateFromString(_endDate.toString()),
                                Constants.TEXT_END_DATE),
                          ]),
                    ),
                    //Number of days widget
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 15, bottom: 10),
                      child: TextWidget(
                        text: Constants.TEXT_NUMBER_OF_DAYS,
                        textType: TextType.TEXT_MEDIUM,
                        colorText: AppColors.colorGrey,
                        isBold: true,
                      ),
                    ),

                    //Start and End Time Widget
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _pickerWiget(
                              Image(
                                  image: new AssetImage('images/ic_timer.png'),
                                  fit: BoxFit.fill),
                              Utils.formatTimeOfDay(
                                  _startTime != null ? _startTime : TimeOfDay.now()),
                              Constants.TEXT_START_TIME),
                          _pickerWiget(
                              Image(
                                  image: new AssetImage('images/ic_timer.png'),
                                  fit: BoxFit.fill),
                              Utils.formatTimeOfDay(
                                  _endTime != null ? _endTime : TimeOfDay.now()),
                              Constants.TEXT_END_TIME),
                        ]),
                    //To display the Text Field for Location UI.
                    Container(
                      margin:
                          EdgeInsets.only(top: 10, bottom: 5, right: 20, left: 20),
                      decoration: new BoxDecoration(
                        color: AppColors.colorGreyInBottomSheet.withOpacity(0.17),
                        border: Border(
                          bottom: BorderSide(width: 0.5, color: AppColors.colorBlack),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top:10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextWidget(
                              textType: TextType.TEXT_SMALL,
                              text: Constants.TEXT_START_LOCATION,
                              colorText: AppColors.colorGrey,

                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              //autofocus: true,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus);
                              },
                              controller: _textControllerLocation,
                            ),
                          ],
                        ),
                      ),
                    ),
                    //To display the Text Field for Reason UI.
                    Container(
                      decoration: new BoxDecoration(
                        color: AppColors.colorGreyInBottomSheet.withOpacity(0.17),
                        border: Border(
                          bottom: BorderSide(width: 0.5, color: AppColors.colorBlack),
                        ),
                      ),
                      margin:
                          EdgeInsets.only(top: 10, bottom: 5, right: 20, left: 20),
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextWidget(
                              textType: TextType.TEXT_SMALL,
                              text: Constants.TEXT_REASON_OPTIONAL,
                              colorText: AppColors.colorGrey,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                              focusNode: focus,
                              textInputAction: TextInputAction.done,
                              controller: _textControllerReason,
                              keyboardType: TextInputType.multiline,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                //Submit Button
                RaisedButton(
                  child: TextWidget(text: Constants.TEXT_SUBMIT,),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  EdgeInsetsGeometry marginToThePickerHolderWidget(String title) {
    if (title == Constants.TEXT_START_DATE ||
        title == Constants.TEXT_START_TIME) {
      return EdgeInsets.only(top: 5, bottom: 5, right: 8, left: 20);
    } else {
      return EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 8);
    }
  }

  //This display the Date and Time Picker widget.
  Widget _pickerWiget(Image imageWidget, String timeOrDataText, String title) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (title == Constants.TEXT_START_DATE) {
            _selectStartDatePicker(context);
          } else if (title == Constants.TEXT_END_DATE) {
            _selectEndDatePicker(context);
          } else if (title == Constants.TEXT_START_TIME) {
            _selectStartTimePicker(context);
          } else {
            _selectEndTimePicker(context);
          }
        },
        child: Container(
          margin: marginToThePickerHolderWidget(title),
          decoration: new BoxDecoration(
            color: AppColors.colorGreyInBottomSheet.withOpacity(0.17),
            border: Border(
              bottom: BorderSide(width: 0.5, color: AppColors.colorBlack),
            ),
          ),
          padding: EdgeInsets.only(top: 8, bottom: 5, right: 8, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextWidget(
                textType: TextType.TEXT_SMALL,
                text: title,
                colorText: AppColors.colorGrey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: TextWidget(
                      textType: TextType.TEXT_MEDIUM,
                      text: timeOrDataText,
                      colorText: AppColors.colorBlack,
                    ),
                  ),
                  imageWidget,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
