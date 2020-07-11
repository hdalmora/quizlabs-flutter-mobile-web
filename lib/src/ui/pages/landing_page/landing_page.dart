import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:quizlabsmock/src/ui/pages/auth_page/auth_page.dart';
import 'package:quizlabsmock/src/ui/widgets/button_main.dart';
import 'package:quizlabsmock/src/ui/widgets/responsive_layout.dart';
import 'package:quizlabsmock/src/utils/color_utils.dart';
import 'package:quizlabsmock/src/utils/firebase_analytics_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../root_page.dart';
import 'navigation.dart';

class LandingPage extends StatefulWidget {
  static const String routeName = 'landing_page';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Navigation(),
            Body()
          ],
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      largeScreen: LargeChild(),
      smallScreen: SmallChild(),
    );
  }
}

class LargeChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.centerRight,
            widthFactor: .6,
            child: Image.asset("images/phone_img.jpg", scale: 2),
          ),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: .6,
            child: Padding(
              padding: EdgeInsets.only(left: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Heey, Quizzer!",
                      style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8591B0))),
                  RichText(
                    text: TextSpan(
                        text: "Welcome To ",
                        style:
                        TextStyle(fontSize: 60, color: Color(0xFF8591B0)),
                        children: [
                          TextSpan(
                              text: "QuizLabs",
                              style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: ColorUtils.BLUE_MAIN))
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 20),
                    child: Text("- Play simple Trivia game Quizzes and have LOTS of fun!", style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: ColorUtils.GRAY_TEXT_LIGHT,
                        fontWeight: FontWeight.bold,
                        fontSize: 26
                    ),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 20),
                    child: Text("- Climb the Ranks to show you are the best Quizzer!", style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: ColorUtils.GRAY_TEXT_LIGHT,
                        fontWeight: FontWeight.bold,
                        fontSize: 26
                    ),),
                  ),
                  SizedBox(
                    height: 40,
                  ),

                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: ButtonMain(
                        width: 230,
                        height: 65,
                        colorMain: ColorUtils.GREEN_MAIN,
                        colorSec: ColorUtils.GREEN_LIGHT,
                        text: "Play Now!",
                        icon: MaterialCommunityIcons.gamepad_variant,
                        textSize: 23,
                        onTap: () async {
                          await FirebaseAnalyticsUtils.analytics.logEvent(name: 'landing_page__play_now_button_clicked');
                          await Navigator.pushNamed(context, RootPage.routeName);
                        },
                      ),
                    ),),

                  SizedBox(
                    height: 30,
                  ),

                  GestureDetector(
                    onTap: () async {
                      const url = 'https://play.google.com/store/apps/details?id=com.henriquedalmora.quizlabsmock';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Image.asset("images/google_play_badge.png", scale: 1, height: 75),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SmallChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Heey, Quizzer!",
              style: TextStyle(
                  fontSize: 40,
                  color: Color(0xFF8591B0),
                  fontWeight: FontWeight.bold,),
            ),
            RichText(
              text: TextSpan(
                text: 'Welcome To ',
                style: TextStyle(fontSize: 40, color: Color(0xFF8591B0)),
                children: <TextSpan>[
                  TextSpan(
                      text: 'QuizLabs',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: ColorUtils.BLUE_MAIN)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0, top: 20),
              child: Text("- Play simple Trivia game Quizzes and have LOTS of fun!", style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: ColorUtils.GRAY_TEXT_LIGHT,
                  fontWeight: FontWeight.bold,
                  fontSize: 22
              )),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 0.0, top: 20),
              child: Text("- Climb the Ranks to show you are the best Quizzer!", style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: ColorUtils.GRAY_TEXT_LIGHT,
                  fontWeight: FontWeight.bold,
                  fontSize: 22
              ),),
            ),

            SizedBox(
              height: 30,
            ),

            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 5),
                child: ButtonMain(
                  width: 180,
                  height: 55,
                  colorMain: ColorUtils.GREEN_MAIN,
                  colorSec: ColorUtils.GREEN_LIGHT,
                  text: "Play Now!",
                  icon: MaterialCommunityIcons.gamepad_variant,
                  textSize: 18,
                  onTap: () async {
                    await FirebaseAnalyticsUtils.analytics.logEvent(name: 'landing_page__play_now_button_clicked');
                    await Navigator.pushNamed(context, RootPage.routeName);
                  },
                ),
              ),),

            SizedBox(
              height: 30,
            ),

            GestureDetector(
              onTap: () async {
                const url = 'https://play.google.com/store/apps/details?id=com.henriquedalmora.quizlabsmock';
                if (await canLaunch(url)) {
                await launch(url);
                } else {
                throw 'Could not launch $url';
                }
              },
              child: Image.asset("images/google_play_badge.png", scale: 1, height: 75),
            ),
          ],
        ),
      ),
    );
  }
}

