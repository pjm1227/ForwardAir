import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';

/*
This class return a Text widget
 */

class TextWidget extends StatelessWidget {

  //Text
  final String text;

  ///Padding Widget
  final EdgeInsets padding;

  ///Font Style
  final FontWeight fontWeight;

  //color
  final Color colorText;

  const TextWidget(
      {Key key,
      this.text,
      this.padding,
      this.fontWeight,
      this.colorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding != null
            ? padding
            : EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        child: Text(
          text,
          style: TextStyle(
              color: colorText != null ? colorText : AppColors.colorWhite,
              fontWeight: fontWeight,
              fontFamily: Constants.FONT_FAMILY_ROBOTO),
        ));
  }
}
