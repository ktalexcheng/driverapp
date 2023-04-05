class Token {
  Token({required this.tokenString});

  final String tokenString;

  Token.fromJson(Map<String, dynamic> json) : tokenString = json['token'];
}
