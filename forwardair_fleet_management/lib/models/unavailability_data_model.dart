// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

UnavailabilityDataModel unavailabilityFromJson(String str) =>
    UnavailabilityDataModel.fromJson(json.decode(str));

String compensationToJson(UnavailabilityDataModel data) => json.encode(data.toJson());

class UnavailabilityDataModel {
  List<UnavailabilityDataModelDetail> unavailabilityDetails;
  UnavailabilityDataModel({
    this.unavailabilityDetails,
  });

  factory UnavailabilityDataModel.fromJson(Map<String, dynamic> json) =>
      UnavailabilityDataModel(
        unavailabilityDetails: json["unavailabilityDetails"] == null
            ? null
            : List<UnavailabilityDataModelDetail>.from(json["unavailabilityDetails"]
            .map((x) => UnavailabilityDataModelDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "unavailabilityDetails": unavailabilityDetails == null
        ? null
        : List<dynamic>.from(unavailabilityDetails.map((x) => x.toJson())),
  };
}

class UnavailabilityDataModelDetail {
  String leaveStartDate;
  String leaveEndDate;
  String city;
  String state;
  String reason;
  String submittedDateAndTime;
  String sumittedId;

  UnavailabilityDataModelDetail({
    this.leaveStartDate,
    this.leaveEndDate,
    this.city,
    this.state,
    this.reason,
    this.submittedDateAndTime,
    this.sumittedId,
  });

  factory UnavailabilityDataModelDetail.fromJson(Map<String, dynamic> json) =>
      UnavailabilityDataModelDetail(
        leaveStartDate: json["leaveStartDate"] == null ? null : json["leaveStartDate"],
        leaveEndDate: json["leaveEndDate"] == null ? null : json["leaveEndDate"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        reason:
        json["reason"] == null ? null : json["reason"],
        submittedDateAndTime: json["submittedDateAndTime"] == null ? null : json["submittedDateAndTime"],
        sumittedId: json["sumittedId"] == null ? null : json["sumittedId"],
      );

  Map<String, dynamic> toJson() => {
    "leaveStartDate": leaveStartDate == null ? null : leaveStartDate,
    "leaveEndDate": leaveEndDate == null ? null : leaveEndDate,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "reason": reason == null ? null : reason,
    "submittedDateAndTime": submittedDateAndTime == null ? null : submittedDateAndTime,
    "sumittedId": sumittedId == null ? null : sumittedId,
  };
}
