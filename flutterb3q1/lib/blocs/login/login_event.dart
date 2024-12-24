// these are the events that will be used in the loginBloc

abstract class LoginEvent {}

class SignInEvent extends LoginEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

class SignOutEvent extends LoginEvent {}
