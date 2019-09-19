// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String token;
  UserDetails userDetails;

  LoginModel({
    this.token,
    this.userDetails,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        token: json["token"] == null ? null : json["token"],
        userDetails: json["userDetails"] == null
            ? null
            : UserDetails.fromJson(json["userDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token == null ? null : token,
        "userDetails": userDetails == null ? null : userDetails.toJson(),
      };
}

class UserDetails {
  int id;
  String token;
  String emailAddress;
  String fullName;
  String userId;
  String stationCd;
  String participantId;
  String phone;
  String companyCd;
  String contractorcd;
  String driverid;
  int driveroid;
  int faauthuseroid;
  int xrefoid;
  String faauthuserid;
  String usertype;
  int activetractors;
  bool isUserLoggedIn;
  List<UserGroup> userGroups;

  UserDetails({
    this.id,
    this.token,
    this.emailAddress,
    this.fullName,
    this.userId,
    this.stationCd,
    this.participantId,
    this.phone,
    this.companyCd,
    this.contractorcd,
    this.driverid,
    this.driveroid,
    this.faauthuseroid,
    this.xrefoid,
    this.faauthuserid,
    this.usertype,
    this.activetractors,
    this.isUserLoggedIn,
    this.userGroups,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['token'] = token;
    map['emailAddress'] = emailAddress;
    map['fullName'] = fullName;
    map['userId'] = userId;
    map['stationCd'] = stationCd;
    map['participantId'] = participantId;
    map['phone'] = phone;
    map['companyCd'] = companyCd;
    map['contractorcd'] = contractorcd;
    map['driverid'] = driverid == null ? 0 : driverid;
    map['driveroid'] = driveroid;
    map['faauthuseroid'] = faauthuseroid == null ? 0 : faauthuseroid;
    map['xrefoid'] = xrefoid == null ? 0 : xrefoid;
    map['faauthuserid'] = faauthuserid;
    map['usertype'] = usertype;
    map['activetractors'] = activetractors == null ? 0 : activetractors;
    map['isUserLoggedIn'] = isUserLoggedIn ? 1 : 0;
    return map;
  }

  UserDetails.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    token = map['token'];
    emailAddress = map['emailAddress'];
    fullName = map['fullName'];
    userId = map['userId'];
    stationCd = map['stationCd'];
    participantId = map['participantId'];
    phone = map['phone'];
    companyCd = map['companyCd'];
    contractorcd = map['contractorcd'];
    driverid = map['driverid'];
    driveroid = map['driveroid'];
    faauthuseroid = map['faauthuseroid'];
    xrefoid = map['xrefoid'];
    faauthuserid = map['faauthuserid'];
    usertype = map['usertype'];
    activetractors = map['activetractors'];
    isUserLoggedIn = map['isUserLoggedIn'] == 1;
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        emailAddress:
            json["emailAddress"] == null ? null : json["emailAddress"],
        fullName: json["fullName"] == null ? null : json["fullName"],
        userId: json["userId"] == null ? null : json["userId"],
        stationCd: json["stationCd"] == null ? null : json["stationCd"],
        participantId:
            json["participantId"] == null ? null : json["participantId"],
        phone: json["phone"] == null ? null : json["phone"],
        companyCd: json["companyCd"] == null ? null : json["companyCd"],
        contractorcd:
            json["contractorcd"] == null ? null : json["contractorcd"],
        driverid: json["driverid"],
        driveroid: json["driveroid"],
        faauthuseroid:
            json["faauthuseroid"] == null ? null : json["faauthuseroid"],
        xrefoid: json["xrefoid"] == null ? null : json["xrefoid"],
        faauthuserid:
            json["faauthuserid"] == null ? null : json["faauthuserid"],
        usertype: json["usertype"] == null ? null : json["usertype"],
        activetractors:
            json["activetractors"] == null ? null : json["activetractors"],
        userGroups: json["userGroups"] == null
            ? null
            : List<UserGroup>.from(
                json["userGroups"].map((x) => UserGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "emailAddress": emailAddress == null ? null : emailAddress,
        "fullName": fullName == null ? null : fullName,
        "userId": userId == null ? null : userId,
        "stationCd": stationCd == null ? null : stationCd,
        "participantId": participantId == null ? null : participantId,
        "phone": phone == null ? null : phone,
        "companyCd": companyCd == null ? null : companyCd,
        "contractorcd": contractorcd == null ? null : contractorcd,
        "driverid": driverid,
        "driveroid": driveroid,
        "faauthuseroid": faauthuseroid == null ? null : faauthuseroid,
        "xrefoid": xrefoid == null ? null : xrefoid,
        "faauthuserid": faauthuserid == null ? null : faauthuserid,
        "usertype": usertype == null ? null : usertype,
        "activetractors": activetractors == null ? null : activetractors,
        "userGroups": userGroups == null
            ? null
            : List<dynamic>.from(userGroups.map((x) => x.toJson())),
      };
}

class UserGroup {
  String groupNm;
  String description;
  List<UserRole> userRoles;

  UserGroup({
    this.groupNm,
    this.description,
    this.userRoles,
  });

  factory UserGroup.fromJson(Map<String, dynamic> json) => UserGroup(
        groupNm: json["groupNm"] == null ? null : json["groupNm"],
        description: json["description"] == null ? null : json["description"],
        userRoles: json["userRoles"] == null
            ? null
            : List<UserRole>.from(
                json["userRoles"].map((x) => UserRole.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "groupNm": groupNm == null ? null : groupNm,
        "description": description == null ? null : description,
        "userRoles": userRoles == null
            ? null
            : List<dynamic>.from(userRoles.map((x) => x.toJson())),
      };
}

class UserRole {
  String roleNm;

  UserRole({
    this.roleNm,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) => UserRole(
        roleNm: json["roleNm"] == null ? null : json["roleNm"],
      );

  Map<String, dynamic> toJson() => {
        "roleNm": roleNm == null ? null : roleNm,
      };
}
