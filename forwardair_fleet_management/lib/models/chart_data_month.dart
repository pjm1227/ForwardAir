// To parse this JSON data, do
//
//     final chartDataMonth = chartDataMonthFromJson(jsonString);

import 'dart:convert';

ChartDataMonth chartDataMonthFromJson(String str) =>
    ChartDataMonth.fromJson(json.decode(str));

String chartDataMonthToJson(ChartDataMonth data) => json.encode(data.toJson());

class ChartDataMonth {
  String companyCd;
  String contractorCd;
  int month;
  String year;
  List<Week> weeks;

  ChartDataMonth({
    this.companyCd,
    this.contractorCd,
    this.month,
    this.year,
    this.weeks,
  });

  factory ChartDataMonth.fromJson(Map<String, dynamic> json) => ChartDataMonth(
        companyCd: json["companyCd"] == null ? null : json["companyCd"],
        contractorCd:
            json["contractorCd"] == null ? null : json["contractorCd"],
        month: json["month"] == null ? 0 : json["month"],
        year: json["year"] == null ? null : json["year"],
        weeks: json["weeks"] == null
            ? null
            : List<Week>.from(json["weeks"].map((x) => Week.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "companyCd": companyCd == null ? null : companyCd,
        "contractorCd": contractorCd == null ? null : contractorCd,
        "month": month == null ? 0 : month,
        "year": year == null ? null : year,
        "weeks": weeks == null
            ? null
            : List<dynamic>.from(weeks.map((x) => x.toJson())),
      };
}

class Week {
  int tractorCount;
  int totalMiles;
  int loadedMiles;
  int emptyMiles;
  int totalLoads;
  int loadedLoads;
  int emptyLoads;
  double totalTractorGallons;
  double totalFuelCost;
  double grossAmt;
  double deductions;
  double netAmt;

  Week({
    this.tractorCount,
    this.totalMiles,
    this.loadedMiles,
    this.emptyMiles,
    this.totalLoads,
    this.loadedLoads,
    this.emptyLoads,
    this.totalTractorGallons,
    this.totalFuelCost,
    this.grossAmt,
    this.deductions,
    this.netAmt,
  });

  factory Week.fromJson(Map<String, dynamic> json) => Week(
        tractorCount: json["tractorCount"] == null ? 0 : json["tractorCount"],
        totalMiles: json["totalMiles"] == null ? 0 : json["totalMiles"],
        loadedMiles: json["loadedMiles"] == null ? 0 : json["loadedMiles"],
        emptyMiles: json["emptyMiles"] == null ? 0 : json["emptyMiles"],
        totalLoads: json["totalLoads"] == null ? 0 : json["totalLoads"],
        loadedLoads: json["loadedLoads"] == null ? 0 : json["loadedLoads"],
        emptyLoads: json["emptyLoads"] == null ? 0 : json["emptyLoads"],
        totalTractorGallons: json["totalTractorGallons"] == null
            ? 0.0
            : json["totalTractorGallons"].toDouble(),
        totalFuelCost: json["totalFuelCost"] == null
            ? 0.0
            : json["totalFuelCost"].toDouble(),
        grossAmt: json["grossAmt"] == null ? 0.0 : json["grossAmt"].toDouble(),
        deductions: json["deductions"] == null ? 0.0 : json["deductions"],
        netAmt: json["netAmt"] == null ? 0.0 : json["netAmt"].toDouble(),
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
        "grossAmt": grossAmt == null ? 0.0 : grossAmt,
        "deductions": deductions == null ? 0.0 : deductions,
        "netAmt": netAmt == null ? 0.0 : netAmt,
      };
}
