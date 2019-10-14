import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

import 'text_widget.dart';

//This widget is using to set data for Total Loads, Total Miles, Empty Miles
// For loads and Miles page.
class TopWidgetForLoads extends StatelessWidget {
  final PageName pageName;
  final int totalLoads,
      totalMiles,
      emptyMiles,
      emptyLoads,
      loadedMiles,
      loadedLoads;
  final bool isDetailsPage;

  const TopWidgetForLoads({
    Key key,
    this.pageName,
    this.totalLoads,
    this.totalMiles,
    this.emptyMiles,
    this.emptyLoads,
    this.loadedMiles,
    this.loadedLoads,
    this.isDetailsPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        flex: 3,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Container(
                    color: Colors.white,
                    height: 8.0,
                    width: 8.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: TextWidget(
                    text: pageName == PageName.LOAD_PAGE
                        ? '${Utils.formatDecimalToWholeNumber(totalLoads)}'
                        : '${Utils.formatDecimalToWholeNumber(totalMiles)}',
                    textAlign: TextAlign.center,
                    colorText: AppColors.colorWhite,
                    textType: TextType.TEXT_MEDIUM,
                    isBold: true,
                    textOverFlow: TextOverflow.clip,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextWidget(
                  text: 'TOTAL',
                  colorText: AppColors.colorWhite,
                ),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          child: VerticalDivider(
            color: AppColors.colorWhite,
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Container(
                    color: Colors.red,
                    height: 8.0,
                    width: 8.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: TextWidget(
                    text: isDetailsPage
                        ? '$emptyLoads'
                        : _calculateEmptyPercentage(),
                    textAlign: TextAlign.center,
                    colorText: AppColors.colorWhite,
                    textType: TextType.TEXT_MEDIUM,
                    isBold: true,
                    textOverFlow: TextOverflow.clip,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextWidget(
                text: 'EMPTY',
                colorText: AppColors.colorWhite,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          child: VerticalDivider(
            color: AppColors.colorWhite,
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Container(
                    color: Colors.teal,
                    height: 8.0,
                    width: 8.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: TextWidget(
                    text: isDetailsPage
                        ? '$loadedLoads'
                        : _calculateLoadPercentage(),
                    textAlign: TextAlign.center,
                    colorText: AppColors.colorWhite,
                    textType: TextType.TEXT_MEDIUM,
                    isBold: true,
                    textOverFlow: TextOverflow.clip,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextWidget(
                text: 'LOADED',
                colorText: AppColors.colorWhite,
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  //empty and load percentage for top rows
  String _calculateEmptyPercentage() {
    if (pageName == PageName.MILES_PAGE) {
      return ((emptyMiles * 100) / totalMiles).toStringAsFixed(2) + '%';
    } else {
      return ((emptyLoads * 100) / totalLoads).toStringAsFixed(2) + '%';
    }
  }

  //empty and load percentage for top rows
  String _calculateLoadPercentage() {
    if (pageName == PageName.MILES_PAGE) {
      return ((loadedMiles * 100) / totalMiles).toStringAsFixed(2) + '%';
    } else {
      return ((loadedLoads * 100) / totalLoads).toStringAsFixed(2) + '%';
    }
  }
}
