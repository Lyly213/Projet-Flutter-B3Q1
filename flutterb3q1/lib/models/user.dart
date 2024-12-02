class User {
  final String email;

  User({required this.email});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && email == other.email;

  @override
  int get hashCode => email.hashCode;
}
