import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';

class RevenueItemWidget extends StatelessWidget {
  final String tagName, tagValue;

  const RevenueItemWidget(
      {Key key, @required this.tagName, @required this.tagValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextWidget(
            text: tagName,
          )),
          Expanded(
              child: TextWidget(
            text: tagValue == null ? 'N/A' : tagValue,
            colorText: AppColors.colorAppBar,
            textAlign: TextAlign.right,
            isBold: true,
          ))
        ],
      ),
    );
  }
}
