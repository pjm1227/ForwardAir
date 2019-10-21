import 'dart:io';
import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.all(8.0),
            child: TextWidget(text: Constants.TEXT_DETAILS_OF_UNAVAILABILITY,),
          ),
          _rowWidgetHolder(Constants.TEXT_TRACTORID, '1108', true),
          _rowWidgetHolder(Constants.TEXT_DATE,
              Utils.formatDateFromString(unavailabilityDataModelDetail.leaveStartDate), false),
          _rowWidgetHolder(Constants.TEXT_DEDUCTION_TYPE, 'Recurring', false),
          _rowWidgetHolder(Constants.TEXT_DRIVER_CONTRIBUTION,
              Utils.appendDollarSymbol(0), false),
          _rowWidgetHolder(Constants.TEXT_ORIGINAL_BALANCE,
              Utils.appendDollarSymbol(0), false),
          _rowWidgetHolder(
              Constants.TEXT_DRIVER_OWING, Utils.appendDollarSymbol(0), false),
          _rowWidgetHolder(Constants.TEXT_SERVICE_CHARGE,
              Utils.appendDollarSymbol(0), false),
          _rowWidgetHolder(Constants.TEXT_PAYMENT,
              Utils.addDollarAfterMinusSign('7.36'), false),
          _descriptionWidget(
              Constants.TEXT_DESCRIPTION, 'True North Iurance', false),
          _descriptionWidget(Constants.TEXT_COMMENTS, 'Comments', true)
        ]));
  }

  //Description Widget
  Widget _descriptionWidget(String title, String description, bool isLast) {
    return Container(
      margin: new EdgeInsets.only(
          bottom: isLast == true ? 15 : 0, left: 15, right: 15, top: 0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: isLast == true
            ? new BorderRadius.only(
            bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))
            : new BorderRadius.all(Radius.circular(0)),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 10.0,
            offset: isLast == true ? Offset(0.0, 10.0) : Offset(0.0, 10.0),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
                  child: _textWidgetForLeftSideTitle(title),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
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
            //This display the time off title.
            leading: TextWidget(
                textOverFlow: TextOverflow.ellipsis,
                text: Constants.TEXT_TIME_OFF,
                textType: TextType.TEXT_MEDIUM,
                isBold: true,
                colorText: AppColors.colorWhite),
          ),
        ),
      ),
    );
  }

  //List Tile Widget
  Widget _rowWidgetHolder(
      String leftSideText, String RightSideText, bool isFirst) {
    return Container(
      margin: new EdgeInsets.only(
          top: isFirst == true ? 15 : 0, left: 15, right: 15),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: isFirst == true
            ? new BorderRadius.only(
            topRight: Radius.circular(5), topLeft: Radius.circular(5))
            : new BorderRadius.all(Radius.circular(0)),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 10.0,
            offset: isFirst == true ? Offset(0.0, 0.0) : Offset(0.0, 10.0),
          )
        ],
      ),
      child: Padding(
        padding:
        const EdgeInsets.only(right: 10.0, left: 10, top: 10, bottom: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _textWidgetForLeftSideTitle(leftSideText),
              _textWidgetForRightSideTitle(RightSideText),
            ]),
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
        textType: TextType.TEXT_SMALL);
  }
}
