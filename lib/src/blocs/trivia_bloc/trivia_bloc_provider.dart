import 'package:flutter/material.dart';

import 'trivia_bloc.dart';

class TriviaBlocProvider extends InheritedWidget {
  final bloc = TriviaBloc();

  TriviaBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static TriviaBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<TriviaBlocProvider>()).bloc;
  }
}
