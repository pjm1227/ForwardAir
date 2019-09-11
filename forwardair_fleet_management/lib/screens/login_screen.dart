import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:forwardair_fleet_management/screens/drawermenu.dart';

class LoginPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: InkWell(child: Text('Login Page'), onTap:() {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: HomePage()));
        })
      ),
    );
  }

}