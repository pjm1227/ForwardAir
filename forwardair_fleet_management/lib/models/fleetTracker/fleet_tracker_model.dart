import 'dart:convert';

FleetTrackerModel fleetFromJson(String str) =>
    FleetTrackerModel.fromJson(json.decode(str));

String fleetToJson(FleetTrackerModel data) => json.encode(data.toJson());

class FleetTrackerModel {
  String companyCd;
  String contractorCd;

  List<CurrentPositions> currentPositions;

  FleetTrackerModel({
    this.companyCd,
    this.contractorCd,
    this.currentPositions,
  });

  factory FleetTrackerModel.fromJson(Map<String, dynamic> json) =>
      FleetTrackerModel(
        companyCd: json["companyCd"] == null ? null : json["companyCd"],
        contractorCd:
            json["contractorCd"] == null ? null : json["contractorCd"],
        currentPositions: json["currentPositions"] == null
            ? null
            : List<CurrentPositions>.from(json["currentPositions"]
                .map((x) => CurrentPositions.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "companyCd": companyCd == null ? null : companyCd,
        "contractorCd": contractorCd == null ? null : contractorCd,
        "currentPositions": currentPositions == null
            ? null
            : List<dynamic>.from(currentPositions.map((x) => x.toJson())),
      };
}

class CurrentPositions {
  String milesFromLocation;
  String direction;
  String placeName;
  String ignitionOnOff;
  String trip;
  String latitude;
  String longitude;
  String phone;
  String order;
  String origin;
  String dest;
  String orderStatus;
  String nextOrigin;
  String nextDestination;
  String nextOrder;
  String unitNbr;
  String tractorId;
  String positionDt;
  String ptaDt;
  String etaDt;
  String nextOrderScheduledDepartDt;
  String Driver1NextTimeOffBeginDt;
  String Driver1NexTimeOffEndDt;
  String Driver2NextTimeOffBeginDt;
  String Driver2NextTimeOffEndDt;
  String currentOrder;
  String driverName;
  String driverClass;

  CurrentPositions({
    this.milesFromLocation,
    this.direction,
    this.placeName,
    this.ignitionOnOff,
    this.trip,
    this.latitude,
    this.longitude,
    this.phone,
    this.order,
    this.origin,
    this.dest,
    this.orderStatus,
    this.nextOrigin,
    this.nextDestination,
    this.nextOrder,
    this.unitNbr,
    this.tractorId,
    this.positionDt,
    this.ptaDt,
    this.etaDt,
    this.nextOrderScheduledDepartDt,
    this.Driver1NextTimeOffBeginDt,
    this.Driver1NexTimeOffEndDt,
    this.Driver2NextTimeOffBeginDt,
    this.Driver2NextTimeOffEndDt,
    this.currentOrder,
    this.driverName,
    this.driverClass,
  });

  factory CurrentPositions.fromJson(Map<String, dynamic> json) =>
      CurrentPositions(
        milesFromLocation: json["milesFromLocation"] == null
            ? null
            : json["milesFromLocation"],
        direction: json["direction"] == null ? null : json["direction"],
        placeName: json["placeName"] == null ? null : json["placeName"],
        ignitionOnOff:
            json["ignitionOnOff"] == null ? null : json["ignitionOnOff"],
        trip: json["trip"] == null ? null : json["latitude"],
        latitude: json["latitude"] == null ? null : json["placeName"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        phone: json["phone"] == null ? null : json["phone"],
        order: json["order"] == null ? null : json["order"],
        origin: json["origin"] == null ? null : json["origin"],
        dest: json["dest"] == null ? null : json["dest"],
        orderStatus: json["orderStatus"] == null ? null : json["orderStatus"],
        nextOrigin: json["nextOrigin"] == null ? null : json["nextOrigin"],
        nextDestination:
            json["nextDestination"] == null ? null : json["nextDestination"],
        nextOrder: json["nextOrder"] == null ? null : json["nextOrder"],
        unitNbr: json["unitNbr"] == null ? null : json["unitNbr"],
        tractorId: json["tractorId"] == null ? null : json["tractorId"],
        positionDt: json["positionDt"] == null ? null : json["positionDt"],
        ptaDt: json["ptaDt"] == null ? null : json["ptaDt"],
        etaDt: json["etaDt"] == null ? null : json["etaDt"],
        nextOrderScheduledDepartDt: json["nextOrderScheduledDepartDt"] == null
            ? null
            : json["nextOrderScheduledDepartDt"],
        Driver1NextTimeOffBeginDt: json["Driver1NextTimeOffBeginDt"] == null
            ? null
            : json["Driver1NextTimeOffBeginDt"],
        Driver1NexTimeOffEndDt: json["Driver1NexTimeOffEndDt"] == null
            ? null
            : json["Driver1NexTimeOffEndDt"],
        Driver2NextTimeOffBeginDt: json["Driver2NextTimeOffBeginDt"] == null
            ? null
            : json["Driver2NextTimeOffBeginDt"],
        Driver2NextTimeOffEndDt: json["Driver2NextTimeOffEndDt"] == null
            ? null
            : json["Driver2NextTimeOffEndDt"],
        currentOrder:
            json["currentOrder"] == null ? null : json["currentOrder"],
        driverName: json["driverName"] == null ? null : json["driverName"],
        driverClass: json["driverClass"] == null ? null : json["driverClass"],
      );

  Map<String, dynamic> toJson() => {
        "milesFromLocation":
            milesFromLocation == null ? null : milesFromLocation,
        'direction': direction == null ? null : direction,
        "placeName": placeName == null ? null : placeName,
        "ignitionOnOff": ignitionOnOff == null ? null : ignitionOnOff,
        "trip": trip == null ? null : trip,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "phone": phone == null ? null : phone,
        "order": order == null ? null : order,
        "origin": origin == null ? null : origin,
        "dest": dest == null ? null : dest,
        "orderStatus": orderStatus == null ? null : orderStatus,
        "nextOrigin": nextOrigin == null ? null : nextOrigin,
        "nextDestination": nextDestination == null ? null : nextDestination,
        "nextOrder": nextOrder == null ? null : nextOrder,
        "unitNbr": unitNbr == null ? null : unitNbr,
        "tractorId": tractorId == null ? null : tractorId,
        "positionDt": positionDt == null ? null : positionDt,
        "ptaDt": ptaDt == null ? null : ptaDt,
        "etaDt": etaDt == null ? null : etaDt,
        "nextOrderScheduledDepartDt": nextOrderScheduledDepartDt == null
            ? null
            : nextOrderScheduledDepartDt,
        "Driver1NextTimeOffBeginDt": Driver1NextTimeOffBeginDt == null
            ? null
            : Driver1NextTimeOffBeginDt,
        "Driver1NexTimeOffEndDt":
            Driver1NexTimeOffEndDt == null ? null : Driver1NexTimeOffEndDt,
        "Driver2NextTimeOffBeginDt": Driver2NextTimeOffBeginDt == null
            ? null
            : Driver2NextTimeOffBeginDt,
        "Driver2NextTimeOffEndDt":
            Driver2NextTimeOffEndDt == null ? null : Driver2NextTimeOffEndDt,
        "currentOrder": currentOrder == null ? null : currentOrder,
        "driverName": driverName == null ? null : driverName,
        "driverClass": driverClass == null ? null : driverClass,
      };
}
