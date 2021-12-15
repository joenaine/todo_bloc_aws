abstract class AuthState {}

class UnknownAuthState extends AuthState {}

class Authenticated extends AuthState {
  final String userId;

  Authenticated({this.userId});
}

class Unauthneticated extends AuthState {}
