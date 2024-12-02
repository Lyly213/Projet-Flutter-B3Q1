import '../../models/user.dart';

abstract class LoginState {
  const LoginState();
}

class LoggingIn extends LoginState {
  const LoggingIn();
}

class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}

class LoggedIn extends LoginState {
  final User user;

  LoggedIn(this.user);
}

class LoggedOut extends LoginState {
  const LoggedOut();
}
