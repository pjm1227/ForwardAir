/// Settlement Detail Page Widget
import 'package:flutter/material.dart';

import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/settlement_data_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';


class SettlementDetailsWidget extends StatelessWidget {
  final SettlementCheck settlementCheck;

  SettlementDetailsWidget({this.settlementCheck});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (builder, context) {
          return Container(
            margin: new EdgeInsets.only(top: 5, left: 10.0, bottom: 5, right: 10),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  blurRadius: 10.0,
                  offset: new Offset(0.0, 10.0),
                ),
              ],
            ),
            child: ListTile(title: _textWidgetForLeftSideTitle(Constants.TEXT_TRACTORID),
              trailing: _textWidgetForRightSideTitle(''),),
          );
        }
    );
  }

  Widget _textWidgetForLeftSideTitle(String leftSideTitle) {
    return TextWidget(text: leftSideTitle,colorText: AppColors.colorGrey,textType: TextType.TEXT_SMALL);
  }

  Widget _textWidgetForRightSideTitle(String rightSideTitle) {
    return TextWidget(text: rightSideTitle,colorText: AppColors.colorGrey,textType: TextType.TEXT_SMALL);
  }
}
