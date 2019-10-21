import 'package:bloc/bloc.dart';

import 'package:forwardair_fleet_management/blocs/barrels/unavailability.dart';
import 'package:forwardair_fleet_management/databasemanager/user_manager.dart';
import 'package:forwardair_fleet_management/models/login_model.dart';
import 'package:forwardair_fleet_management/models/unavailability_data_model.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

class UnavailabilityBloc
    extends Bloc<UnavailabilityEvents, UnavailabilityStates> {


  //It will call to map initial State
  @override
  UnavailabilityStates get initialState => InitialState();

  //Here will map state according to event
  @override
  Stream<UnavailabilityStates> mapEventToState(
    UnavailabilityEvents event,
  ) async* {
    if (event is GetUnavailabilityDataEvent) {
      yield* _makeApiCall(event);
    } else if (event is TappedonLeaveListItemEvent) {
      yield InitialState();
      yield TappedonLeaveListItemState(dataModelDetail: event.dataModelDetail);
    }
  }

  //This method is check internet first, If we have internet connection
  // then call an API else show some error
  Stream<UnavailabilityStates> _makeApiCall(
      GetUnavailabilityDataEvent event) async* {
    //since api is not exist. so adding dummy data.
    UnavailabilityDataModelDetail dataModelDetail =
        UnavailabilityDataModelDetail(
            leaveStartDate: '20191210',
            leaveEndDate: '20191211',
            city: 'Panama City',
            state: 'FL',
            reason: 'Personal',
            submittedDateAndTime: '20191101',
            sumittedId: 'TRID6532',requestedBy: 'Jhon Doe');
    UnavailabilityDataModelDetail dataModelDetail2 =
        UnavailabilityDataModelDetail(
            leaveStartDate: '20191210',
            city: 'Newyork City',
            state: 'NY',
            reason: 'Going for family trip',
            submittedDateAndTime: '20191204',
            sumittedId: 'TRID7583', requestedBy: 'Jhon');
    UnavailabilityDataModelDetail dataModelDetail3 =
    UnavailabilityDataModelDetail(
        leaveStartDate: '20191017',
        city: 'Newyork City',
        state: 'NY',
        reason: 'I have to go to las vegas.',
        submittedDateAndTime: '20190903',
        sumittedId: 'TRID7583', requestedBy: 'Flora');
    UnavailabilityDataModelDetail dataModelDetail4 =
    UnavailabilityDataModelDetail(
        leaveStartDate: '20191207',
        city: 'Las Vegas',
        state: 'NV',
        reason: 'Going for family trip',
        submittedDateAndTime: '20191101',
        sumittedId: 'TRID7583', requestedBy: 'Doe');
    UnavailabilityDataModel dataModel = UnavailabilityDataModel(
        unavailabilityDetails: [dataModelDetail, dataModelDetail2, dataModelDetail3,dataModelDetail4, ]);
    //Upcoming Unavailability List
    List<UnavailabilityDataModelDetail> upcomingUnavailabilityItems = [];
    //Past Unavailability List
    List<UnavailabilityDataModelDetail> pastUnavailabilityItems = [];
    //Finding out Past and Upcoming items.
    for (var aModel in dataModel.unavailabilityDetails) {
      if (Utils.findOutDateIsPastAndFuture(aModel.leaveStartDate) == true) {
        pastUnavailabilityItems.add(aModel);
      } else {
        upcomingUnavailabilityItems.add(aModel);
      }
    }
    upcomingUnavailabilityItems.sort((UnavailabilityDataModelDetail a,UnavailabilityDataModelDetail b) {
      return a.leaveStartDate.compareTo(b.leaveStartDate);
    });
    pastUnavailabilityItems.sort((UnavailabilityDataModelDetail a,UnavailabilityDataModelDetail b) {
      return a.leaveStartDate.compareTo(b.leaveStartDate);
    });

    if (dataModel != null) {
      yield SuccessState(
          unavailabilityDataModel: dataModel,
          pastUnavailabilityList: pastUnavailabilityItems,
          upcomingUnavailabilityList: upcomingUnavailabilityItems);
    } else {
      yield ErrorState(errorMessage: Constants.SOMETHING_WRONG);
    }
  }

  //To format Start and End Date
  String formatStartAndEndDate(String inputString) {
    String formattedDate = Utils.formatStartAndEndDate(inputString);
    return formattedDate;
  }

  //To combine Start and End Date String.
  String combineStartAndEndDate(String startDateText, String endDateText) {
    String startDate =
        formatStartAndEndDate(startDateText == null ? '' : startDateText);
    String endDate =
        formatStartAndEndDate(endDateText == null ? '' : endDateText);
    if (startDate == null && endDate == null) {
      return 'N/A';
    } else if (startDate != '' && endDate != '') {
      return '$startDate - $endDate';
    } else if (startDate != '' && endDate == '') {
      return startDate;
    } else if (startDate == '' && endDate != '') {
      return endDate;
    } else {
      return 'N/A';
    }
  }

  //To combine City and State
  String combineCityAndState(String city, String state) {
    if (city == null && state == null) {
      return 'N/A';
    } else if (city != '' && state != '') {
      return '$city, $state';
    } else if (city != '' && state == '') {
      return city;
    } else if (city == '' && state != '') {
      return state;
    } else {
      return 'N/A';
    }
  }

  //Combine Submitted Date Time and Submmitted ID
  String combineSubmittedDateTimeAndId(String sumittedDate, String subId) {
    String subDate =
        Utils.formatDateAndTime(sumittedDate == null ? '' : sumittedDate);
    if (subDate == '') {
      subDate = 'N/A';
    }
    String submittedId = subId == null ? '' : subId;
    return 'Submitted on $subDate by $submittedId';
  }
}
