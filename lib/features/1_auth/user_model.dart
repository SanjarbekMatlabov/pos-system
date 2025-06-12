class User {
  final int? id;
  final String username;
  final String passwordHash; // Parolni ochiq saqlash yomon amaliyot, shuning uchun hash deymiz
  final String role; // 'admin' yoki 'kassir'

  User({
    this.id,
    required this.username,
    required this.passwordHash,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      passwordHash: map['password_hash'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password_hash': passwordHash,
      'role': role,
    };
  }
}