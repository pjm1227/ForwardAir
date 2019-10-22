// To parse this JSON data, do
//
//     final termsModel = termsModelFromJson(jsonString);

class TermsModel {
  int id;
  bool isTermsAccepted;

  TermsModel({
    this.id,
    this.isTermsAccepted,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['columnIsAccepted'] = isTermsAccepted ? 1 : 0;
    return map;
  }

  TermsModel.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    isTermsAccepted = map['columnIsAccepted'] == 1;
  }
}
