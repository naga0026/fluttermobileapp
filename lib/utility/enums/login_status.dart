enum LoginStatus {
  unknown('Unknown'),
  success('Success'),
  accessLocked('Access Locked'),
  passwordIncorrect('Password Incorrect'),
  passwordExpired('Password Expired');

  final String rawValue;
  const LoginStatus(this.rawValue);
}

enum LoginStatusInt {
  unknown(0),
  success(1),
  accessLocked(2),
  passwordIncorrect(3),
  passwordExpired(4);

  final int rawValue;
  const LoginStatusInt(this.rawValue);
}
