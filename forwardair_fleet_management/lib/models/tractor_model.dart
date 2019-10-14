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
  });

  factory Tractor.fromJson(Map<String, dynamic> json) => Tractor(
    tractorId: json["tractorId"] == null ? null : json["tractorId"],
    totalMiles: json["totalMiles"] == null ? 0 : json["totalMiles"],
    loadedMiles: json["loadedMiles"] == null ? 0 : json["loadedMiles"],
    emptyMiles: json["emptyMiles"] == null ? 0 : json["emptyMiles"],
    totalLoads: json["totalLoads"] == null ? 0 : json["totalLoads"],
    loadedLoads: json["loadedLoads"] == null ? 0 : json["loadedLoads"],
    emptyLoads: json["emptyLoads"] == null ? 0 : json["emptyLoads"],
    totalTractorGallons: json["totalTractorGallons"] == null ? 0.0 : json["totalTractorGallons"].toDouble(),
    totalFuelCost: json["totalFuelCost"] == null ? 0.0 : json["totalFuelCost"].toDouble(),
    totalNet: json["totalNet"] == null ? 0.0 : json["totalNet"].toDouble(),
    totalMilesPercent: json["totalMilesPercent"] == null ? 0.0 : json["totalMilesPercent"].toDouble(),
    totalLoadsPercent: json["totalLoadsPercent"] == null ? 0.0 : json["totalLoadsPercent"].toDouble(),
    totalNetPercent: json["totalNetPercent"] == null ? null : json["totalNetPercent"],
    totalGallonsPercent: json["totalGallonsPercent"] == null ? 0.0 : json["totalGallonsPercent"].toDouble(),
    totalFuelCostPercent: json["totalFuelCostPercent"] == null ? 0.0 : json["totalFuelCostPercent"].toDouble(),
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
    "totalNet": totalNet == null ? null : totalNet,
    "totalMilesPercent": totalMilesPercent == null ? null : totalMilesPercent,
    "totalLoadsPercent": totalLoadsPercent == null ? null : totalLoadsPercent,
    "totalNetPercent": totalNetPercent == null ? null : totalNetPercent,
    "totalGallonsPercent": totalGallonsPercent == null ? 0.0 : totalGallonsPercent,
    "totalFuelCostPercent": totalFuelCostPercent == null ? null : totalFuelCostPercent,
  };
}
