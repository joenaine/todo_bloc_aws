import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qazapp/auth_cubit.dart';

class AuthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () => BlocProvider.of<AuthCubit>(context).signIn(),
            child: Text('Sign In')),
      ),
    );
  }
}
