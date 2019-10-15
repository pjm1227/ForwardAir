import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/components/no_internet_connection.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/components/shimmer/list_shimmer.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/fleetTracker/fleet_tracker_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:forwardair_fleet_management/blocs/barrels/fleet_tracker.dart';


class FleetTrackerPage extends StatefulWidget {

@override
_FleetTrackerPage createState() =>
    _FleetTrackerPage();
}
class _FleetTrackerPage extends State<FleetTrackerPage>{

  FleetTrackerBloc _fleetBloc = FleetTrackerBloc();

  @override
  void initState(){
    _fleetBloc.dispatch(FetchFleetDataEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.colorWhite),
        centerTitle: false,
        title: TextWidget(
          text: "Fleet Tracker",
          colorText: AppColors.colorWhite,
          textType: TextType.TEXT_LARGE,
        ),
      ),
      backgroundColor: AppColors.colorDashboard_Bg,
      body: BlocListener<FleetTrackerBloc, FleetTrackerState>(
        listener: (context, state) {},
        bloc: _fleetBloc,
        child: BlocBuilder<FleetTrackerBloc, FleetTrackerState>(
          bloc: _fleetBloc,
          builder: (context, state) {
            if (state is DetailsErrorState) {
              if (state.errorMessage == Constants.NO_INTERNET_FOUND) {
                return NoInternetFoundWidget();
              } else {
                return NoResultFoundWidget();
              }
            }
            //If state is success then show data in list
            if (state is SuccessState) {
              if (state.fleetModel!=null) {
                return successWidget(state.fleetModel);
              } else {
                return NoResultFoundWidget();
              }
            }
            return ListViewShimmer(
              listLength: 10,
            );
          },
        ),
      ),
    );
  }

  Widget successWidget(FleetTrackerModel dataModel) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0,bottom: 8,left: 8,right: 8),
      child: new  ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: dataModel.currentPositions.length,
          itemBuilder: (BuildContext context, int index) {
            return _listItem(dataModel.currentPositions[index]);
          },
        ),
    );

  }

  Widget _listItem(CurrentPositions fleetData) {
    return Card(
        elevation: 4.0,
        margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Row widget to show dot,header and price
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, left: 8, right: 8, bottom: 4),
              child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      color: fleetData.ignitionOnOff == 'ON'
                          ? Colors.green
                          : AppColors.colorRed,
                      height: 8.0,
                      width: 8.0,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      //column is required for driverName and driver class widget
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextWidget(
                            text: fleetData.driverName!=null?fleetData.driverName:"Michael Joseph",
                            colorText: AppColors.colorBlack,
                            textType: TextType.TEXT_SMALL,
                          ),
                          TextWidget(
                            text: fleetData.driverClass!=null?fleetData.driverClass:"Class A",
                            colorText: AppColors.colorBlack,
                            textType: TextType.TEXT_SMALL,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Active and NonActive Text Widget
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: TextWidget(
                        text: fleetData.ignitionOnOff=='ON'?"Active":"Unavailable", //'\$' + amount,
                        colorText: fleetData.ignitionOnOff=='ON'?Colors.green:Colors.red,
                        isBold: true,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Divider

            Padding(
              padding: const EdgeInsets.only(top: 4.0,left: 4,right: 4),
              child: Divider(
                height: 1,
                color: AppColors.colorGrey,
              ),
            ),

            // Unit Number Text Widget
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8,right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:4,
                    child: TextWidget(
                      text: 'Unit',
                      colorText: AppColors.colorGrey,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextWidget(
                      text:  fleetData.unitNbr != null?'${fleetData.unitNbr}':"N/A",
                      colorText: AppColors.colorBlack,
                      isBold: true,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),

            //Location Widget

            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0,right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:4,
                    child: TextWidget(
                      text: 'Location',
                      colorText: AppColors.colorGrey,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextWidget(
                      text: fleetData.placeName != null
                          ? '${fleetData.placeName}'
                          : 'N/A',
                      colorText: AppColors.colorBlack,
                      isBold: true,
                      textAlign: TextAlign.end
                    ),
                  ),
                ],
              ),
            ),

            //Current Load Text Widget

            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0,right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:4,
                    child: TextWidget(
                      text: 'Current Load',
                      colorText: AppColors.colorGrey,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextWidget(
                      text: fleetData.currentOrder != null
                          ? '${fleetData.currentOrder}'
                          : 'N/A',
                      colorText: AppColors.colorBlack,
                      isBold: true,
                      textAlign: TextAlign.end
                    ),
                  ),
                ],
              ),
            ),

            //Expected time Text Widget

            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0,right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:4,
                    child: TextWidget(
                      text: 'ETA',
                      colorText: AppColors.colorGrey,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextWidget(
                      text: fleetData.etaDt != null
                          ? Utils.formatTimeFromString(
                          fleetData.etaDt)
                          : "N/A",
                      isBold: true,
                      textAlign: TextAlign.end
                    ),
                  ),
                ],
              ),
            ),

            //NextOrder Text Widget

            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0,right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:4,
                    child: TextWidget(
                      text: 'Next Load',
                      colorText: AppColors.colorGrey,
                    ),
                  ),
                  Expanded(
                    flex:2,
                    child: TextWidget(
                      text: fleetData.nextOrder != null
                          ? '${fleetData.nextOrder}'
                          : 'N/A',
                      isBold: true,
                      textAlign: TextAlign.end
                    ),
                  ),
                ],
              ),
            ),

            //scheduleDepart Text Widget

            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0,right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:4,
                    child: TextWidget(
                      text: 'Sch. Depart',
                      colorText: AppColors.colorGrey,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextWidget(
                      text: fleetData.nextOrderScheduledDepartDt != null
                          ? Utils.formatTimeFromString(
                          fleetData.nextOrderScheduledDepartDt)
                          : "N/A",
                      isBold: true,
                      textAlign: TextAlign.end
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

}