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

  //color
  final Color colorText;

  //is bold
  final bool isBold;

  //Type of text

  final TextType textType;

  final TextAlign textAlign;

  final int maxLines;

  const TextWidget(
      {Key key,
      this.text,
      this.padding,
      this.colorText,
      this.isBold,
      this.textType,
      this.textAlign,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding != null
            ? padding
            : EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        child: Text(
          text,
          textAlign: textAlign != null ? textAlign : null,
          maxLines: this.maxLines != null ? this.maxLines : null,
          style: TextStyle(
            color: colorText != null ? colorText : AppColors.colorBlack,
            fontSize: textType != null ? _textSize(textType) : 12,
            fontWeight:
                isBold != null && isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ));
  }

  //This method will return the text size
  double _textSize(TextType textType) {
    if (textType == TextType.TEXT_SMALL) {
      return 14;
    } else if (textType == TextType.TEXT_MEDIUM) {
      return 16;
    } else if (textType == TextType.TEXT_LARGE) {
      return 20;
    } else if (textType == TextType.TEXT_XLARGE) {
      return 22;
    } else {
      return 12;
    }
  }
}

enum TextType { TEXT_SMALL, TEXT_MEDIUM, TEXT_LARGE, TEXT_XLARGE }
