class User {
  final int? id;
  final String name;
  final String email;
  final DateTime createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  String toString() =>
      'User(id: $id, name: $name, email: $email, createdAt: ${createdAt.toIso8601String()})';
}
