import 'dart:io';
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
  UnavailabilityReportingBloc _reportingBloc = UnavailabilityReportingBloc();

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
            return ListView(children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: AppColors.colorGrey.withOpacity(0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top:15.0, left: 20, bottom: 15),
                  child: TextWidget(
                    text: Constants.TEXT_DETAILS_OF_UNAVAILABILITY,
                    textType: TextType.TEXT_MEDIUM,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _pickerWiget(
                          Image(
                              image: new AssetImage('images/ic_date_range.png'),
                              fit: BoxFit.fill),
                          DateTime.now().toString(),
                          Constants.TEXT_START_DATE),
                      _pickerWiget(
                          Image(
                              image: new AssetImage('images/ic_date_range.png'),
                              fit: BoxFit.fill),
                          DateTime.now().toString(),
                          Constants.TEXT_END_DATE),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0, top: 15, bottom: 10),
                child: TextWidget(
                  text: Constants.TEXT_NUMBER_OF_DAYS,
                  textType: TextType.TEXT_MEDIUM,
                ),
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _pickerWiget(
                        Image(
                            image: new AssetImage('images/ic_timer.png'),
                            fit: BoxFit.fill),
                        DateTime.now().toString(),
                        Constants.TEXT_START_TIME),
                    _pickerWiget(
                        Image(
                            image: new AssetImage('images/ic_timer.png'),
                            fit: BoxFit.fill),
                        DateTime.now().toString(),
                        Constants.TEXT_END_TIME),
                  ]),
              _locationAndLeaveReasonWidget(Constants.TEXT_START_LOCATION, ''),
              _locationAndLeaveReasonWidget(Constants.TEXT_REASON_OPTIONAL, ''),
            ]);
          },
        ),
      ),
    );
  }

  EdgeInsetsGeometry marginToThePickerHolderWidget(String title) {
    if (title == Constants.TEXT_START_DATE || title == Constants.TEXT_START_TIME) {
      return EdgeInsets.only(top: 5, bottom: 5, right: 8, left: 20);
    } else {
      return EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 8);
    }
  }

  Widget _locationAndLeaveReasonWidget(String title, String valueText) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 5, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextWidget(
            textType: TextType.TEXT_SMALL,
            text: title,
            colorText: AppColors.lightBlack,
          ),
          TextField()
        ],
      ),
    );
  }

  //This display the Date and Time Picker widget.
  Widget _pickerWiget(Image imageWidget, String timeOrDataText, String title) {
    return Expanded(
      child: Container(
         margin: marginToThePickerHolderWidget(title),
        decoration: new BoxDecoration(
          color: AppColors.colorGreyInBottomSheet.withOpacity(0.17),
          border: Border(
            bottom: BorderSide(width: 0.5, color: AppColors.colorBlack),
          ),
        ),
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              textType: TextType.TEXT_SMALL,
              text: title,
              colorText: AppColors.lightBlack,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0,),
                  child: TextWidget(
                    textType: TextType.TEXT_MEDIUM,
                    text: Utils.formatDateFromString(timeOrDataText),
                    colorText: AppColors.colorBlack,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, right: 5.0, bottom: 2.0),
                  child: SizedBox(height: 20, width: 20, child: imageWidget),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
