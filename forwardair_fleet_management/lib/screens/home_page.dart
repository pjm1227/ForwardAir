import 'package:flutter/material.dart';
import 'dart:io';

import 'package:forwardair_fleet_management/screens/dashboard_page.dart';
import 'package:forwardair_fleet_management/screens/sidemenu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  //Scaffold Widget
  Widget _scaffoldWidget() {
    return Scaffold(
       // key: _scaffold,
        //To Display the Dashboard
        body: DashboardPage(),
        //To Display the DrawerMenu
       // drawer: SideMenuPage(scaffold: _scaffold)
    );
  }

  //This return UI of Drawer Menu and Dasboard
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _scaffoldWidget();
    } else {
      return SafeArea(
        child: _scaffoldWidget(),
      );
    }
  }
}
