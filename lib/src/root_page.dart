import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlabsmock/src/resources/repository.dart';
import 'package:quizlabsmock/src/ui/pages/auth_page/auth_page.dart';
import 'package:quizlabsmock/src/ui/pages/home_page/home_page.dart';

import 'blocs/loading_bloc/loading_bloc.dart';

class RootPage extends StatefulWidget {
  static const String routeName = 'root_page';

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final Repository _repository = Repository();
  Stream<FirebaseUser> _currentUser;

  @override
  void initState() {
    _currentUser = _repository.onAuthStateChange;
//    _repository.signOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoadingBloc, LoadingState>(
      listener: (context, state) {
        if (state is Loading) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator());
            },
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: StreamBuilder<FirebaseUser>(
        stream: _currentUser,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          return snapshot.hasData ? HomePage(userUUID: snapshot.data != null ? snapshot.data.uid : null,) : AuthPage();
        },
      ),
    );
  }
}