// To parse this JSON data, do
//
//     final loadChartData = loadChartDataFromJson(jsonString);

import 'dart:convert';

LoadChartData loadChartDataFromJson(String str) =>
    LoadChartData.fromJson(json.decode(str));

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
        contractorCd:
            json["contractorCd"] == null ? null : json["contractorCd"],
        weekStart: json["weekStart"] == null ? 0 : json["weekStart"],
        weekEnd: json["weekEnd"] == null ? 0 : json["weekEnd"],
        days: json["days"] == null
            ? null
            : List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "companyCd": companyCd == null ? null : companyCd,
        "contractorCd": contractorCd == null ? null : contractorCd,
        "weekStart": weekStart == null ? 0 : weekStart,
        "weekEnd": weekEnd == null ? 0 : weekEnd,
        "days": days == null
            ? null
            : List<dynamic>.from(days.map((x) => x.toJson())),
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
  double totalTractorGallons;
  double totalFuelCost;
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
        tractorCount: json["tractorCount"] == null ? 0 : json["tractorCount"],
        totalMiles: json["totalMiles"] == null ? 0 : json["totalMiles"],
        loadedMiles: json["loadedMiles"] == null ? 0 : json["loadedMiles"],
        emptyMiles: json["emptyMiles"] == null ? 0 : json["emptyMiles"],
        totalLoads: json["totalLoads"] == null ? 0 : json["totalLoads"],
        loadedLoads: json["loadedLoads"] == null ? 0 : json["loadedLoads"],
        emptyLoads: json["emptyLoads"] == null ? 0 : json["emptyLoads"],
        totalTractorGallons: json["totalTractorGallons"] == null
            ? 0.0
            : json["totalTractorGallons"],
        totalFuelCost:
            json["totalFuelCost"] == null ? 0.0 : json["totalFuelCost"],
        weekDt: json["weekDt"] == null ? null : json["weekDt"],
        dayOfWeek: json["dayOfWeek"] == null ? 0 : json["dayOfWeek"],
      );

  Map<String, dynamic> toJson() => {
        "tractorCount": tractorCount == null ? 0 : tractorCount,
        "totalMiles": totalMiles == null ? 0 : totalMiles,
        "loadedMiles": loadedMiles == null ? 0 : loadedMiles,
        "emptyMiles": emptyMiles == null ? 0 : emptyMiles,
        "totalLoads": totalLoads == null ? 0 : totalLoads,
        "loadedLoads": loadedLoads == null ? 0 : loadedLoads,
        "emptyLoads": emptyLoads == null ? 0 : emptyLoads,
        "totalTractorGallons":
            totalTractorGallons == null ? 0.0 : totalTractorGallons,
        "totalFuelCost": totalFuelCost == null ? 0.0 : totalFuelCost,
        "weekDt": weekDt == null ? null : weekDt,
        "dayOfWeek": dayOfWeek == null ? 0 : dayOfWeek,
      };
}
