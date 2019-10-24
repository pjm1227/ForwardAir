import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/models/Tractor_settlement_model.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/models/tractor_fuel_details_model.dart';
import 'package:forwardair_fleet_management/screens/tractor_revenue_screen.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:page_transition/page_transition.dart';

import 'text_widget.dart';

class TractorFuelDetailsList extends StatelessWidget {
  final PageName pageName;
  final FuelDetail fuelModel;
  final SettlementDetail settlementModel;

  const TractorFuelDetailsList(
      {Key key, this.pageName, this.fuelModel, this.settlementModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Card(
            elevation: 4.0,
            margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //Row widget to show dot and order number
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      ClipOval(
                        child: pageName == PageName.FUEL_PAGE
                            ? null
                            : Container(
                                color: settlementModel != null &&
                                        settlementModel.transType == 'E'
                                    ? Colors.teal
                                    : AppColors.colorRed,
                                height: 8.0,
                                width: 8.0,
                              ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: TextWidget(
                            text: pageName == PageName.FUEL_PAGE
                                ? 'Order No. ${fuelModel.fuelCardId}'
                                : Utils.formatDateFromString(
                                    settlementModel.transactionDt),
                            colorText: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextWidget(
                          text: pageName == PageName.FUEL_PAGE
                              ? '\$${fuelModel.tractorFuelCost}'
                              : settlementModel.transType != 'E'
                                  ? '${Utils.addDollarAfterMinusSign(Utils.formatDecimalsNumber(double.parse(settlementModel.amt)))}'
                                  : '\$${Utils.formatDecimalsNumber(double.parse(settlementModel.amt))}',
                          textAlign: TextAlign.end,
                          colorText: AppColors.colorAppBar,
                          isBold: true,
                        ),
                      ),
                    ],
                  ),
                ),
                //Divider
                Divider(
                  color: AppColors.colorGrey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: TextWidget(
                          text: pageName == PageName.FUEL_PAGE
                              ? 'Fuel Consumed'
                              : 'Description',
                          colorText: Colors.grey,
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: TextWidget(
                            text:
                                pageName == PageName.FUEL_PAGE ? '' : 'Order #',
                            textAlign: TextAlign.end,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: TextWidget(
                            text: pageName == PageName.FUEL_PAGE
                                ? '${fuelModel.tractorGallons}g'
                                : settlementModel.description),
                      ),
                      Expanded(
                          flex: 1,
                          child: TextWidget(
                              text: pageName == PageName.FUEL_PAGE
                                  ? ''
                                  : '${settlementModel.oid}',
                              textAlign: TextAlign.end))
                    ],
                  ),
                )
              ],
            )),
        onTap: () {
          if (pageName == PageName.COMPENSATION_PAGE ||
              pageName == PageName.SETTLEMENTS_PAGE) {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: TractorRevenueDetails(
                      transactionType: settlementModel.transType,
                      oid: settlementModel.oid,
                    )));
          }
        });

//        onTap: () => pageName == PageName.COMPENSATION_PAGE
//            ? Navigator.push(
//                context,
//                PageTransition(
//                    type: PageTransitionType.fade,
//                    child: TractorRevenueDetails(
//                      transactionType: settlementModel.transType,
//                      oid: settlementModel.oid,
//                    )))
//            : null);
  }
}
