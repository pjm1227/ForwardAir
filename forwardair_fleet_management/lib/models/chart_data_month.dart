// To parse this JSON data, do
//
//     final chartDataMonth = chartDataMonthFromJson(jsonString);

import 'dart:convert';

ChartDataMonth chartDataMonthFromJson(String str) => ChartDataMonth.fromJson(json.decode(str));

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
      contractorCd: json["contractorCd"] == null ? null : json["contractorCd"],
      month: json["month"] == null ? null : json["month"],
      year: json["year"] == null ? null : json["year"],
      weeks: json["weeks"] == null ? null : List<Week>.from(json["weeks"].map((x) => Week.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "companyCd": companyCd == null ? null : companyCd,
    "contractorCd": contractorCd == null ? null : contractorCd,
    "month": month == null ? null : month,
    "year": year == null ? null : year,
    "weeks": weeks == null ? null : List<dynamic>.from(weeks.map((x) => x.toJson())),
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
    tractorCount: json["tractorCount"] == null ? null : json["tractorCount"],
    totalMiles: json["totalMiles"] == null ? null : json["totalMiles"],
    loadedMiles: json["loadedMiles"] == null ? null : json["loadedMiles"],
    emptyMiles: json["emptyMiles"] == null ? null : json["emptyMiles"],
    totalLoads: json["totalLoads"] == null ? null : json["totalLoads"],
    loadedLoads: json["loadedLoads"] == null ? null : json["loadedLoads"],
    emptyLoads: json["emptyLoads"] == null ? null : json["emptyLoads"],
    totalTractorGallons: json["totalTractorGallons"] == null ? null : json["totalTractorGallons"].toDouble(),
    totalFuelCost: json["totalFuelCost"] == null ? null : json["totalFuelCost"].toDouble(),
    grossAmt: json["grossAmt"] == null ? null : json["grossAmt"].toDouble(),
    deductions: json["deductions"] == null ? null : json["deductions"],
    netAmt: json["netAmt"] == null ? null : json["netAmt"].toDouble(),
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
    "grossAmt": grossAmt == null ? null : grossAmt,
    "deductions": deductions == null ? null : deductions,
    "netAmt": netAmt == null ? null : netAmt,
  };
}
