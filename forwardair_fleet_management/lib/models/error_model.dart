// To parse this JSON data, do
//
//     final errorModel = errorModelFromJson(jsonString);

import 'dart:convert';

ErrorModel errorModelFromJson(String str) => ErrorModel.fromJson(json.decode(str));

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
  String errorMessage;

  ErrorModel({
    this.errorMessage,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
    errorMessage: json["errorMessage"],
  );

  Map<String, dynamic> toJson() => {
    "errorMessage": errorMessage,
  };
}
