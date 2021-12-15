import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qazapp/amplifyconfiguration.dart';
import 'package:qazapp/app_navigator.dart';
import 'package:qazapp/auth_cubit.dart';
import 'package:qazapp/loading_view.dart';
import 'package:qazapp/models/ModelProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

//TodoCubit()..getTodos()..observeTodo()
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
          create: (context) => AuthCubit()..attemptAutoSignIn(),
          child: _amplifyConfigured ? AppNavigator() : LoadingView()),
    );
  }

  void _configureAmplify() async {
    try {
      await Future.wait([
        Amplify.addPlugin(
            AmplifyDataStore(modelProvider: ModelProvider.instance)),
        Amplify.addPlugin(AmplifyAPI()),
        Amplify.addPlugin(AmplifyAuthCognito())
      ]);
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
      //Amplify.DataStore.clear();
    } catch (e) {
      print(e);
    }
  }
}
