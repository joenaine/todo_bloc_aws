import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qazapp/auth_repository.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final authRepo = AuthRepository();

  AuthCubit() : super(UnknownAuthState());

  void signIn() async {
    try {
      final userId = await authRepo.webSignIn();
      if (userId != null && userId.isNotEmpty) {
        emit(Authenticated(userId: userId));
      } else {
        emit(Unauthneticated());
      }
    } on Exception {
      emit(Unauthneticated());
    }
  }

  void signOut() async {
    try {
      await authRepo.signOut();
      emit(Unauthneticated());
    } on Exception {
      emit(Unauthneticated());
    }
  }

  void attemptAutoSignIn() async {
    try {
      final userId = await authRepo.attemptAutoSignIn();
      if (userId != null && userId.isNotEmpty) {
        emit(Authenticated());
      } else {
        emit(Unauthneticated());
      }
    } on Exception {
      emit(Unauthneticated());
    }
  }
}
