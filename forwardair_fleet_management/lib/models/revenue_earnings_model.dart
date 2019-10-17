// To parse this JSON data, do
//
//     final tractorRevenueModel = tractorRevenueModelFromJson(jsonString);

import 'dart:convert';

TractorRevenueModel tractorRevenueModelFromJson(String str) => TractorRevenueModel.fromJson(json.decode(str));

String tractorRevenueModelToJson(TractorRevenueModel data) => json.encode(data.toJson());

class TractorRevenueModel {
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
  double amount;
  String taxableFlg;
  int qty;
  double rate;
  String uom;
  String orderNbr;
  String originCty;
  String originSt;
  int originDt;
  String destCty;
  String destSt;
  String destDt;
  int loadedMiles;
  int emptyMiles;
  String driver1First;
  String driver1Mi;
  String driver1Last;
  String comment;
  String source;
  String unitNbr;

  TractorRevenueModel({
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
    this.amount,
    this.taxableFlg,
    this.qty,
    this.rate,
    this.uom,
    this.orderNbr,
    this.originCty,
    this.originSt,
    this.originDt,
    this.destCty,
    this.destSt,
    this.destDt,
    this.loadedMiles,
    this.emptyMiles,
    this.driver1First,
    this.driver1Mi,
    this.driver1Last,
    this.comment,
    this.source,
    this.unitNbr,
  });

  factory TractorRevenueModel.fromJson(Map<String, dynamic> json) => TractorRevenueModel(
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
    amount: json["amount"] == null ? null : json["amount"].toDouble(),
    taxableFlg: json["taxableFlg"] == null ? null : json["taxableFlg"],
    qty: json["qty"] == null ? null : json["qty"],
    rate: json["rate"] == null ? null : json["rate"].toDouble(),
    uom: json["uom"] == null ? null : json["uom"],
    orderNbr: json["orderNbr"] == null ? null : json["orderNbr"],
    originCty: json["originCty"] == null ? null : json["originCty"],
    originSt: json["originSt"] == null ? null : json["originSt"],
    originDt: json["originDt"] == null ? null : json["originDt"],
    destCty: json["destCty"] == null ? null : json["destCty"],
    destSt: json["destSt"] == null ? null : json["destSt"],
    destDt: json["destDt"] == null ? null : json["destDt"],
    loadedMiles: json["loadedMiles"] == null ? null : json["loadedMiles"],
    emptyMiles: json["emptyMiles"] == null ? null : json["emptyMiles"],
    driver1First: json["driver1First"] == null ? null : json["driver1First"],
    driver1Mi: json["driver1Mi"] == null ? null : json["driver1Mi"],
    driver1Last: json["driver1Last"] == null ? null : json["driver1Last"],
    comment: json["comment"] == null ? null : json["comment"],
    source: json["source"] == null ? null : json["source"],
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
    "amount": amount == null ? null : amount,
    "taxableFlg": taxableFlg == null ? null : taxableFlg,
    "qty": qty == null ? null : qty,
    "rate": rate == null ? null : rate,
    "uom": uom == null ? null : uom,
    "orderNbr": orderNbr == null ? null : orderNbr,
    "originCty": originCty == null ? null : originCty,
    "originSt": originSt == null ? null : originSt,
    "originDt": originDt == null ? null : originDt,
    "destCty": destCty == null ? null : destCty,
    "destSt": destSt == null ? null : destSt,
    "destDt": destDt == null ? null : destDt,
    "loadedMiles": loadedMiles == null ? null : loadedMiles,
    "emptyMiles": emptyMiles == null ? null : emptyMiles,
    "driver1First": driver1First == null ? null : driver1First,
    "driver1Mi": driver1Mi == null ? null : driver1Mi,
    "driver1Last": driver1Last == null ? null : driver1Last,
    "comment": comment == null ? null : comment,
    "source": source == null ? null : source,
    "unitNbr": unitNbr == null ? null : unitNbr,
  };
}
