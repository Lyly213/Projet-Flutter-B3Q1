class AppUser {
  final String email;

  AppUser({required this.email});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser && runtimeType == other.runtimeType && email == other.email;

  @override
  int get hashCode => email.hashCode;
}
