//this event is used to manage user sign up operations
abstract class SignUpEvent {}

class SignUpRequested extends SignUpEvent {
  final String email;
  final String password;

  SignUpRequested({required this.email, required this.password});
}
