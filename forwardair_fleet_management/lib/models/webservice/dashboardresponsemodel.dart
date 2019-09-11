// To parse this JSON data, do
//
//     final dashboardResponseModel = dashboardResponseModelFromJson(jsonString);

import 'dart:convert';

List<DashboardResponseModel> dashboardResponseModelFromJson(String str) => List<DashboardResponseModel>.from(json.decode(str).map((x) => DashboardResponseModel.fromJson(x)));

String dashboardResponseModelToJson(List<DashboardResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DashboardResponseModel {
String companyCd;
String contractorCd;
String weekStart;
String weekEnd;
int month;
String year;
int tractorCount;
int totalMiles;
int loadedMiles;
int emptyMiles;
int loadedLoads;
int emptyLoads;
double totalTractorGallons;
double totalFuelCost;
double grossAmt;
double deductions;
double netAmt;
String dashboardPeriod;

DashboardResponseModel({
this.companyCd,
this.contractorCd,
this.weekStart,
this.weekEnd,
this.month,
this.year,
this.tractorCount,
this.totalMiles,
this.loadedMiles,
this.emptyMiles,
this.loadedLoads,
this.emptyLoads,
this.totalTractorGallons,
this.totalFuelCost,
this.grossAmt,
this.deductions,
this.netAmt,
this.dashboardPeriod,
});

factory DashboardResponseModel.fromJson(Map<String, dynamic> json) => DashboardResponseModel(
companyCd: json["companyCd"] == null ? null : json["companyCd"],
contractorCd: json["contractorCd"]  == null ? null : json["contractorCd"],
weekStart: json["weekStart"] == null ? null : json["weekStart"],
weekEnd: json["weekEnd"] == null ? null : json["weekEnd"],
month: json["month"] == null ? null : json["month"],
year: json["year"] == null ? null : json["year"],
tractorCount: json["tractorCount"]  == null ? null : json["tractorCount"],
totalMiles: json["totalMiles"]  == null ? null : json["totalMiles"],
loadedMiles: json["loadedMiles"]  == null ? null : json["loadedMiles"],
emptyMiles: json["emptyMiles"]  == null ? null : json["emptyMiles"],
loadedLoads: json["loadedLoads"] == null ? null : json["loadedLoads"],
emptyLoads: json["emptyLoads"] == null ? null : json["emptyLoads"],
totalTractorGallons:  json["totalTractorGallons"] == null ? null : json["totalTractorGallons"].toDouble(),
totalFuelCost: json["totalFuelCost"] == null ? null : json["totalFuelCost"].toDouble(),
grossAmt: json["grossAmt"] == null ? null : json["grossAmt"].toDouble(),
deductions: json["deductions"] == null ? null : json["deductions"].toDouble(),
netAmt: json["netAmt"] == null ? null : json["netAmt"].toDouble(),
dashboardPeriod: json["dashboardPeriod"] == null ? null : json["dashboardPeriod"],
);

Map<String, dynamic> toJson() => {
"companyCd": companyCd == null ? null :  companyCd,
"contractorCd": contractorCd == null ? null :  contractorCd,
"weekStart": weekStart == null ? null : weekStart,
"weekEnd": weekEnd == null ? null : weekEnd,
"month": month == null ? null : month,
"year": year == null ? null :  year,
"tractorCount": tractorCount == null ? null : tractorCount,
"totalMiles": totalMiles == null ? null : totalMiles,
"loadedMiles": loadedMiles == null ? null : loadedMiles,
"emptyMiles": emptyMiles == null ? null : emptyMiles,
"loadedLoads": loadedLoads == null ? null : loadedLoads,
"emptyLoads": emptyLoads == null ? null : emptyLoads,
"totalTractorGallons": totalTractorGallons == null ? null : totalTractorGallons,
"totalFuelCost": totalFuelCost == null ? null : totalFuelCost,
"grossAmt": grossAmt == null ? null : grossAmt,
"deductions": deductions == null ? null : deductions,
"netAmt": netAmt == null ? null :  netAmt,
"dashboardPeriod": dashboardPeriod == null ? null :  dashboardPeriod,
};
}
