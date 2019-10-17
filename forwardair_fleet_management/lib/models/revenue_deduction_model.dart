// To parse this JSON data, do
//
//     final revenueDeductionModel = revenueDeductionModelFromJson(jsonString);

import 'dart:convert';

RevenueDeductionModel revenueDeductionModelFromJson(String str) => RevenueDeductionModel.fromJson(json.decode(str));

String revenueDeductionModelToJson(RevenueDeductionModel data) => json.encode(data.toJson());

class RevenueDeductionModel {
  String companyCd;
  String contractorCd;
  int month;
  int year;
  int weekStart;
  int weekEnd;
  String checkNbr;
  String checkDt;
  String payPeriodEndDt;
  int oid;
  String transactionDt;
  String tractorId;
  String category;
  String description;
  int drivercontribution;
  double originalbalance;
  int driverowing;
  int servicecharge;
  int payment;
  String unitNbr;

  RevenueDeductionModel({
    this.companyCd,
    this.contractorCd,
    this.month,
    this.year,
    this.weekStart,
    this.weekEnd,
    this.checkNbr,
    this.checkDt,
    this.payPeriodEndDt,
    this.oid,
    this.transactionDt,
    this.tractorId,
    this.category,
    this.description,
    this.drivercontribution,
    this.originalbalance,
    this.driverowing,
    this.servicecharge,
    this.payment,
    this.unitNbr,
  });

  factory RevenueDeductionModel.fromJson(Map<String, dynamic> json) => RevenueDeductionModel(
    companyCd: json["companyCd"] == null ? null : json["companyCd"],
    contractorCd: json["contractorCd"] == null ? null : json["contractorCd"],
    month: json["month"] == null ? null : json["month"],
    year: json["year"] == null ? null : json["year"],
    weekStart: json["weekStart"] == null ? null : json["weekStart"],
    weekEnd: json["weekEnd"] == null ? null : json["weekEnd"],
    checkNbr: json["checkNbr"] == null ? null : json["checkNbr"],
    checkDt: json["checkDt"] == null ? null : json["checkDt"],
    payPeriodEndDt: json["payPeriodEndDt"] == null ? null : json["payPeriodEndDt"],
    oid: json["oid"] == null ? null : json["oid"],
    transactionDt: json["transactionDt"] == null ? null : json["transactionDt"],
    tractorId: json["tractorId"] == null ? null : json["tractorId"],
    category: json["category"] == null ? null : json["category"],
    description: json["description"] == null ? null : json["description"],
    drivercontribution: json["drivercontribution"] == null ? null : json["drivercontribution"],
    originalbalance: json["originalbalance"] == null ? null : json["originalbalance"].toDouble(),
    driverowing: json["driverowing"] == null ? null : json["driverowing"],
    servicecharge: json["servicecharge"] == null ? null : json["servicecharge"],
    payment: json["payment"] == null ? null : json["payment"],
    unitNbr: json["unitNbr"] == null ? null : json["unitNbr"],
  );

  Map<String, dynamic> toJson() => {
    "companyCd": companyCd == null ? null : companyCd,
    "contractorCd": contractorCd == null ? null : contractorCd,
    "month": month == null ? null : month,
    "year": year == null ? null : year,
    "weekStart": weekStart == null ? null : weekStart,
    "weekEnd": weekEnd == null ? null : weekEnd,
    "checkNbr": checkNbr == null ? null : checkNbr,
    "checkDt": checkDt == null ? null : checkDt,
    "payPeriodEndDt": payPeriodEndDt == null ? null : payPeriodEndDt,
    "oid": oid == null ? null : oid,
    "transactionDt": transactionDt == null ? null : transactionDt,
    "tractorId": tractorId == null ? null : tractorId,
    "category": category == null ? null : category,
    "description": description == null ? null : description,
    "drivercontribution": drivercontribution == null ? null : drivercontribution,
    "originalbalance": originalbalance == null ? null : originalbalance,
    "driverowing": driverowing == null ? null : driverowing,
    "servicecharge": servicecharge == null ? null : servicecharge,
    "payment": payment == null ? null : payment,
    "unitNbr": unitNbr == null ? null : unitNbr,
  };
}
