class SettlementRequest {
  final int month;
  final int year;

  SettlementRequest(this.month, this.year);

  Map<String, dynamic> toJson() => {
        '"month"': '"$month"',
        '"year"': '"$year"',
      };
}
