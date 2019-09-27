// To parse this JSON data, do
//
//     final loadChartData = loadChartDataFromJson(jsonString);

import 'dart:convert';

LoadChartData loadChartDataFromJson(String str) => LoadChartData.fromJson(json.decode(str));

String loadChartDataToJson(LoadChartData data) => json.encode(data.toJson());

class LoadChartData {
  String companyCd;
  String contractorCd;
  int weekStart;
  int weekEnd;
  List<Day> days;

  LoadChartData({
    this.companyCd,
    this.contractorCd,
    this.weekStart,
    this.weekEnd,
    this.days,
  });

  factory LoadChartData.fromJson(Map<String, dynamic> json) => LoadChartData(
    companyCd: json["companyCd"] == null ? null : json["companyCd"],
    contractorCd: json["contractorCd"] == null ? null : json["contractorCd"],
    weekStart: json["weekStart"] == null ? null : json["weekStart"],
    weekEnd: json["weekEnd"] == null ? null : json["weekEnd"],
    days: json["days"] == null ? null : List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "companyCd": companyCd == null ? null : companyCd,
    "contractorCd": contractorCd == null ? null : contractorCd,
    "weekStart": weekStart == null ? null : weekStart,
    "weekEnd": weekEnd == null ? null : weekEnd,
    "days": days == null ? null : List<dynamic>.from(days.map((x) => x.toJson())),
  };
}

class Day {
  int tractorCount;
  int totalMiles;
  int loadedMiles;
  int emptyMiles;
  int totalLoads;
  int loadedLoads;
  int emptyLoads;
  int totalTractorGallons;
  int totalFuelCost;
  String weekDt;
  int dayOfWeek;

  Day({
    this.tractorCount,
    this.totalMiles,
    this.loadedMiles,
    this.emptyMiles,
    this.totalLoads,
    this.loadedLoads,
    this.emptyLoads,
    this.totalTractorGallons,
    this.totalFuelCost,
    this.weekDt,
    this.dayOfWeek,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    tractorCount: json["tractorCount"] == null ? null : json["tractorCount"],
    totalMiles: json["totalMiles"] == null ? null : json["totalMiles"],
    loadedMiles: json["loadedMiles"] == null ? null : json["loadedMiles"],
    emptyMiles: json["emptyMiles"] == null ? null : json["emptyMiles"],
    totalLoads: json["totalLoads"] == null ? null : json["totalLoads"],
    loadedLoads: json["loadedLoads"] == null ? null : json["loadedLoads"],
    emptyLoads: json["emptyLoads"] == null ? null : json["emptyLoads"],
    totalTractorGallons: json["totalTractorGallons"] == null ? null : json["totalTractorGallons"],
    totalFuelCost: json["totalFuelCost"] == null ? null : json["totalFuelCost"],
    weekDt: json["weekDt"] == null ? null : json["weekDt"],
    dayOfWeek: json["dayOfWeek"] == null ? null : json["dayOfWeek"],
  );

  Map<String, dynamic> toJson() => {
    "tractorCount": tractorCount == null ? null : tractorCount,
    "totalMiles": totalMiles == null ? null : totalMiles,
    "loadedMiles": loadedMiles == null ? null : loadedMiles,
    "emptyMiles": emptyMiles == null ? null : emptyMiles,
    "totalLoads": totalLoads == null ? null : totalLoads,
    "loadedLoads": loadedLoads == null ? null : loadedLoads,
    "emptyLoads": emptyLoads == null ? null : emptyLoads,
    "totalTractorGallons": totalTractorGallons == null ? null : totalTractorGallons,
    "totalFuelCost": totalFuelCost == null ? null : totalFuelCost,
    "weekDt": weekDt == null ? null : weekDt,
    "dayOfWeek": dayOfWeek == null ? null : dayOfWeek,
  };
}
