import 'dart:convert';

class Dashboard_DB_Model {
  List<Dashboard_DB_Model> dashboardDBModelFromJson(String str) =>
      List<Dashboard_DB_Model>.from(
          json.decode(str).map((x) => Dashboard_DB_Model.fromMapObject(x)));

  String dashboardDBModelToJson(List<Dashboard_DB_Model> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toMap())));


  int id;
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
  int totalLoads;
  int loadedLoads;
  int emptyLoads;
  double totalTractorGallons;
  double totalFuelCost;
  double grossAmt;
  double deductions;
  double netAmt;
  String dashboardPeriod;

  Dashboard_DB_Model({
    this.companyCd,
    this.contractorCd,
    this.weekStart,
    this.weekEnd,
    this.month,
    this.year,
    this.tractorCount,
    this.totalMiles,
    this.loadedMiles,
    this.totalLoads,
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


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map["companyCd"] = companyCd == null ? null : companyCd;
    map["contractorCd"] = contractorCd == null ? null : contractorCd;
    map["weekStart"] = weekStart == null ? null : weekStart;
    map["weekEnd"] = weekEnd == null ? null : weekEnd;
    map["month"] = month == null ? null : month;
    map["year"] =  year == null ? null : year;
    map["tractorCount"] = tractorCount == null ? null : tractorCount;
    map["totalMiles"] = totalMiles == null ? null : totalMiles;
    map["loadedMiles"] = loadedMiles == null ? null : loadedMiles;
    map["emptyMiles"] = emptyMiles == null ? null : emptyMiles;
    map["totalLoads"] = totalLoads == null ? null : totalLoads;
    map["loadedLoads"] = loadedLoads == null ? null : loadedLoads;
    map["emptyLoads"] = emptyLoads == null ? null : emptyLoads;
    map["totalTractorGallons"] = totalTractorGallons == null ? null : totalTractorGallons;
    map["totalFuelCost"] = totalFuelCost == null ? null : totalFuelCost;
    map["grossAmt"] = grossAmt == null ? null : grossAmt;
    map["deductions"] = deductions == null ? null : deductions;
    map["netAmt"] =  netAmt == null ? null : netAmt;
    map["dashboardPeriod"] =  dashboardPeriod == null ? null : dashboardPeriod;
    return map;
  }

  Dashboard_DB_Model.fromMapObject(Map<String, dynamic> json) {
    this.id = json['id'] == null ? null : json['id'];
    this.companyCd = json["companyCd"] == null ? null : json["companyCd"];
    this.contractorCd = json["contractorCd"] == null ? null : json["contractorCd"];
    this.weekStart = json["weekStart"] == null ? null : json["weekStart"];
    this.weekEnd = json["weekEnd"] == null ? null : json["weekEnd"];
    this.month = json["month"] == null ? null : json["month"];
    this.year = json["year"] == null ? null :json["year"];
    this.tractorCount = json["tractorCount"] == null ? null : json["tractorCount"];
    this.totalMiles = json["totalMiles"] == null ? null : json["totalMiles"];
    this.loadedMiles = json["loadedMiles"] == null ? null : json["loadedMiles"];
    this.emptyMiles = json["emptyMiles"] == null ? null : json["emptyMiles"];
    this.totalLoads = json["totalLoads"] == null ? null : json["totalLoads"];
    this.loadedLoads = json["loadedLoads"] == null ? null : json["loadedLoads"];
    this.emptyLoads = json["emptyLoads"] == null ? null : json["emptyLoads"];
    this.totalTractorGallons = json["totalTractorGallons"] == null ? null : json["totalTractorGallons"];
    this.totalFuelCost = json["totalFuelCost"] == null ? null : json["totalFuelCost"];
    this.grossAmt = json["grossAmt"] == null ? null : json["grossAmt"];
    this.deductions = json["deductions"] == null ? null : json["deductions"];
    this.netAmt = json["netAmt"] == null ? null : json["netAmt"];
    this.dashboardPeriod = json["dashboardPeriod"] == null ? null : json["dashboardPeriod"];
  }

}
