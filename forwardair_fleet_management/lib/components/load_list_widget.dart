import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/models/tractor_model.dart';
import 'package:forwardair_fleet_management/screens/load_detail.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:page_transition/page_transition.dart';

import 'text_widget.dart';

//This widget return a list view widget that can be use at Load Page and
//Miles Page
class LoadListViewWidget extends StatelessWidget {
  final List<Tractor> tractorList;
  final PageName pageName;
  final Dashboard_DB_Model dashboardData;

  const LoadListViewWidget({
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
                                      child: Container(
                                        color: pageName == PageName.LOAD_PAGE &&
                                                tractorList[index].emptyLoads ==
                                                    0
                                            ? AppColors.colorRed
                                            : tractorList[index].emptyMiles == 0
                                                ? AppColors.colorRed
                                                : AppColors.colorDOT,
                                        height: 8.0,
                                        width: 8.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextWidget(
                                        text:
                                            'Tractor ID :  ${tractorList[index].tractorId}',
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
                                        ? 'Contribution(%) :  ${tractorList[index].totalLoadsPercent}'
                                        : 'Contribution(%) :  ${tractorList[index].totalMilesPercent}',
                                  ),
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 3,
                          child: Container(
                            height: 65,
                            color: AppColors.colorListItem,
                            child: Center(
                              child: TextWidget(
                                text: pageName == PageName.LOAD_PAGE
                                    ? '${tractorList[index].totalLoads}'
                                    : '${tractorList[index].totalMiles}',
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
                      child: LoadDetailsPage(
                          pageName, tractorList[index], dashboardData)));
            },
          );
        },
      ),
    );
  }
}
