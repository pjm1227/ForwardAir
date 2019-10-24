import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:forwardair_fleet_management/blocs/barrels/unavailability_reporting.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
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
  TextEditingController _textControllerLocation;
  //Leave Reason
  TextEditingController _textControllerReason;
  //Focus to Text field
  final focus = FocusNode();
  //Start Date
  DateTime _startDate = DateTime.now();
  //End Date
  DateTime _endDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  //Start Time
  TimeOfDay _startTime = TimeOfDay.now();
  //End Time
  TimeOfDay _endTime = TimeOfDay.now();
  //TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
  //Number of days Leave
  int numberOfDaysLeave = 1;
  //Flag to show/Hide Time Picker
  bool _isTimeWidgetVisible = true;

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

  //This displays Start Date Picker
  Future<Null> _selectStartDatePicker(BuildContext context) async {
    showDatePicker(
            context: context,
            firstDate: DateTime(DateTime.now().year - 2, 5),
            lastDate: DateTime(DateTime.now().year + 1, 9),
            initialDate: _startDate)
        .then((picked) {
      if (picked != null) {
        //Picker Event
        if (_endDate != null) {
          if (Utils.validateStartAndEndDate(picked, _endDate) == true) {
            _reportingBloc.dispatch(PickedStartDateEvent(pickedDate: picked));
          } else {
            showAlertDialog(
                context, Constants.TEXT_START_DATE_VALIDATION_MESSAGE);
          }
        }
      }
    });
  }

  //This displays End Date Picker
  Future<Null> _selectEndDatePicker(BuildContext context) async {
    showDatePicker(
            context: context,
            firstDate: DateTime(DateTime.now().year - 2, 5),
            lastDate: DateTime(DateTime.now().year + 1, 9),
            initialDate: _endDate)
        .then((picked) {
      if (picked != null) {
        //Picker Event
        if (_startDate != null) {
          if (Utils.validateStartAndEndDate(_startDate, picked) == true) {
            _reportingBloc.dispatch(PickedEndDateEvent(pickedDate: picked));
          } else {
            showAlertDialog(
                context, Constants.TEXT_END_DATE_VALIDATION_MESSAGE);
          }
        } else {
          showAlertDialog(context, Constants.TEXT_START_DATE_SELECT_MESSAGE);
        }
      }
    });
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
          child: Container(
            height: 200.0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextWidget(
                    text: message,
                    textType: TextType.TEXT_MEDIUM,
                  ),
                ),
                 Divider(height: 0.5,color: AppColors.colorBlack,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  new FlatButton(
                          color: AppColors.colorRed,
                          child: TextWidget(
                            text: Constants.TEXT_CALL,
                            textType: TextType.TEXT_SMALL,
                            colorText: AppColors.colorWhite,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                  new FlatButton(
                    shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.colorRed)),
                    child: TextWidget(
                      text: Constants.TEXT_CLOSE,
                      textType: TextType.TEXT_SMALL,
                      colorText: AppColors.colorRed,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
            ),
          ),

                ],
              ),
            ),
          ),
        );
      }
    );

  }



