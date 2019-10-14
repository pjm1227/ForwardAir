// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

CompensationModel compensationFromJson(String str) =>
    CompensationModel.fromJson(json.decode(str));

String compensationToJson(CompensationModel data) => json.encode(data.toJson());

class CompensationModel {
  String companyCd;
  String contractorCd;
  int month;
  String year;
  List<SettlementDetail> settlementDetails;

  CompensationModel({
    this.companyCd,
    this.contractorCd,
    this.month,
    this.year,
    this.settlementDetails,
  });

  factory CompensationModel.fromJson(Map<String, dynamic> json) =>
      CompensationModel(
        companyCd: json["companyCd"] == null ? null : json["companyCd"],
        contractorCd:
            json["contractorCd"] == null ? null : json["contractorCd"],
        month: json["month"] == null ? 0 : json["month"],
        year: json["year"] == null ? null : json["year"],
        settlementDetails: json["settlementDetails"] == null
            ? null
            : List<SettlementDetail>.from(json["settlementDetails"]
                .map((x) => SettlementDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "companyCd": companyCd == null ? null : companyCd,
        "contractorCd": contractorCd == null ? null : contractorCd,
        "month": month == null ? 0 : month,
        "year": year == null ? null : year,
        "settlementDetails": settlementDetails == null
            ? null
            : List<dynamic>.from(settlementDetails.map((x) => x.toJson())),
      };
}

class SettlementDetail {
  int oid;
  String checkNbr;
  String tractorId;
  String transType;
  String transactionDt;
  String description;
  double amt;
  String orderNbr;

  SettlementDetail({
    this.oid,
    this.checkNbr,
    this.tractorId,
    this.transType,
    this.transactionDt,
    this.description,
    this.amt,
    this.orderNbr,
  });

  factory SettlementDetail.fromJson(Map<String, dynamic> json) =>
      SettlementDetail(
        oid: json["oid"] == null ? 0 : json["oid"],
        checkNbr: json["checkNbr"] == null ? null : json["checkNbr"],
        tractorId: json["tractorId"] == null ? null : json["tractorId"],
        transType: json["transType"] == null ? null : json["transType"],
        transactionDt:
            json["transactionDt"] == null ? null : json["transactionDt"],
        description: json["description"] == null ? null : json["description"],
        amt: json["amt"] == null ? 0.0 : json["amt"].toDouble(),
        orderNbr: json["orderNbr"] == null ? null : json["orderNbr"],
      );

  Map<String, dynamic> toJson() => {
        "oid": oid == null ? 0 : oid,
        "checkNbr": checkNbr == null ? null : checkNbr,
        "tractorId": tractorId == null ? null : tractorId,
        "transType": transType == null ? null : transType,
        "transactionDt": transactionDt == null ? null : transactionDt,
        "description": description == null ? null : description,
        "amt": amt == null ? 0.0 : amt,
        "orderNbr": orderNbr == null ? null : orderNbr,
      };
}
