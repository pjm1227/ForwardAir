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
    map["month"] = month == null ? 0 : month;
    map["year"] =  year == null ? null : year;
    map["tractorCount"] = tractorCount == null ? 0 : tractorCount;
    map["totalMiles"] = totalMiles == null ? 0 : totalMiles;
    map["loadedMiles"] = loadedMiles == null ? 0 : loadedMiles;
    map["emptyMiles"] = emptyMiles == null ? 0 : emptyMiles;
    map["totalLoads"] = totalLoads == null ? 0 : totalLoads;
    map["loadedLoads"] = loadedLoads == null ? 0 : loadedLoads;
    map["emptyLoads"] = emptyLoads == null ? null : emptyLoads;
    map["totalTractorGallons"] = totalTractorGallons == null ? 0.0 : totalTractorGallons;
    map["totalFuelCost"] = totalFuelCost == null ? 0.0 : totalFuelCost;
    map["grossAmt"] = grossAmt == null ? 0.0 : grossAmt;
    map["deductions"] = deductions == null ? 0.0 : deductions;
    map["netAmt"] =  netAmt == null ? 0.0 : netAmt;
    map["dashboardPeriod"] =  dashboardPeriod == null ? null : dashboardPeriod;
    return map;
  }

  Dashboard_DB_Model.fromMapObject(Map<String, dynamic> json) {
    this.id = json['id'] == null ? null : json['id'];
    this.companyCd = json["companyCd"] == null ? null : json["companyCd"];
    this.contractorCd = json["contractorCd"] == null ? null : json["contractorCd"];
    this.weekStart = json["weekStart"] == null ? null : json["weekStart"];
    this.weekEnd = json["weekEnd"] == null ? null : json["weekEnd"];
    this.month = json["month"] == null ? 0 : json["month"];
    this.year = json["year"] == null ? null :json["year"];
    this.tractorCount = json["tractorCount"] == null ? 0 : json["tractorCount"];
    this.totalMiles = json["totalMiles"] == null ? 0 : json["totalMiles"];
    this.loadedMiles = json["loadedMiles"] == null ? 0 : json["loadedMiles"];
    this.emptyMiles = json["emptyMiles"] == null ? 0: json["emptyMiles"];
    this.totalLoads = json["totalLoads"] == null ? 0 : json["totalLoads"];
    this.loadedLoads = json["loadedLoads"] == null ? 0 : json["loadedLoads"];
    this.emptyLoads = json["emptyLoads"] == null ? 0 : json["emptyLoads"];
    this.totalTractorGallons = json["totalTractorGallons"] == null ? 0.0 : json["totalTractorGallons"];
    this.totalFuelCost = json["totalFuelCost"] == null ? 0.0 : json["totalFuelCost"];
    this.grossAmt = json["grossAmt"] == null ? 0.0: json["grossAmt"];
    this.deductions = json["deductions"] == null ? 0.0 : json["deductions"];
    this.netAmt = json["netAmt"] == null ? 0.0 : json["netAmt"];
    this.dashboardPeriod = json["dashboardPeriod"] == null ? null : json["dashboardPeriod"];
  }

}
