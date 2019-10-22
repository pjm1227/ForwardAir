import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

import 'text_widget.dart';

//This Widget is used to show the Total Gallons, Total amount for fuel, And
//Show the total deduction or earnings for Net Compensation Page
class TopWidgetForFuel extends StatelessWidget {
  final PageName pageName;
  final double totalTractorGallons, grossAmount, totalFuelCost, deductions;

  const TopWidgetForFuel(
      {Key key,
      this.pageName,
      this.totalTractorGallons,
      this.grossAmount,
      this.totalFuelCost,
      this.deductions})
      : super(key: key);

  Widget _roundedRedColorWidget(PageName pageName, Color color) {
    if (pageName == PageName.COMPENSATION_PAGE ||
        pageName == PageName.SETTLEMENTS_PAGE) {
      return Container(
        child: ClipOval(
          child: Container(
            color: color,
            height: 8.0,
            width: 8.0,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        flex: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _roundedRedColorWidget(pageName, Colors.teal),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 8.0),
                  child: TextWidget(
                    text: pageName == PageName.FUEL_PAGE
                        ? Utils.formatDecimalToWholeNumber(totalTractorGallons) == 'N/A' ? 'N/A'
                            : '${Utils.formatDecimalToWholeNumber(totalTractorGallons)}'
                        : Utils.formatDecimalToWholeNumber(grossAmount) == 'N/A'
                            ? 'N/A'
                            : '\$${Utils.formatDecimalToWholeNumber(grossAmount)}',
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
                text: pageName == PageName.FUEL_PAGE ? 'GALLONS' : 'EARNINGS',
                colorText: AppColors.colorWhite,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          child: VerticalDivider(
            color: AppColors.colorWhite,
          ),
        ),
      ),
      Expanded(
        flex: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //Show and hide Dot based on condition
                //On Fuel page we don't require dot
                _roundedRedColorWidget(pageName, Colors.red),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextWidget(
                    text: pageName == PageName.FUEL_PAGE
                        ? Utils.formatDecimalToWholeNumber(totalFuelCost) ==
                                'N/A'
                            ? 'N/A'
                            : '\$${Utils.formatDecimalToWholeNumber(totalFuelCost)}'
                        : '${Utils.addDollarAfterMinusSign(Utils.formatDecimalsNumber(deductions))}',
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
                text: pageName == PageName.FUEL_PAGE ? 'AMOUNT' : 'DEDUCTIONS',
                colorText: AppColors.colorWhite,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
