import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/components/button_widget.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:page_transition/page_transition.dart';

class AccidentDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AccidentState();
  }
}

class AccidentState extends State<AccidentDetailsPage> {
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

  Widget _scaffoldWidget() {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.colorWhite),
        centerTitle: false,
        title: TextWidget(
          text: "Accident Details",
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
      ),
      body: _mainWidget(),
    );
  }

  Widget _mainWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            elevation: 4,
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextWidget(
                    text: 'Roadway Accident',
                    colorText: AppColors.colorAppBar,
                    isBold: true,
                  ),
                  TextWidget(
                    text: 'Edit',
                    colorText: AppColors.colorRed,
                  )
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.colorLightGrey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextWidget(
                    text: 'Accident/incident Details',
                    colorText: AppColors.colorAppBar,
                    isBold: true,
                  ),
                Image.asset('images/ic_edit_red.png'),
                ],
              ),
            ),
          ),
          _basicAccidentDetailsWidget(),
          Container(
            color: AppColors.colorLightGrey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextWidget(
                    text: 'Parties Involved',
                    colorText: AppColors.colorAppBar,
                    isBold: true,
                  ),
                  Image.asset('images/ic_edit_red.png'),
                ],
              ),
            ),
          ),
          _basicAccidentDetailsWidget(),
          _basicAccidentDetailsWidget(),
          _basicAccidentDetailsWidget(),
          Container(
            color: AppColors.colorLightGrey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextWidget(
                    text: 'Eqipment Involved',
                    colorText: AppColors.colorAppBar,
                    isBold: true,
                  ),
                  Image.asset('images/ic_edit_red.png'),
                ],
              ),
            ),
          ),
          _basicAccidentDetailsWidget(),
          Container(
            color: AppColors.colorLightGrey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextWidget(
                    text: 'Load Information',
                    colorText: AppColors.colorAppBar,
                    isBold: true,
                  ),
                  Image.asset('images/ic_edit_red.png'),
                ],
              ),
            ),
          ),
          _basicAccidentDetailsWidget(),
          Container(
            color: AppColors.colorLightGrey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextWidget(
                    text: 'Report Signoff Details',
                    colorText: AppColors.colorAppBar,
                    isBold: true,
                  ),
                  Image.asset('images/ic_edit_red.png'),
                ],
              ),
            ),
          ),
          _basicAccidentDetailsWidget(),
          Container(
            color: AppColors.colorLightGrey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextWidget(
                    text: 'Attachment',
                    colorText: AppColors.colorAppBar,
                    isBold: true,
                  ),
                  Image.asset('images/ic_edit_red.png'),
                ],
              ),
            ),
          ),
          _basicAccidentDetailsWidget(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ButtonWidget(
              text: 'Submit',
              colorButton: AppColors.colorRed,
              colorText: AppColors.colorWhite,
              onPressed: () {
                Navigator.pop(context);
              /*  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: AccidentDetailsPage()));*/
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _basicAccidentDetailsWidget() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Container(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
              TextWidget(text: 'Company'),
            ],
          ),
        ),
      ),
    );
  }
}
