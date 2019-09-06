import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';

/*
This class return a Button widget that can be use anywhere in this app
Only need to pass button text and padding.
Also this class can be customise for more parameters or events as per
requirement.
 */
class ButtonWidget extends StatelessWidget {
  ///Widget for button text
  final String text;

  ///Padding Widget
  final EdgeInsets padding;

  ///On Pressed Event
  final GestureTapCallback onPressed;

  const ButtonWidget({Key key, this.text, this.padding, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: padding != null
            ? padding
            : EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        child: RaisedButton(
          child: Container(
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
              text,
              style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: Constants.FONT_FAMILY_ROBOTO),
            ),
                )),
          ),
          onPressed: onPressed,
          color: AppColors.colorRed,
        ));
  }
}
