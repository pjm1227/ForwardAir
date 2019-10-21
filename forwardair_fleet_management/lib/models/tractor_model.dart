// To parse this JSON data, do
//
//     final tractorData = tractorDataFromJson(jsonString);

import 'dart:convert';

TractorData tractorDataFromJson(String str) => TractorData.fromJson(json.decode(str));

String tractorDataToJson(TractorData data) => json.encode(data.toJson());

class TractorData {
  String companyCd;
  String contractorCd;
  String weekStart;
  String weekEnd;
  List<Tractor> tractors;

  TractorData({
    this.companyCd,
    this.contractorCd,
    this.weekStart,
    this.weekEnd,
    this.tractors,
  });

  factory TractorData.fromJson(Map<String, dynamic> json) => TractorData(
    companyCd: json["companyCd"] == null ? null : json["companyCd"],
    contractorCd: json["contractorCd"] == null ? null : json["contractorCd"],
    weekStart: json["weekStart"] == null ? null : json["weekStart"],
    weekEnd: json["weekEnd"] == null ? null : json["weekEnd"],
    tractors: json["tractors"] == null ? null : List<Tractor>.from(json["tractors"].map((x) => Tractor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "companyCd": companyCd == null ? null : companyCd,
    "contractorCd": contractorCd == null ? null : contractorCd,
    "weekStart": weekStart == null ? null : weekStart,
    "weekEnd": weekEnd == null ? null : weekEnd,
    "tractors": tractors == null ? null : List<dynamic>.from(tractors.map((x) => x.toJson())),
  };
}

class Tractor {
  String tractorId;
  int totalMiles;
  int loadedMiles;
  int emptyMiles;
  int totalLoads;
  int loadedLoads;
  int emptyLoads;
  double totalTractorGallons;
  double totalFuelCost;
  double totalNet;
  double totalMilesPercent;
  double totalLoadsPercent;
  double totalNetPercent;
  double totalGallonsPercent;
  double totalFuelCostPercent;
  String unitNbr;

  Tractor({
    this.tractorId,
    this.totalMiles,
    this.loadedMiles,
    this.emptyMiles,
    this.totalLoads,
    this.loadedLoads,
    this.emptyLoads,
    this.totalTractorGallons,
    this.totalFuelCost,
    this.totalNet,
    this.totalMilesPercent,
    this.totalLoadsPercent,
    this.totalNetPercent,
    this.totalGallonsPercent,
    this.totalFuelCostPercent,
    this.unitNbr,
  });

  factory Tractor.fromJson(Map<String, dynamic> json) => Tractor(
    tractorId: json["tractorId"] == null ? null : json["tractorId"],
    totalMiles: json["totalMiles"] == null ? null : json["totalMiles"],
    loadedMiles: json["loadedMiles"] == null ? null : json["loadedMiles"],
    emptyMiles: json["emptyMiles"] == null ? null : json["emptyMiles"],
    totalLoads: json["totalLoads"] == null ? null : json["totalLoads"],
    loadedLoads: json["loadedLoads"] == null ? null : json["loadedLoads"],
    emptyLoads: json["emptyLoads"] == null ? null : json["emptyLoads"],
    totalTractorGallons: json["totalTractorGallons"] == null ? null : json["totalTractorGallons"].toDouble(),
    totalFuelCost: json["totalFuelCost"] == null ? null : json["totalFuelCost"].toDouble(),
    totalNet: json["totalNet"]==null ? null : json["totalNetPercent"].toDouble(),
    totalMilesPercent: json["totalMilesPercent"] == null ? null : json["totalMilesPercent"].toDouble(),
    totalLoadsPercent: json["totalLoadsPercent"] == null ? null : json["totalLoadsPercent"].toDouble(),
    totalNetPercent: json["totalNetPercent"]== null ? null : json["totalNetPercent"].toDouble(),
    totalGallonsPercent: json["totalGallonsPercent"] == null ? null : json["totalGallonsPercent"].toDouble(),
    totalFuelCostPercent: json["totalFuelCostPercent"] == null ? null : json["totalFuelCostPercent"].toDouble(),
    unitNbr: json["unitNbr"] == null ? null : json["unitNbr"],
  );

  Map<String, dynamic> toJson() => {
    "tractorId": tractorId == null ? null : tractorId,
    "totalMiles": totalMiles == null ? null : totalMiles,
    "loadedMiles": loadedMiles == null ? null : loadedMiles,
    "emptyMiles": emptyMiles == null ? null : emptyMiles,
    "totalLoads": totalLoads == null ? null : totalLoads,
    "loadedLoads": loadedLoads == null ? null : loadedLoads,
    "emptyLoads": emptyLoads == null ? null : emptyLoads,
    "totalTractorGallons": totalTractorGallons == null ? null : totalTractorGallons,
    "totalFuelCost": totalFuelCost == null ? null : totalFuelCost,
    "totalNet": totalNet,
    "totalMilesPercent": totalMilesPercent == null ? null : totalMilesPercent,
    "totalLoadsPercent": totalLoadsPercent == null ? null : totalLoadsPercent,
    "totalNetPercent": totalNetPercent,
    "totalGallonsPercent": totalGallonsPercent == null ? null : totalGallonsPercent,
    "totalFuelCostPercent": totalFuelCostPercent == null ? null : totalFuelCostPercent,
    "unitNbr": unitNbr == null ? null : unitNbr,
  };
}
