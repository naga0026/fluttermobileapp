
class LoginRequest {
  String userId;
  String password;

  LoginRequest({required this.userId, required this.password});

  Map<String, String> toMap() => {
    "userId" : userId,
    "password" : password
  };
}