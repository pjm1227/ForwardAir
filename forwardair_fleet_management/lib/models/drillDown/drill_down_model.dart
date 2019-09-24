import 'dart:convert';


DrillDownModel drillDownModelFromJson(String str) =>
    DrillDownModel.fromJson(json.decode(str));
class DrillDownModel{
  String companyCd;
  String contractorCd;
  String weekStart;
  String weekEnd;
  List<Tractors> tractors;

  DrillDownModel({
    this.companyCd,
    this.contractorCd,
    this.weekStart,
    this.weekEnd,
    this.tractors,
  });

  factory DrillDownModel.fromJson(Map<String, dynamic> json) => DrillDownModel(
    companyCd: json["companyCd"] == null ? null : json["companyCd"],
    contractorCd: json["contractorCd"] == null ? null : json["contractorCd"],
    weekStart: json["weekStart"] == null ? null : json["weekStart"],
    weekEnd: json["weekEnd"] == null ? null : json["weekEnd"],
      tractors: json["tractors"] == null
          ? null
          : List<Tractors>.from(
          json["tractors"].map((x) => Tractors.fromJson(x)))
  );
}

class Tractors{
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

  Tractors({
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
    this.totalFuelCostPercent
  });

  factory Tractors.fromJson(Map<String, dynamic> json) => Tractors(
    tractorId: json["tractorId"] == null ? null : json["tractorId"],
    totalMiles: json["totalMiles"] == null ? null : json["totalMiles"],
    loadedMiles: json["loadedMiles"] == null ? null : json["loadedMiles"],
    emptyMiles: json["emptyMiles"] == null ? null : json["emptyMiles"],
    totalLoads: json["totalLoads"] == null ? null : json["totalLoads"],
    loadedLoads: json["loadedLoads"] == null ? null : json["loadedLoads"],
    emptyLoads: json["emptyLoads"] == null ? null : json["emptyLoads"],
    totalTractorGallons: json["totalTractorGallons"] == null ? null : json["totalTractorGallons"],
    totalFuelCost: json["totalFuelCost"] == null ? null : json["totalFuelCost"],
    totalNet: json["totalNet"] == null ? null : json["totalNet"],
    totalMilesPercent: json["totalMilesPercent"] == null ? null : json["totalMilesPercent"],
    totalLoadsPercent: json["totalLoadsPercent"] == null ? null : json["totalLoadsPercent"],
    totalNetPercent: json["totalNetPercent"] == null ? null : json["totalNetPercent"],
    totalGallonsPercent: json["totalGallonsPercent"] == null ? null : json["totalGallonsPercent"],
    totalFuelCostPercent: json["totalFuelCostPercent"] == null ? null : json["totalFuelCostPercent"],
  );


}