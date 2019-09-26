// To parse this JSON data, do
//
//     final chartDatMonth = chartDatMonthFromJson(jsonString);

import 'dart:convert';

ChartDataMonth chartDatMonthFromJson(String str) =>
    ChartDataMonth.fromJson(json.decode(str));

String chartDatMonthToJson(ChartDataMonth data) => json.encode(data.toJson());

class ChartDataMonth {
  String companyCd;
  String contractorCd;
  int month;
  String year;
  List<Map<String, double>> weeks;

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
        month: json["month"] == null ? null : json["month"],
        year: json["year"] == null ? null : json["year"],
        weeks: json["weeks"] == null
            ? null
            : List<Map<String, double>>.from(json["weeks"].map((x) =>
                Map.from(x)
                    .map((k, v) => MapEntry<String, double>(k, v.toDouble())))),
      );

  Map<String, dynamic> toJson() => {
        "companyCd": companyCd == null ? null : companyCd,
        "contractorCd": contractorCd == null ? null : contractorCd,
        "month": month == null ? null : month,
        "year": year == null ? null : year,
        "weeks": weeks == null
            ? null
            : List<dynamic>.from(weeks.map((x) =>
                Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
      };
}
