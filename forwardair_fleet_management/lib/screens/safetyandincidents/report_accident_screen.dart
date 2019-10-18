import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/components/button_widget.dart';
import 'package:forwardair_fleet_management/components/custom_dialog_widget.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';

import '../sidemenu.dart';

//This class is used to call API for view history inside safety and incidents module
class ReportAccidentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReportAccidentState();
  }
}

class ReportAccidentState extends State<ReportAccidentPage> {
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

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
        key: _scaffold,
        appBar: new AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          centerTitle: false,
          //AppBar Title
          title: TextWidget(
            text: 'Report Accident',
            colorText: AppColors.colorWhite,
            textType: TextType.TEXT_LARGE,
          ),
        ),
        drawer: SideMenuPage(
          scaffold: _scaffold,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[],
          ),
        ));
  }

  //this method is used to show pop up to make a call or continue report accident
  _showPopUp() async {
    await Future.delayed(Duration.zero);
    // show the alert dialog
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => CustomDialog(description: Constants.TEXT_EMERGENCY_CALL,));
  }
}
