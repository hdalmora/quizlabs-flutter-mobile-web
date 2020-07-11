import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizlabsmock/src/blocs/auth_bloc/auth_bloc_provider.dart';
import 'package:quizlabsmock/src/blocs/trivia_bloc/trivia_bloc_provider.dart';
import 'package:quizlabsmock/src/root_page.dart';
import 'package:quizlabsmock/src/ui/pages/auth_page/auth_page.dart';
import 'package:quizlabsmock/src/ui/pages/home_page/home_page.dart';
import 'package:quizlabsmock/src/ui/pages/settings_page.dart';
import 'package:quizlabsmock/src/ui/pages/trivia_page/trivia_page.dart';
import 'package:quizlabsmock/src/utils/color_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:quizlabsmock/src/utils/firebase_analytics_utils.dart';
import 'blocs/loading_bloc/loading_bloc.dart';
import 'blocs/user_bloc/user_bloc_provider.dart';

class QuizLabs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoadingBloc>(
          create: (BuildContext context) => LoadingBloc(),
        ),
      ],
      child: AuthBlocProvider(
        child: UserBlocProvider(
          child: TriviaBlocProvider(
            child: MaterialApp(
              title: 'Quiz Labs',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              navigatorObservers: <NavigatorObserver>[FirebaseAnalyticsUtils.observer],
              theme: ThemeData(
                primaryColor: ColorUtils.BLUE_MAIN,
                accentColor: ColorUtils.BLUE_ACCENT,
              ),
              initialRoute: RootPage.routeName,
              routes: {
                RootPage.routeName: (context) => RootPage(),
                AuthPage.routeName: (context) => AuthPage(),
                HomePage.routeName: (context) => HomePage(userUUID: null,),
                SettingsPage.routeName: (context) => SettingsPage(),
                TriviaPage.routeName: (context) => TriviaPage(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
