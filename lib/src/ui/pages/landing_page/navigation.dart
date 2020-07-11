import 'package:flutter/material.dart';
import 'package:quizlabsmock/src/ui/pages/auth_page/auth_page.dart';
import 'package:quizlabsmock/src/ui/widgets/button_main.dart';
import 'package:quizlabsmock/src/utils/color_utils.dart';
import 'package:quizlabsmock/src/utils/firebase_analytics_utils.dart';
import 'package:quizlabsmock/src/ui/extensions/hover_extension.dart';

import '../../../root_page.dart';

class Navigation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 45, vertical: 38),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(colors: [
                      ColorUtils.BLUE_LIGHT,
                      ColorUtils.BLUE_MAIN,
                    ], begin: Alignment.bottomRight, end: Alignment.centerLeft)),
                child: Center(
                  child: Text("QL",
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Text("QuizLabs", style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 26
              ),)
            ],
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 25, top: 10),
              child: ButtonMain(
                width: 130,
                height: 55,
                colorMain: ColorUtils.BLUE_MAIN,
                colorSec: ColorUtils.BLUE_LIGHT,
                text: "Login",
                textSize: 20,
                onTap: () async {
                  await FirebaseAnalyticsUtils.analytics.logEvent(name: 'landing_page__login_button_clicked');
                  Navigator.pushNamed(context, RootPage.routeName);
                },
              ),
            ),).showCursorOnHover
        ],
      ),
    );
  }
}
