import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forwardair_fleet_management/components/button_widget.dart';
import 'package:forwardair_fleet_management/screens/terms_condition_screen.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/theme.dart' as Theme;

//Main function of an app
//App must start from here
void main() {
  //Setup the status bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black, // status bar color
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(DrivingConfirmation());
}

//Root widget of an App
//Here we can set the app theme
class DrivingConfirmation extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fleet Owner',
      debugShowCheckedModeBanner: false,
      theme: Theme.customThemeData,
      home: DrivingPage(),
    );
  }
}

class DrivingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DrivingPageState();
  }
}

//Handling the state of this page here
class DrivingPageState extends State<DrivingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 3, child: Image.asset('images/ic_fa_logo.png')),
            Expanded(flex: 5, child: _middleWidget()),
            Expanded(flex: 2, child: _bottomWidget()),
          ]),
    ));
  }

  //Bottom widget with two buttons
  //That return the column widget
  Widget _bottomWidget() {
    return Column(
      children: <Widget>[
        ButtonWidget(
          text: Constants.TEXT_NOT_DRIVING,
          onPressed: () => _goToNext(),
          padding:
              EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
        ),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Constants.TEXT_CLOSE_APP,
              style: TextStyle(
                  color: AppColors.colorRed, fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () => exit(0),
        )
      ],
    );
  }

  //Middle widget returning column to show icon and terms& conditions
  Widget _middleWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Image.asset(
            'images/ic_icon.png',
            fit: BoxFit.fill,
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: new Text(Constants.DONT_USE,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      fontFamily: Constants.FONT_FAMILY_ROBOTO)),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: new Text(Constants.TERMS_CONDITIONS,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    fontFamily: Constants.FONT_FAMILY_ROBOTO_BOLD)),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 8, top: 0, bottom: 0, right: 8),
              child: new Text(Constants.APP_CAN_DETECT,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: Constants.FONT_FAMILY_ROBOTO)),
            ),
          ),
        )
      ],
    );
  }

  //This method is used to go to next screen.
  _goToNext() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TermsConditions()),
    );
  }
}
