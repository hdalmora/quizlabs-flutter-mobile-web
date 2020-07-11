import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:quizlabsmock/src/models/user.dart';
import 'package:quizlabsmock/src/utils/color_utils.dart';
import 'package:quizlabsmock/src/utils/constants.dart';

class StatisticsTab extends StatelessWidget {

  final User user;

  StatisticsTab({
    @required this.user
  });

  List<double> getPastTenDaysWithPoints() {
    var dateFormat = DateFormat("yy-MM-dd");
    DateTime today = DateTime.now();
//    String todayDateFormatted = newFormat.format(currDt);

    String todayFormatted = dateFormat.format(today);
    String todayMinusOneFormatted = dateFormat.format(today.subtract(Duration(days: 1)));
    String todayMinusTwoFormatted = dateFormat.format(today.subtract(Duration(days: 2)));
    String todayMinusThreeFormatted = dateFormat.format(today.subtract(Duration(days: 3)));
    String todayMinusFourFormatted = dateFormat.format(today.subtract(Duration(days: 4)));
    String todayMinusFiveFormatted = dateFormat.format(today.subtract(Duration(days: 5)));
    String todayMinusSixFormatted = dateFormat.format(today.subtract(Duration(days: 6)));
    String todayMinusSevenFormatted = dateFormat.format(today.subtract(Duration(days: 7)));
    String todayMinusEightFormatted = dateFormat.format(today.subtract(Duration(days: 8)));
    String todayMinusNineFormatted = dateFormat.format(today.subtract(Duration(days: 9)));

    Map<String, dynamic> pointsByDay = user.pointsByDayGraph;

    if(pointsByDay == null || pointsByDay.isEmpty)
      return null;

    List<double> data = [
      pointsByDay[todayMinusNineFormatted] != null ?
        pointsByDay[todayMinusNineFormatted].toDouble() : 0.0,
      pointsByDay[todayMinusEightFormatted] != null ?
        pointsByDay[todayMinusEightFormatted].toDouble() : 0.0,
      pointsByDay[todayMinusSevenFormatted] != null ?
        pointsByDay[todayMinusSevenFormatted].toDouble() : 0.0,
      pointsByDay[todayMinusSixFormatted] != null ?
        pointsByDay[todayMinusSixFormatted].toDouble() : 0.0,
      pointsByDay[todayMinusFiveFormatted] != null ?
        pointsByDay[todayMinusFiveFormatted].toDouble() : 0.0,
      pointsByDay[todayMinusFourFormatted] != null ?
        pointsByDay[todayMinusFourFormatted].toDouble() : 0.0,
      pointsByDay[todayMinusThreeFormatted] != null ?
        pointsByDay[todayMinusThreeFormatted].toDouble() : 0.0,
      pointsByDay[todayMinusTwoFormatted] != null ?
        pointsByDay[todayMinusTwoFormatted].toDouble() : 0.0,
      pointsByDay[todayMinusOneFormatted] != null ?
        pointsByDay[todayMinusOneFormatted].toDouble() : 0.0,
      pointsByDay[todayFormatted] != null ?
        pointsByDay[todayFormatted].toDouble() : 0,
    ];

    return data;
  }

  @override
  Widget build(BuildContext context) {
    var data = getPastTenDaysWithPoints();

    return Stack(
      children: <Widget>[

        Positioned(
          top: Constants.mediaHeight(context)*.01,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Statistics",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: ColorUtils.GRAY_TEXT_LIGHT,
                  fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            ),
          ),
        ),

        Positioned(
          top: Constants.mediaHeight(context)*.1,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Points earned in each day",
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: ColorUtils.GRAY_TEXT_LIGHT,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),
                ),
                SizedBox(height: Constants.mediaHeight(context)*.01,),
                Text(
                  "(past 10 days)",
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: ColorUtils.GRAY_TEXT_LIGHT,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                  ),
                ),


                SizedBox(height: Constants.mediaHeight(context)*.03,),
                data != null ? Container(
                  width: Constants.mediaWidth(context)*.8,
                  height: Constants.mediaHeight(context)*.2,
                  child: Sparkline(
//                    pointsMode: PointsMode.all,
                    data: data,
                    lineWidth: 8.0,
                    lineGradient: new LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [ColorUtils.BLUE_MAIN, ColorUtils.BLUE_LIGHT],
                    ),
                  ),
                ) : Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "(No data to show) ...",
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: ColorUtils.GRAY_TEXT_LIGHT,
                            fontWeight: FontWeight.bold,
                            fontSize: 13
                        ),
                      ),

                      SizedBox(height: Constants.mediaHeight(context)*.035,),
                      Text(
                        "Start by playing a Trivia game ;D",
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: ColorUtils.GRAY_TEXT_LIGHT,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
