import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qazapp/auth_cubit.dart';
import 'package:qazapp/auth_state.dart';
import 'package:qazapp/auth_view.dart';
import 'package:qazapp/home.dart';
import 'package:qazapp/loading_view.dart';
import 'package:qazapp/todo_cubit.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return Navigator(
        pages: [
          if (state is Unauthneticated) MaterialPage(child: AuthView()),
          if (state is Authenticated)
            MaterialPage(
                child: BlocProvider(
              create: (context) => TodoCubit(userId: state.userId)
                ..getTodos()
                ..observeTodo(),
              child: Home(),
            )),
          if (state is UnknownAuthState) MaterialPage(child: LoadingView())
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
