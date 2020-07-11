import 'package:flutter/material.dart';
import 'package:quizlabsmock/src/blocs/user_bloc/user_bloc.dart';
import 'package:quizlabsmock/src/blocs/user_bloc/user_bloc_provider.dart';
import 'package:quizlabsmock/src/ui/widgets/app_bar.dart';
import 'package:quizlabsmock/src/ui/widgets/button_main.dart';
import 'package:quizlabsmock/src/utils/color_utils.dart';
import 'package:quizlabsmock/src/utils/constants.dart';
import 'package:quizlabsmock/src/utils/firebase_analytics_utils.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsPage> {
  bool toggleValue = false;

  UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    _userBloc = UserBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomAppBar(title: 'Settings',),

            SizedBox(height: Constants.mediaHeight(context)*.065,),

            ListTile(
              title: Text('About QuizLabs',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: ColorUtils.GRAY_TEXT_LIGHT,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),

              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                await FirebaseAnalyticsUtils.analytics.logEvent(name: 'settings_page__about_button_clicked');

                showAboutDialog(
                    context: context,
                    applicationIcon: Image.asset('assets/images/logo.png', height: 25,),
                    applicationVersion: "1.0.0",
                    children: [
                      Text('Thank you for downloading QuizLabs!',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: ColorUtils.GRAY_TEXT_LIGHT,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),

                      SizedBox(height: 10,),
                      Text('This is the first version of the app, and we plan to expand our features even more! Your feedback can really help us :D',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: ColorUtils.GRAY_TEXT_LIGHT,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),

                      SizedBox(height: 10,),
                      Text('Currently we are using the Open Trivia DB to generate our questions. So we leave here a special thanks for them!',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: ColorUtils.GRAY_TEXT_LIGHT,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ]
                );
              },
            ),

            ListTile(
              title: Text('Feature Suggestion :-D !!',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: ColorUtils.GREEN_MAIN,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 20),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                await FirebaseAnalyticsUtils.analytics.logEvent(name: 'settings_page__feature_suggestion_button_clicked');
              },
            ),

            Expanded(
              child: Container(
                height: 15,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(
                    horizontal: Constants.mediaWidth(context) * 0.073,
                    vertical: Constants.mediaHeight(context) * 0.053),
                child: ButtonMain(
                  width: Constants.mediaWidth(context)*.7,
                  height: 50,
                  colorMain: ColorUtils.RED_DARK,
                  colorSec: ColorUtils.RED_LIGHT,
                  text: "Log Out",
                  onTap: () async {
                    await FirebaseAnalyticsUtils.analytics.logEvent(name: 'settings_page__logout_button_clicked');

                    _userBloc.signOut();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
