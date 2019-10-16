import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:forwardair_fleet_management/screens/tractor_details_screen.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:page_transition/page_transition.dart';

import 'text_widget.dart';

//This widget return a list view widget that can be use at Load Page and
//Miles Page
class TractorListWidget extends StatelessWidget {
  final List<Map<Tractor, Color>> tractorList;
  final PageName pageName;
  final Dashboard_DB_Model dashboardData;

  const TractorListWidget({
    Key key,
    @required this.tractorList,
    @required this.pageName,
    @required this.dashboardData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Page name in load list $pageName");
    return Container(
      color: AppColors.colorWhite,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: tractorList.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: Padding(
              padding: EdgeInsets.only(left: 4.0, right: 4.0),
              child: Card(
                child: Container(
                  height: 65,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    ClipOval(
                                      child: tractorList[index].values.first ==
                                              AppColors.colorWhite
                                          ? new Container(
                                              width: 8.0,
                                              height: 8.0,
                                              decoration: new BoxDecoration(
                                                borderRadius: new BorderRadius
                                                        .all(
                                                    new Radius.circular(8.0)),
                                                border: new Border.all(
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              color: tractorList[index]
                                                  .values
                                                  .first,
                                              height: 8.0,
                                              width: 8.0,
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextWidget(
                                        text:
                                            'Tractor ID :  ${tractorList[index].keys.first.tractorId}',
                                        textType: TextType.TEXT_MEDIUM,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8.0),
                                  child: TextWidget(
                                    textType: TextType.TEXT_MEDIUM,
                                    text: pageName == PageName.LOAD_PAGE
                                        ? '${tractorList[index].keys.first.totalLoadsPercent}%'
                                       // ? 'Contribution(%) :  ${tractorList[index].keys.first.totalLoadsPercent}'
                                        : pageName == PageName.LOAD_PAGE
                                        ? '${tractorList[index].keys.first.totalMilesPercent}%'
                                           // ? 'Contribution(%) :  ${tractorList[index].keys.first.totalMilesPercent}'
                                            : pageName == PageName.FUEL_PAGE
                                               // ? 'Contribution(%) :  ${tractorList[index].keys.first.totalGallonsPercent}'
                                               // : 'Contribution(%) :  ${tractorList[index].keys.first.totalNetPercent}',
                                                  ? '${tractorList[index].keys.first.totalGallonsPercent}%'
                                                  : '${tractorList[index].keys.first.totalNetPercent}%',
                                  ),
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 3,
                          child: Container(
                            height: 65,
                            color: Colors.teal,
                            child: Center(
                              child: TextWidget(
                                text: pageName == PageName.LOAD_PAGE
                                    ? '${Utils.formatDecimalToWholeNumber(tractorList[index].keys.first.totalLoads)}'
                                    : pageName == PageName.MILES_PAGE
                                        ? '${Utils.formatDecimalToWholeNumber(tractorList[index].keys.first.totalMiles)}'
                                        : pageName == PageName.FUEL_PAGE
                                            ? '${Utils.formatDecimalToWholeNumber(tractorList[index].keys.first.totalTractorGallons)}'
                                            : '${Utils.formatDecimalToWholeNumber(tractorList[index].keys.first.totalNet)}',
                                colorText: AppColors.colorWhite,
                                textType: TextType.TEXT_MEDIUM,
                                isBold: true,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: TractorDetailsPage(pageName,
                          tractorList[index].keys.first, dashboardData)));
            },
          );
        },
      ),
    );
  }
}
