class LoadRequest {
  final String weekStart;
  final String weekEnd;
  final int month;
  final int year;
  final String tractorId;

  LoadRequest({this.weekStart, this.weekEnd,this.month,this.year,this.tractorId});
  
  Map<String, dynamic> toJson() => {
    '"weekStart"': '"$weekStart"',
    '"weekEnd"': '"$weekEnd"',
    '"month"': '"$month"',
    '"year"': '"$year"',
    '"tractorId"': '"$tractorId"',
  };
}