//  void _showDialog(String message) {
//    // flutter defined function
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          content: Container(
//
//        decoration: new BoxDecoration(
//        color: AppColors.colorWhite,
//        border: Border(
//        bottom: BorderSide(
//        width: 0.5, color: AppColors.colorBlack),
//        ),),
//            child:
//              Padding(
//                padding: const EdgeInsets.only(bottom: 20.0),
//                child: TextWidget(
//                  text: message,
//                  textType: TextType.TEXT_MEDIUM,
//                ),
//              ),
//          ),
//          actions: <Widget>[
//            // usually buttons at the bottom of the dialog
//            Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                new FlatButton(
//                  color: AppColors.colorRed,
//                  child: TextWidget(
//                    text: Constants.TEXT_CALL,
//                    textType: TextType.TEXT_SMALL,
//                    colorText: AppColors.colorWhite,
//                  ),
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                ),
//                new FlatButton(
//                  shape: new BeveledRectangleBorder(),
//                  child: TextWidget(
//                    text: Constants.TEXT_CANCEL,
//                    textType: TextType.TEXT_SMALL,
//                    colorText: AppColors.colorRed,
//                  ),
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                ),
//              ],
//            ),
//
//          ],
//        );
//      },
//    );
//  }

  //This displays Alert Box
  showAlertDialog(BuildContext context, String message) {
    Widget continueButton = FlatButton(
      child: Text(Constants.TEXT_OK),
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the alert dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //This displays Start Time Picker
  Future<Null> _selectStartTimePicker(BuildContext context) async {
    TimeOfDay _pickerStartTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (_pickerStartTime != null) {
      if (_endTime != null) {
        if (Utils.validateStartAndEndTime(_pickerStartTime, _endTime) == true) {
          //Picker Event
          _startTime = _pickerStartTime;
          _reportingBloc.dispatch(PickedStartTimeEvent(pickedTime: _startTime));
        } else {
          showAlertDialog(
              context, Constants.TEXT_START_TIME_VALIDATION_MESSAGE);
        }
      } else {
        _startTime = _pickerStartTime;
        _reportingBloc.dispatch(PickedStartTimeEvent(pickedTime: _startTime));
      }
    }
  }

  //This displays End Time Picker
  Future<Null> _selectEndTimePicker(BuildContext context) async {
    TimeOfDay _pickedEndTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (_pickedEndTime != null) {
      if (_startTime != null) {
        if (Utils.validateStartAndEndTime(_startTime, _pickedEndTime) == true) {
          _endTime = _pickedEndTime;
          //Picker Event
          _reportingBloc.dispatch(PickedEndTimeEvent(pickedTime: _endTime));
        } else {
          showAlertDialog(context, Constants.TEXT_END_TIME_VALIDATION_MESSAGE);
        }
      } else {
        _endTime = _pickedEndTime;
        //Picker Event
        _reportingBloc.dispatch(PickedEndTimeEvent(pickedTime: _endTime));
      }
    }
  }

  //To display Main Widget
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
      backgroundColor: AppColors.colorWhite,
      body: BlocListener<UnavailabilityReportingBloc,
          UnavailabilityReportingStates>(
        listener: (context, state) {
          if (state is TappedOnSubmitButtonState) {
            if (state.startLocation == '') {
              showAlertDialog(
                  context, Constants.TEXT_START_LOCATION_VALIDATION);
            }
            if (state.numberOfDays > 30) {
              _showDialog(Constants.TEXT_CANNOT_COMPLETE_REQUEST);
            }
          }
        },
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
            if (numberOfDaysLeave > 1) {
              _isTimeWidgetVisible = true;//false;
            } else {
              _isTimeWidgetVisible = true;
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
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 20, bottom: 15),
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
                                    image: new AssetImage(
                                        'images/ic_date_range.png'),
                                    fit: BoxFit.fill),
                                Utils.formatDateFromString(
                                    _startDate.toString()),
                                Constants.TEXT_START_DATE),
                            _pickerWiget(
                                Image(
                                    image: new AssetImage(
                                        'images/ic_date_range.png'),
                                    fit: BoxFit.fill),
                                Utils.formatDateFromString(_endDate.toString()),
                                Constants.TEXT_END_DATE),
                          ]),
                    ),
                    //Number of days widget
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 15, bottom: 10),
                      child: TextWidget(
                        text: displayNumberOfLeavesText(),
                        textType: TextType.TEXT_MEDIUM,
                        colorText: AppColors.colorGrey,
                        isBold: true,
                      ),
                    ),
                    //Start and End Time Widget
                    _isTimeWidgetVisible == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                                _pickerWiget(
                                    Image(
                                        image: new AssetImage(
                                            'images/ic_timer.png'),
                                        fit: BoxFit.fill),
                                    Utils.formatTimeOfDay(_startTime != null
                                        ? _startTime
                                        : TimeOfDay.now()),
                                    Constants.TEXT_START_TIME),
                                _pickerWiget(
                                    Image(
                                        image: new AssetImage(
                                            'images/ic_timer.png'),
                                        fit: BoxFit.fill),
                                    Utils.formatTimeOfDay(_endTime != null
                                        ? _endTime
                                        : TimeOfDay.now()),
                                    Constants.TEXT_END_TIME),
                              ])
                        : Container(),
                    //To display the Text Field for Location UI.
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, bottom: 5, right: 20, left: 20),
                      decoration: new BoxDecoration(
                        color:
                            AppColors.colorGreyInBottomSheet.withOpacity(0.17),
                        border: Border(
                          bottom: BorderSide(
                              width: 0.5, color: AppColors.colorBlack),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 10),
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
                      padding: EdgeInsets.only(bottom: 20),
                      margin:
                          EdgeInsets.only(top: 5, bottom: 5, right: 0, left: 5),
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
                        decoration: new BoxDecoration(
                          color: AppColors.colorGreyInBottomSheet
                              .withOpacity(0.17),
                          border: Border(
                            bottom: BorderSide(
                                width: 0.5, color: AppColors.colorBlack),
                          ),
                        ),
                        margin: EdgeInsets.only(
                            top: 10, bottom: 5, right: 20, left: 15),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 10),
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
                    ),
                  ]),
                ),
                //Submit Button
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  margin: new EdgeInsets.only(left: 20, right: 20, bottom: 5),
                  color: Colors.transparent,
                  child: RaisedButton(
                    onPressed: () => _reportingBloc.dispatch(
                        TappedOnSubmitButtonEvent(
                            startDate: _startDate,
                            endDate: _endDate,
                            startTime: _startTime,
                            endTime: _endTime,
                            startLocation: _textControllerLocation != null
                                ? _textControllerLocation.text
                                : '',
                            reason: _textControllerReason != null
                                ? _textControllerReason.text
                                : '',
                            numberOfDays: numberOfDaysLeave)),
                    color: AppColors.colorRed,
                    child: TextWidget(
                      text: Constants.TEXT_SUBMIT,
                      colorText: AppColors.colorWhite,
                      isBold: true,
                      textType: TextType.TEXT_MEDIUM,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  String displayNumberOfLeavesText() {
    if (_startDate != null && _endDate != null) {
      numberOfDaysLeave = Utils.findNumberOfDaysBetweenStartAndEndDate(_startDate, _endDate);
    }
    return '${Constants.TEXT_NUMBER_OF_DAYS + ' $numberOfDaysLeave'}';
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
                    padding: const EdgeInsets.only(top: 8.0),
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
