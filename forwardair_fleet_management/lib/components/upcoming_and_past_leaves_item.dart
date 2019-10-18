import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/blocs/barrels/unavailability.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/enums/page_names.dart';
import 'package:forwardair_fleet_management/models/loadDetails/load_detail_model.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

//This class is called to Upcoming and Past Leave Item in Unavailability
class UpcomingAndPastLeavesItem extends StatelessWidget {

  final UnavailabilityDataModelDetail unavailabilityDataModelDetail;
  final UnavailabilityBloc unavailabilityBloc;

  const UpcomingAndPastLeavesItem({Key key,@required this.unavailabilityDataModelDetail,@required this.unavailabilityBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: new EdgeInsets.only(
          left: 10.0, right: 10, top: 5.0, bottom: 5.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextWidget(
            text: Constants.TEXT_TIME_OFF,
            textType: TextType.TEXT_SMALL,
            colorText: AppColors.colorBlue,
            isBold: true,
          ),
          _displayIconAndTextInRow(
              Icon(
                Icons.calendar_today,
                size: 15,
                color: AppColors.colorBlue,
              ),
              unavailabilityBloc.combineStartAndEndDate(
                  unavailabilityDataModelDetail.leaveStartDate,
                  unavailabilityDataModelDetail.leaveEndDate),
              AppColors.colorBlack,
              TextType.TEXT_SMALL),
          _displayIconAndTextInRow(
              Icon(
                Icons.location_on,
                color: AppColors.colorBlue,
                size: 15,
              ),
              unavailabilityBloc.combineCityAndState(
                  unavailabilityDataModelDetail.city,
                  unavailabilityDataModelDetail.state),
              AppColors.colorBlack,
              TextType.TEXT_SMALL),
          _displayIconAndTextInRow(
              Icon(
                Icons.description,
                color: AppColors.colorBlue,
                size: 15,
              ),
              unavailabilityDataModelDetail.reason,
              AppColors.colorBlack,
              TextType.TEXT_SMALL),
          _displayIconAndTextInRow(
              Icon(
                Icons.person_outline,
                color: AppColors.colorBlue,
                size: 15,
              ),
              unavailabilityBloc.combineSubmittedDateTimeAndId(
                  unavailabilityDataModelDetail.submittedDateAndTime,
                  unavailabilityDataModelDetail.sumittedId),
              AppColors.colorGrey,
              null),
        ],
      ),
    );
  }

  Widget _displayIconAndTextInRow(
      Icon icon, String title, Color color, TextType textType) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 5, left: 5),
        child: Row(
          children: <Widget>[
            icon,
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextWidget(
                text: title,
                colorText: color,
                textType: textType,
              ),
            ),
          ],
        ));
  }
}