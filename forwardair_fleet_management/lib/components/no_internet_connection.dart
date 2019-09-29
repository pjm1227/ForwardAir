import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';

import 'text_widget.dart';

class NoInternetFoundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Image(
              image: AssetImage('images/img_no_internet_connection.png'),
              fit: BoxFit.cover),
        ),
        TextWidget(
          text: Constants.NO_INTERNET_FOUND,
          textType: TextType.TEXT_MEDIUM,
        ),
      ],
    ));
  }
}
