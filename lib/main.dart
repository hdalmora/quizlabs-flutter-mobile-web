import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quizlabsmock/src/app.dart';
import 'package:quizlabsmock/src/utils/firebase_analytics_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAnalyticsUtils.init();

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('pt', 'BR')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: QuizLabs()
    ),
  );
}