class AuthResponse {
  final AuthUser? user;
  final String? token;
  final String? tokenType;

  AuthResponse({
    this.user,
    this.token,
    this.tokenType,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: json['user'] is Map<String, dynamic>
          ? AuthUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      token: json['token'] as String?,
      tokenType: json['token_type'] as String?,
    );
  }
}

class AuthUser {
  final int? id;
  final String? name;
  final String? email;
  final String? role;

  AuthUser({
    this.id,
    this.name,
    this.email,
    this.role,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
    );
  }
}
