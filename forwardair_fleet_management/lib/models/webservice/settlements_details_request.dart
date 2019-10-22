class SettlementsDetailsRequest {
  final String weekStart;
  final String weekEnd;
  final int month;
  final int year;
  final String tractorId;
  final String checkNbr;

  SettlementsDetailsRequest({this.weekStart, this.weekEnd,this.month,this.year,this.tractorId,this.checkNbr});

  Map<String, dynamic> toJson() => {
    '"weekStart"': '"$weekStart"',
    '"weekEnd"': '"$weekEnd"',
    '"month"': '"$month"',
    '"year"': '"$year"',
    '"tractorId"': '"$tractorId"',
    '"checkNbr"': '"$checkNbr"',
  };
}