//This class is used to create request model for revenue
class RevenueRequest {
  final String transactionType;

  final int oid;

  RevenueRequest({this.transactionType, this.oid});

  Map<String, dynamic> toJson() => {
        '"transactionType"': '"$transactionType"',
        '"oid"': '"$oid"',
      };
}
