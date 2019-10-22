import 'dart:io';
import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/blocs/barrels/unavailability.dart';

import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

class UnavailabilityDetailsPage extends StatelessWidget {

  //UnavailabilityDataModelDetail
  final UnavailabilityDataModelDetail unavailabilityDataModelDetail;
  //Initializer
  UnavailabilityDetailsPage({Key key,this.unavailabilityDataModelDetail}) : super(key: key);

  //Returns Main Widget
  @override
  Widget build(BuildContext context) {
    //Holder To The ListView
    if (Platform.isAndroid) {
      return SafeArea(child: _scaffoldWidget());
    } else {
      return _scaffoldWidget();
    }
  }

  _scaffoldWidget() {
    return Scaffold(
        appBar: new AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          centerTitle: false,
          //AppBar Title
          title: TextWidget(
            text: Constants.TEXT_UNAVAILABILITY_DETAILS,
            colorText: AppColors.colorWhite,
            textType: TextType.TEXT_LARGE,
          ),
        ),
        body: ListView(children: <Widget>[
          _timeOffWidget(),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 20, bottom: 15),
            child: TextWidget(text: Constants.TEXT_DETAILS_OF_UNAVAILABILITY,textType: TextType.TEXT_MEDIUM,),
          ),
          Padding(
            padding: const EdgeInsets.only(top:0.0),
            child: _descriptionWidget(
                Constants.TEXT_REQUESTED_BY, unavailabilityDataModelDetail.requestedBy, true),
          ),
          _descriptionWidget(Constants.TEXT_START_DATE,Utils.formatDateFromString(unavailabilityDataModelDetail.leaveStartDate), false),
          _descriptionWidget(
              Constants.TEXT_END_DATE,Utils.formatDateFromString(unavailabilityDataModelDetail.leaveEndDate), false),
          _descriptionWidget(
               Constants.TEXT_START_LOCATION, UnavailabilityBloc().combineCityAndState(unavailabilityDataModelDetail.city, unavailabilityDataModelDetail.state), false),
          _descriptionWidget(
              Constants.TEXT_REASON_OF_UNAVAILABILITY,unavailabilityDataModelDetail.reason, false),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: _descriptionWidget(Constants.TEXT_NOTE,Constants.TEXT_NOTE_CONTENT, true),
          ),
        ]));
  }

  //Description Widget
  Widget _descriptionWidget(String title, String description, bool isFirst) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.09),
            blurRadius: 10.0,
            offset: isFirst == true ? Offset(10.0, 0.0) : Offset(0.0, 10.0),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: _textWidgetForLeftSideTitle(title),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _textWidgetForRightSideTitle(description),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //This display the Time off widget
  _timeOffWidget() {
    return Container(
      height: 50,
      decoration: new BoxDecoration(
        color: AppColors.colorWhite,
        shape: BoxShape.rectangle,
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.09),
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Container(
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            //This display the time off title.
            leading: TextWidget(
                textOverFlow: TextOverflow.ellipsis,
                text: Constants.TEXT_TIME_OFF,
                textType: TextType.TEXT_MEDIUM,
                isBold: true,
                colorText: AppColors.colorBlue),
          ),
        ),
      ),
    );
  }

  //Left Side Widget
  Widget _textWidgetForLeftSideTitle(String leftSideTitle) {
    return TextWidget(
        text: leftSideTitle,
        colorText: AppColors.colorGrey,
        textType: TextType.TEXT_SMALL);
  }

  //Right Side Widget
  Widget _textWidgetForRightSideTitle(String rightSideTitle) {
    return TextWidget(
        text: rightSideTitle,
        colorText: AppColors.colorBlack,
        textType: TextType.TEXT_MEDIUM);
  }
}
