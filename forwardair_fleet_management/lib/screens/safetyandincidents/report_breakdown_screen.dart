import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/components/button_widget.dart';
import 'package:forwardair_fleet_management/components/custom_dialog_widget.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:page_transition/page_transition.dart';

import 'accident_details_screen.dart';

//This class is used to call API for view history inside safety and incidents module
class ReportBreakdownPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReportBreakdownState();
  }
}

class ReportBreakdownState extends State<ReportBreakdownPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.now());

  String _selectedOption = "Roadway Breakdown";

  @override
  void initState() {
    _showPopUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Returns a Scaffold
    if (Platform.isAndroid) {
      return SafeArea(
        child: _scaffoldWidget(),
      );
    } else {
      return _scaffoldWidget();
    }
  }

  //It's the main widget for view history
  Widget _scaffoldWidget() {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _bodyWidget()
            ],
          ),
        ));
  }

  //this method is used to show pop up to make a call or continue report accident
  _showPopUp() async {
    await Future.delayed(Duration.zero);
    // show the alert dialog
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CustomDialog(
          description: Constants.TEXT_EMERGENCY_CALL,
        ));
  }
  Widget _mainWidget() {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.colorWhite),
          centerTitle: false,
          title: TextWidget(
            text: "Safety & Incidents",
            colorText: AppColors.colorWhite,
            textType: TextType.TEXT_LARGE,
          ),
        ),
        backgroundColor: AppColors.colorDashboard_Bg,
        body: SingleChildScrollView(child: _bodyWidget()));
  }

  Widget _bodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24.0, bottom: 4, top: 16),
          child: TextWidget(
            text: "When and Where",
            colorText: AppColors.colorBlack,
            isBold: true,
          ),
        ),
        whenWidget(),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, bottom: 16),
          child: TextWidget(
            text: "Describe the Breakdown",
            colorText: AppColors.colorBlack,
            isBold: true,
          ),
        ),
        detailWidget(),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, bottom: 16,top: 16),
          child: TextWidget(
            text: "Attach Media",
            colorText: AppColors.colorBlack,
            isBold: true,
          ),
        ),
        mediaWidget(),
        Padding(
          padding: const EdgeInsets.only(top: 8,bottom: 8,left: 16,right: 16),
          child: ButtonWidget(
            text: 'NEXT',
            onPressed: (){},
            colorButton: AppColors.colorRed,
            colorText: AppColors.colorWhite,
          ),
        ),
      ],
    );
  }

  Widget whenWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      //this card is used for breakdown location with date and time
      child: Card(
        elevation:4,
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        //this column is for the component available in card
        child: Column(children: <Widget>[
          //this widget holds the date and time text with label
          Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
              //this row is for the date and time
              child: date_timeWidget()),

          //this widget holds labels and textField to take location input
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16, top: 16, bottom: 8),
            child: Container(
              color: AppColors.colorLightGrey,

              //this column holds label and row of textField below label
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 8),
                    child: TextWidget(
                      text: "Location of BreakDown",
                      colorText: AppColors.colorGrey,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  //this row holds TextField and an icon of location
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintStyle: TextStyle(fontSize: 14),
                              hintText: 'Enter Here',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                            width: 24,
                            height: 24,
                            child: Image.asset('images/ic_current_location.png')),
                      ),
                    ],
                  ),
                  Divider(
                    height: 2,
                    color: AppColors.colorBlack,
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  date_timeWidget() {
    return Row(children: <Widget>[
      //this expanded holds date field with label and icon
      Expanded(
        //Inkwell will be used to populate datePicker if click event occur
        child: InkWell(
          child: Container(
            color: AppColors.colorLightGrey,
            //this column is used to show label and  date value below the label
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 8),
                  child: TextWidget(
                    text: "Date",
                    colorText: AppColors.colorGrey,
                    textAlign: TextAlign.start,
                  ),
                ),

                //this row is required because text and calender icon should be shown parallel
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextWidget(
                          text: Utils.formatDateFromString(
                              selectedDate.toLocal().toString()),
                          colorText: AppColors.colorBlack,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                          width: 24,
                          height: 24,
                          child:
                          Image.asset('images/ic_calendar_red.png')),
                    ),
                  ],
                ),
                Divider(
                  height: 2,
                  color: Colors.black,
                )
              ],
            ),
          ),
          onTap: () {
            //To select the date from datePicker
            _selectDate(context);
          },
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          //Inkwell will be used to populate timePicker if click event occur
          child: InkWell(
            child: Container(
              color: AppColors.colorLightGrey,
              //this column is used to show label and  time value below the label
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 8),
                    child: TextWidget(
                      text: "Time",
                      colorText: AppColors.colorGrey,
                      textAlign: TextAlign.start,
                    ),
                  ),

                  //this row is required because text and clock icon should be shown parallel
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextWidget(
                            text:
                            "${selectedTime.hourOfPeriod}:${selectedTime.minute}",
                            colorText: AppColors.colorBlack,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                            width: 24,
                            height: 24,
                            child: Image.asset('images/ic_timer.png')),
                      ),
                    ],
                  ),
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            onTap: () {
              //To populate time picker when click event occurs
              _selectTime(context);
            },
          ),
        ),
      )
    ]);
  }

  Widget detailWidget() {
    return Card(
      elevation:4,
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Padding(
        padding:
        const EdgeInsets.only(left: 16.0, right: 16, top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                color: AppColors.colorLightGrey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8),
                      child: TextWidget(
                        text: "Choose Breakdown Type",
                        colorText: AppColors.colorGrey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedOption,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _selectedOption = newValue;
                          });
                        },
                        items: <String>[
                          'Roadway Breakdown',
                          'Physical Breakdown',
                          'Accident BreakDown',
                          'Collision Breakdown'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding:
              const EdgeInsets.only(left: 8, right: 16, top: 16, bottom: 8),
              child: TextWidget(
                text: "Does your equipment or another vehicle require a tow?",
                colorText: AppColors.colorBlack,
                textAlign: TextAlign.start,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Radio(
                  value: "yes",
                  groupValue: 1,
                  activeColor: Colors.red,
                  onChanged: (value) {
                    setState(() {

                    });
                  },
                ),
                TextWidget(
                  text: 'Yes',
                  colorText: AppColors.colorBlack,
                ),
                new Radio(
                  value: "No",
                  groupValue: 2,
                  activeColor: Colors.red,
                  onChanged: (value) {
                    setState(() {

                    });
                  },
                ),
                TextWidget(
                  text: 'No',
                  colorText: AppColors.colorBlack,
                ),
              ],
            ),
            Container(
              height: 220,
              color: AppColors.colorLightGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 16),
                    child: TextWidget(
                        text: "Describe Breakdown Details",
                        colorText: AppColors.colorGrey),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: 180,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 500,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 14, color: AppColors.colorGrey),
                            hintText: 'Type Here',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mediaWidget() {
    return Card(
      elevation:4,
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left:16.0),
              child: InkWell(
                child: SizedBox(
                    height: 48,
                    width: 48,
                    child: Image.asset('images/ic_add_photo.png')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: InkWell(
                child: SizedBox(
                    height: 48,
                    width: 48,
                    child: Image.asset('images/ic_gallery.png')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1980, 1),
        lastDate: DateTime(2301, 11));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }
}

