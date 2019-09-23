import 'dart:convert';


LoadDetailModel loadDetailModelFromJson(String str) =>
    LoadDetailModel.fromJson(json.decode(str));
class LoadDetailModel{
  String companyCd;
  String contractorCd;
  String weekStart;
  String weekEnd;
  String year;
  int month;
  List<Loads> loadDetails;

  LoadDetailModel({
    this.companyCd,
    this.contractorCd,
    this.weekStart,
    this.weekEnd,
    this.loadDetails,
    this.month,
    this.year
  });

  factory LoadDetailModel.fromJson(Map<String, dynamic> json) => LoadDetailModel(
      companyCd: json["companyCd"] == null ? null : json["companyCd"],
      contractorCd: json["contractorCd"] == null ? null : json["contractorCd"],
      weekStart: json["weekStart"] == null ? null : json["weekStart"],
      weekEnd: json["weekEnd"] == null ? null : json["weekEnd"],
      month: json["month"] == null ? null : json["month"],
      year: json["year"] == null ? null : json["year"],
      loadDetails: json["loadDetails"] == null
          ? null
          : List<Loads>.from(
          json["loadDetails"].map((x) => Loads.fromJson(x)))
  );
}

class Loads{
  String tractorId;
  String dispatchDt;
  String orderNbr;
  String settlementStatus;
  String settlementFinalDt;
  String driverOriginCity;
  String settlementPaidDt;
  String driverOriginSt;
  String originCity;
  String originSt;
  String destCity;
  String destSt;
  int loadedMiles;
  int emptyMiles;
  String driver1Id;
  String driver1FirstName;
  String driver1LastName;

  Loads({
    this.tractorId,
    this.dispatchDt,
    this.orderNbr,
    this.settlementStatus,
    this.settlementFinalDt,
    this.driverOriginCity,
    this.settlementPaidDt,
    this.driverOriginSt,
    this.originCity,
    this.originSt,
    this.destCity,
    this.destSt,
    this.loadedMiles,
    this.emptyMiles,
    this.driver1Id,
    this.driver1FirstName,
    this.driver1LastName

  });

  factory Loads.fromJson(Map<String, dynamic> json) => Loads(
    tractorId: json["tractorId"] == null ? null : json["tractorId"],
    dispatchDt: json["dispatchDt"] == null ? null : json["dispatchDt"],
    orderNbr: json["orderNbr"] == null ? null : json["orderNbr"],
    settlementStatus: json["settlementStatus"] == null ? null : json["settlementStatus"],
    settlementFinalDt: json["settlementFinalDt"] == null ? null : json["settlementFinalDt"],
    driverOriginCity: json["driverOriginCity"] == null ? null : json["driverOriginCity"],
    settlementPaidDt: json["settlementPaidDt"] == null ? null : json["settlementPaidDt"],
    driverOriginSt: json["driverOriginSt"] == null ? null : json["driverOriginSt"],
    originCity: json["originCity"] == null ? null : json["originCity"],
    originSt: json["originSt"] == null ? null : json["originSt"],
    destCity: json["destCity"] == null ? null : json["destCity"],
    destSt: json["destSt"] == null ? null : json["destSt"],
    loadedMiles: json["loadedMiles"] == null ? null : json["loadedMiles"],
    emptyMiles: json["emptyMiles"] == null ? null : json["emptyMiles"],
    driver1Id: json["driver1Id"] == null ? null : json["driver1Id"],
    driver1FirstName: json["driver1FirstName"] == null ? null : json["driver1FirstName"],
    driver1LastName: json["driver1LastName"] == null ? null : json["driver1LastName"],
  );


}