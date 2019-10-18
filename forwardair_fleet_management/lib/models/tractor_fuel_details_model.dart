// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

TractorFuelDetailsModel fuelDetailFromJson(String str) =>
    TractorFuelDetailsModel.fromJson(json.decode(str));

String fuelDetailToJson(TractorFuelDetailsModel data) =>
    json.encode(data.toJson());

class TractorFuelDetailsModel {
  String companyCd;
  String contractorCd;
  int month;
  int weekStart;
  int weekEnd;
  String year;
  List<FuelDetail> fuelDetails;

  TractorFuelDetailsModel({
    this.companyCd,
    this.contractorCd,
    int weekStart,
    int weekEnd,
    this.month,
    this.year,
    this.fuelDetails,
  });

  factory TractorFuelDetailsModel.fromJson(Map<String, dynamic> json) =>
      TractorFuelDetailsModel(
        companyCd: json["companyCd"] == null ? null : json["companyCd"],
        contractorCd: json["contractorCd"] == null ? null : json["companyCd"],
        month: json["month"] == null ? 0 : json["month"],
        year: json["year"] == null ? null : json["year"],
        weekStart: json["weekStart"] == null ? 0 : json["weekStart"],
        weekEnd: json["weekEnd"] == null ? 0 : json["weekEnd"],
        fuelDetails: json["fuelDetails"] == null
            ? null
            : List<FuelDetail>.from(
                json["fuelDetails"].map((x) => FuelDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "companyCd": companyCd == null ? null : companyCd,
        "contractorCd": contractorCd == null ? null : contractorCd,
        "month": month == null ? 0 : month,
        "year": year == null ? null : year,
        "weekStart": weekStart == null ? 0 : weekStart,
        "weekEnd": weekEnd == null ? 0 : weekEnd,
        "fuelDetails": fuelDetails == null
            ? null
            : List<dynamic>.from(fuelDetails.map((x) => x.toJson())),
      };
}

class FuelDetail {
  String fuelCardId;
  String tractorId;
  int fuelCardNbr;
  String fuelCardType;
  String driverName;
  String usageDt;
  String truckStopNm;
  String truckStopCty;
  String truckStopSt;
  String truckStopCd;
  String truckStopInvoiceNbr;
  int oilQts;
  String productAmt;
  String cashAdvanceAmt;
  String oilCost;
  String fuelFee;
  String tractorGallons;
  String tractorFuelPricePerGal;
  String cashAdvanceCharge;
  String tractorFuelCost;
  String netAmtDue;
  String rebateAmt;

  FuelDetail({
    this.fuelCardId,
    this.tractorId,
    this.fuelCardNbr,
    this.fuelCardType,
    this.driverName,
    this.usageDt,
    this.truckStopNm,
    this.truckStopCty,
    this.truckStopSt,
    this.truckStopCd,
    this.truckStopInvoiceNbr,
    this.oilQts,
    this.productAmt,
    this.cashAdvanceAmt,
    this.oilCost,
    this.fuelFee,
    this.tractorGallons,
    this.tractorFuelPricePerGal,
    this.cashAdvanceCharge,
    this.tractorFuelCost,
    this.netAmtDue,
    this.rebateAmt,
  });

  factory FuelDetail.fromJson(Map<String, dynamic> json) => FuelDetail(
        fuelCardId: json["fuelCardId"] == null ? null : json["fuelCardId"],
        tractorId: json["tractorId"] == null ? null : json["tractorId"],
        fuelCardNbr: json["fuelCardNbr"] == null ? 0 : json["fuelCardNbr"],
        fuelCardType:
            json["fuelCardType"] == null ? null : json["fuelCardType"],
        driverName: json["driverName"] == null ? null : json["driverName"],
        usageDt: json["usageDt"] == null ? null : json["usageDt"],
        truckStopNm: json["truckStopNm"] == null ? null : json["truckStopNm"],
        truckStopCty:
            json["truckStopCty"] == null ? null : json["truckStopCty"],
        truckStopSt: json["truckStopSt"] == null ? null : json["truckStopSt"],
        truckStopCd: json["truckStopCd"] == null ? null : json["truckStopCd"],
        truckStopInvoiceNbr: json["truckStopInvoiceNbr"] == null
            ? null
            : json["truckStopInvoiceNbr"],
        oilQts: json["oilQts"] == null ? 0 : json["oilQts"],
        productAmt: json["productAmt"] == null ? null : json["productAmt"],
        cashAdvanceAmt:
            json["cashAdvanceAmt"] == null ? null : json["cashAdvanceAmt"],
        oilCost: json["oilCost"] == null ? null: json["oilCost"],
        fuelFee: json["fuelFee"] == null || json["fuelFee"] == 0
            ? null
            : json["fuelFee"],
        tractorGallons: json["tractorGallons"] == null
            ? null
            : json["tractorGallons"],
        tractorFuelPricePerGal: json["tractorFuelPricePerGal"] == null
            ?null
            : json["tractorFuelPricePerGal"],
        cashAdvanceCharge:
            json["cashAdvanceCharge"] == null ? 0 : json["cashAdvanceCharge"],
        tractorFuelCost: json["tractorFuelCost"] == null
            ? null
            : json["tractorFuelCost"],
        netAmtDue:
            json["netAmtDue"] == null ? null : json["netAmtDue"],
        rebateAmt:
            json["rebateAmt"] == null ? null : json["rebateAmt"],
      );

  Map<String, dynamic> toJson() => {
        "fuelCardId": fuelCardId == null ? null : fuelCardId,
        "tractorId": tractorId == null ? null : tractorId,
        "fuelCardNbr": fuelCardNbr == null ? 0 : fuelCardNbr,
        "fuelCardType": fuelCardType == null ? null : fuelCardType,
        "driverName": driverName == null ? null : driverName,
        "usageDt": usageDt == null ? null : usageDt,
        "truckStopNm": truckStopNm == null ? null : truckStopNm,
        "truckStopCty": truckStopCty == null ? null : truckStopCty,
        "truckStopSt": truckStopSt == null ? null : truckStopSt,
        "truckStopCd": truckStopCd == null ? null : truckStopCd,
        "truckStopInvoiceNbr":
            truckStopInvoiceNbr == null ? null : truckStopInvoiceNbr,
        "oilQts": oilQts == null ? 0 : oilQts,
        "productAmt": productAmt == null ? 0 : productAmt,
        "cashAdvanceAmt": cashAdvanceAmt == null ? null : cashAdvanceAmt,
        "oilCost": oilCost == null ? null : oilCost,
        "fuelFee": fuelFee == null ? null : fuelFee,
        "tractorGallons": tractorGallons == null ?null : tractorGallons,
        "tractorFuelPricePerGal":
            tractorFuelPricePerGal == null ? null : tractorFuelPricePerGal,
        "cashAdvanceCharge": cashAdvanceCharge == null ? null : cashAdvanceCharge,
        "tractorFuelCost": tractorFuelCost == null ? null : tractorFuelCost,
        "netAmtDue": netAmtDue == null ? null : netAmtDue,
        "rebateAmt": rebateAmt == null ? null : rebateAmt,
      };
}
