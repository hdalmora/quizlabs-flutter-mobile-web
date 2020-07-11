import 'package:flutter/material.dart';
import 'package:quizlabsmock/src/utils/color_utils.dart';
import 'package:quizlabsmock/src/utils/constants.dart';
import 'package:quizlabsmock/src/utils/firebase_analytics_utils.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final IconData backActionIcon;

  const CustomAppBar({Key key, this.title, this.backActionIcon}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.center,
      height: Constants.mediaHeight(context)*.1,
      width: Constants.mediaWidth(context),
      decoration: new BoxDecoration(color: Colors.white, boxShadow: [
        new BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 10.0,
            offset: Offset(0, 5)),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          GestureDetector(
            onTap: () async {
              await FirebaseAnalyticsUtils.analytics.logEvent(name: 'close_page_clicked');

              Navigator.of(context).pop();
            },
            child: Icon(
              backActionIcon ?? Icons.arrow_back_ios,
              size: 25,
              color: ColorUtils.GRAY_TEXT_LIGHT,
            ),
          ),

          SizedBox(width: Constants.mediaWidth(context)*.065,),

          Text(
            title,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: ColorUtils.GRAY_TEXT_LIGHT,
                fontWeight: FontWeight.normal,
                fontSize: 20
            ),
          ),
        ],
      ),
    );
  }
}
