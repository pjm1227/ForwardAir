class LoadDetailRequest {
  final String weekStart;
  final String weekEnd;
  final int month;
  final String year;
  final String tractorId;

  LoadDetailRequest(this.weekStart, this.weekEnd,this.month,this.year,this.tractorId);

/*
  LoginRequest.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        password = json['password'];*/

  Map<String, dynamic> toJson() => {
    '"weekStart"': '"$weekStart"',
    '"weekEnd"': '"$weekEnd"',
    '"month"': '"$month"',
    '"year"': '"$year"',
    '"tractorId"': '"$tractorId"',
  };
}