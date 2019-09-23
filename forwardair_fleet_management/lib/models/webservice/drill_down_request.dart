class DrillDownRequest {
  final String weekStart;
  final String weekEnd;
  final int month;
  final String year;

  DrillDownRequest(this.weekStart, this.weekEnd,this.month,this.year);

/*
  LoginRequest.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        password = json['password'];*/

  Map<String, dynamic> toJson() => {
    '"weekStart"': '"$weekStart"',
    '"weekEnd"': '"$weekEnd"',
    '"month"': '"$month"',
    '"year"': '"$year"',
  };
}