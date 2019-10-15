// To parse this JSON data, do
//
//     final settlementModel = settlementModelFromJson(jsonString);

import 'dart:convert';

SettlementModel settlementModelFromJson(String str) => SettlementModel.fromJson(json.decode(str));

String settlementModelToJson(SettlementModel data) => json.encode(data.toJson());

class SettlementModel {
  String companyCd;
  String contractorCd;
  int month;
  String year;
  List<SettlementCheck> settlementChecks;

  SettlementModel({
    this.companyCd,
    this.contractorCd,
    this.month,
    this.year,
    this.settlementChecks,
  });

  factory SettlementModel.fromJson(Map<String, dynamic> json) => SettlementModel(
    companyCd: json["companyCd"],
    contractorCd: json["contractorCd"],
    month: json["month"],
    year: json["year"],
    settlementChecks: List<SettlementCheck>.from(json["settlementChecks"].map((x) => SettlementCheck.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "companyCd": companyCd,
    "contractorCd": contractorCd,
    "month": month,
    "year": year,
    "settlementChecks": List<dynamic>.from(settlementChecks.map((x) => x.toJson())),
  };
}

class SettlementCheck {
  String checkNbr;
  String checkDt;
  String payPeriodEndDt;
  double checkAmt;
  String directDepositFlag;
  String weekNumber;

  SettlementCheck({
    this.checkNbr,
    this.checkDt,
    this.payPeriodEndDt,
    this.checkAmt,
    this.directDepositFlag,
    this.weekNumber,
  });

  factory SettlementCheck.fromJson(Map<String, dynamic> json) => SettlementCheck(
    checkNbr: json["checkNbr"],
    checkDt: json["checkDt"],
    payPeriodEndDt: json["payPeriodEndDt"],
    checkAmt: json["checkAmt"].toDouble(),
    directDepositFlag: json["directDepositFlag"],
    weekNumber: json["weekNumber"],
  );

  Map<String, dynamic> toJson() => {
    "checkNbr": checkNbr,
    "checkDt": checkDt,
    "payPeriodEndDt": payPeriodEndDt,
    "checkAmt": checkAmt,
    "directDepositFlag": directDepositFlag,
    "weekNumber": weekNumber,
  };
}
