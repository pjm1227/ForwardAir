import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/models/loadDetails/load_detail_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

//This class is called to show ListView for Loads and Miles of particular tractor
class TractorLoadsDetailsItem extends StatelessWidget {
  final Loads loads;
  final PageName pageName;

  const TractorLoadsDetailsItem({Key key, this.loads, this.pageName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _listItem();
  }

  //This widget return the list items widget
  Widget _listItem() {
    return Card(
        elevation: 4.0,
        margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Row widget to show dot and order number
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ClipOval(
                        child: Container(
                          color: loads.loadedMiles == 0
                              ? AppColors.colorRed
                              : AppColors.colorDOT,
                          height: 8.0,
                          width: 8.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextWidget(
                          text: 'Order No. ${loads.orderNbr}',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: TextWidget(
                      textOverFlow: TextOverflow.ellipsis,
                      text: pageName == PageName.MILES_PAGE
                          ? '(${Utils.formatDecimalToWholeNumber(loads.loadedMiles)}mi)'
                          : '',
                      colorText: AppColors.colorBlack,
                    ),
                  ),
                ],
              ),
            ),
            //Widget for Show origin city to destination city
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: pageName == PageName.LOAD_PAGE
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: TextWidget(
                            textOverFlow: TextOverflow.ellipsis,
                            colorText: AppColors.colorAppBar,
                            textType: TextType.TEXT_SMALL,
                            text: loads.originCity != null
                                ? loads.originCity
                                : 'N/A',
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: TextWidget(
                            colorText: AppColors.colorAppBar,
                            textOverFlow: TextOverflow.ellipsis,
                            textType: TextType.TEXT_SMALL,
                            text: loads.destCity.isNotEmpty
                                ? loads.destCity
                                : 'N/A',
                          ),
                        ),
                      ],
                    )
                  : _showMiles(loads),
            ),
            //Widget for Set up dates
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: TextWidget(
                      text: loads.settlementPaidDt != null
                          ? Utils.formatDateFromString(loads.settlementPaidDt)
                          : "N/A",
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextWidget(
                      text: loads.settlementFinalDt != null
                          ? Utils.formatDateFromString(loads.settlementFinalDt)
                          : "N/A",
                    ),
                  ),
                ],
              ),
            ),
            //Divider
            Divider(
              color: AppColors.colorGrey,
            ),
            // Driver details Widget
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextWidget(text: 'Driver'),
            ),
            //Driver name widget
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
              child: TextWidget(
                text: loads.driver1FirstName != null
                    ? '${loads.driver1FirstName} ${loads.driver1LastName} from ${loads.driverOriginCity},${loads.driverOriginSt}'
                    : 'N/A',
                isBold: true,
              ),
            ),
            Container(
                child: loads.driver2FirstName != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Divider(
                            color: AppColors.colorGrey,
                          ),
                          // Driver details Widget
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextWidget(text: 'Co-Driver'),
                          ),
                          //Driver name widget
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 4.0, bottom: 4.0),
                            child: TextWidget(
                              text: loads.driver2FirstName != null
                                  ? '${loads.driver2FirstName} ${loads.driver2LastName}'
                                  : 'N/A',
                              isBold: true,
                            ),
                          )
                        ],
                      )
                    : null)
          ],
        ));
  }

//This widget is used to show miles in braces
  Widget _showMiles(Loads loadData) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: TextWidget(
            textOverFlow: TextOverflow.ellipsis,
            colorText: AppColors.colorAppBar,
            textType: TextType.TEXT_SMALL,
            text: loadData.originCity != null ? loadData.originCity : 'N/A',
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Icon(
              Icons.arrow_forward,
              size: 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextWidget(
            colorText: AppColors.colorAppBar,
            textOverFlow: TextOverflow.ellipsis,
            textType: TextType.TEXT_SMALL,
            text: loadData.destCity.isNotEmpty ? loadData.destCity : 'N/A',
          ),
        ),
//        Expanded(
//          flex: 3,
//          child: Container(
//            child: TextWidget(
//              textOverFlow: TextOverflow.ellipsis,
//              text: pageName == PageName.MILES_PAGE
//                  ? '(${Utils.formatDecimalToWholeNumber(loadData.loadedMiles)}mi)'
//                  : '',
//              colorText: AppColors.colorBlack,
//            ),
//          ),
//        ),
      ],
    );
  }
}
