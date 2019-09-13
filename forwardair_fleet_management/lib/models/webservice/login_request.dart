class LoginRequest {
  final String userName;
  final String password;

  LoginRequest(this.userName, this.password);

/*
  LoginRequest.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        password = json['password'];*/

  Map<String, dynamic> toJson() => {
        '"userName"': '"$userName"',
        '"password"': '"$password"',
      };
}
