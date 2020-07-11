import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:quizlabsmock/src/blocs/loading_bloc/loading_bloc.dart';
import 'package:quizlabsmock/src/blocs/user_bloc/user_bloc.dart';
import 'package:quizlabsmock/src/blocs/user_bloc/user_bloc_provider.dart';
import 'package:quizlabsmock/src/models/user.dart';
import 'package:quizlabsmock/src/ui/pages/home_page/ranking/ranking_tab.dart';
import 'package:quizlabsmock/src/ui/pages/home_page/statistics/statistics_tab.dart';
import 'package:quizlabsmock/src/ui/pages/landing_page/landing_page.dart';
import 'package:quizlabsmock/src/ui/pages/trivia_page/trivia_page.dart';
import 'package:quizlabsmock/src/ui/widgets/button_main.dart';
import 'package:quizlabsmock/src/ui/widgets/form_field_main.dart';
import 'package:quizlabsmock/src/utils/color_utils.dart';
import 'package:quizlabsmock/src/utils/constants.dart';
import 'package:quizlabsmock/src/utils/firebase_analytics_utils.dart';

import '../settings_page.dart';

class HomePage extends StatefulWidget {

  final String userUUID;

  const HomePage({Key key, @required this.userUUID}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(userUUID: userUUID);
}

class _HomePageState extends State<HomePage> {

  String userUUID;

  _HomePageState({
   @required this.userUUID
  });

  final PageController _pageController = PageController(
      initialPage: 0
  );

  UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    _userBloc = UserBlocProvider.of(context);
    _userBloc.changePageSelected(0);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _userBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    BlocProvider.of<LoadingBloc>(context).first.then((state) {
      if(state is Loading) {
        BlocProvider.of<LoadingBloc>(context).add(EndLoad());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: userUUID != null ? StreamBuilder(
            stream: _userBloc.userDoc(userUUID),
            builder: (context, AsyncSnapshot<DocumentSnapshot> currentUser) {

              if(!currentUser.hasData || currentUser.data == null || currentUser.connectionState == ConnectionState.waiting) {
                return Container();
              }

              if(currentUser.data.exists && currentUser.data['username'] != null) {
                User user = User.fromDocument(currentUser.data);

                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: Constants.mediaHeight(context)*.015,
                      child: Container(
                        child: _userStatusUpperBar(user),
                      ),
                    ),


                    Positioned.fill(
                      top: Constants.mediaHeight(context)*.12,
                      child: Container(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (page) {
                            _userBloc.changePageSelected(page);
                          },
                          children: <Widget>[
                            StatisticsTab(user: user,),
                            RankingTab(),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black26,
                                offset: new Offset(0, 1),
                                blurRadius: 5,
                                spreadRadius: .5,
                              )
                            ]
                        ),
                        padding: EdgeInsets.only(bottom: 8, top: 8, left: 5, right: 5),
                        width: Constants.mediaWidth(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[

                            GestureDetector(
                              onTap: () async {
                                await FirebaseAnalyticsUtils.analytics.logEvent(name: 'home_page__statistics_tab_clicked');

                                _pageController.jumpToPage(0);
                                _userBloc.changePageSelected(0);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 4),
                                child: StreamBuilder(
                                  stream: _userBloc.pageSelected,
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData) {
                                      return Icon(
                                        AntDesign.linechart,
                                        size: 30,
                                        color: snapshot.data == 0 ? ColorUtils.BLUE_ACCENT : ColorUtils.GRAY_TEXT_LIGHT,
                                      );
                                    }
                                    return Container();
                                  },
                                ),


                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 25, right: 25),
                            ),

                            GestureDetector(
                              onTap: () async {
                                await FirebaseAnalyticsUtils.analytics.logEvent(name: 'home_page__ranking_tab_clicked');

                                _pageController.jumpToPage(1);
                                _userBloc.changePageSelected(1);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 0),
                                child: StreamBuilder(
                                  stream: _userBloc.pageSelected,
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData) {
                                      return Icon(
                                        Entypo.trophy,
                                        size: 25,
                                        color: snapshot.data == 1 ? ColorUtils.BLUE_ACCENT : ColorUtils.GRAY_TEXT_LIGHT,
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 15,
                      left: Constants.mediaWidth(context)/2 - 30,
                      child: GestureDetector(
                        onTap: () async {
                          await FirebaseAnalyticsUtils.analytics.logEvent(name: 'home_page__trivia_game_button_clicked');

                          showDialog(context: context, builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(22.0)),),
                              child: Container(
                                height: Constants.mediaHeight(context)*.37,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    Text(
                                      "Trivia Game",
                                      style: Theme.of(context).textTheme.headline4.copyWith(
                                          color: ColorUtils.GRAY_TEXT_LIGHT,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24
                                      ),
                                    ),

                                    SizedBox(height: Constants.mediaHeight(context)*.035,),

                                    Row(
                                      children: <Widget>[
                                        SizedBox(width: Constants.mediaWidth(context)*.01,),
                                        Icon(Entypo.trophy, size: 25, color: ColorUtils.GRAY_DARK,),
                                        SizedBox(width: Constants.mediaWidth(context)*.022,),
                                        Text(
                                          "25 points per question",
                                          style: Theme.of(context).textTheme.headline4.copyWith(
                                              color: ColorUtils.GRAY_TEXT_LIGHT,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: Constants.mediaHeight(context)*.015,),

                                    Row(
                                      children: <Widget>[
                                        SizedBox(width: Constants.mediaWidth(context)*.01,),
                                        Icon(MaterialCommunityIcons.comment_question, size: 25, color: ColorUtils.GRAY_DARK,),
                                        SizedBox(width: Constants.mediaWidth(context)*.022,),
                                        Text(
                                          "15 questions",
                                          style: Theme.of(context).textTheme.headline4.copyWith(
                                              color: ColorUtils.GRAY_TEXT_LIGHT,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: Constants.mediaHeight(context)*.045,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[

                                        ButtonMain(
                                          width: 100,
                                          height: 50,
                                          colorMain: ColorUtils.RED_DARK,
                                          colorSec: ColorUtils.RED_LIGHT,
                                          text: "Cancel",
                                          onTap: () async {
                                            await FirebaseAnalyticsUtils.analytics.logEvent(name: 'home_page__trivia_game_cancel_button_clicked');

                                            Navigator.of(context).pop();
                                          },
                                        ),


                                        SizedBox(width: Constants.mediaWidth(context)*.065,),
                                        ButtonMain(
                                          width: 100,
                                          height: 50,
                                          colorMain: ColorUtils.GREEN_MAIN,
                                          colorSec: ColorUtils.GREEN_LIGHT,
                                          text: "Start",
                                          onTap: () async {
                                            await FirebaseAnalyticsUtils.analytics.logEvent(name: 'home_page__trivia_game_start_button_clicked');

                                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                              builder: (context) => TriviaPage(userUUID: userUUID)
                                            ));
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: ColorUtils.BLUE_ACCENT,
                              borderRadius: new BorderRadius.circular(13.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: ColorUtils.BLUE_LIGHT,
                                  offset: new Offset(0, 5.0),
                                  blurRadius: 0,
                                )
                              ]
                          ),
                          child: Icon(
                            MaterialCommunityIcons.gamepad_variant,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Center(
                child: Container(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              );


        }) : Center(
          child: Container(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _userStatusUpperBar(User user) => Container(
    width: Constants.mediaWidth(context),
    padding: EdgeInsets.all(20),
    child: user != null ? Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
          },
          child: Container(
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
        ),

        SizedBox(width: 35,),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () async {
                    await FirebaseAnalyticsUtils.analytics.logEvent(name: 'home_page__update_username_button_clicked');

                    _userBloc.clearUsername();
                    showDialog(context: context, builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22.0)),),
                        child: Container(
                          height: Constants.mediaHeight(context)*.36,
                          padding: EdgeInsets.all(15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text(
                                  "Change username",
                                  style: Theme.of(context).textTheme.headline4.copyWith(
                                      color: ColorUtils.GRAY_TEXT_LIGHT,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26
                                  ),
                                ),

                                SizedBox(height: Constants.mediaHeight(context)*.035,),

                                StreamBuilder(
                                  stream: _userBloc.username,
                                  builder: (context, snapshot) {
                                    return FormFieldMain(
                                      hintText: 'New username...',
                                      onChanged: _userBloc.changeUsername,
                                      textInputType: TextInputType.text,
                                      obscured: false,
                                      errorText: snapshot.error,
                                    );
                                  },
                                ),

                                SizedBox(height: Constants.mediaHeight(context)*.045,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[

                                    ButtonMain(
                                      width: 100,
                                      height: 50,
                                      colorMain: ColorUtils.GRAY_LIGHT,
                                      colorSec: ColorUtils.GRAY_DARK,
                                      text: "Cancel",
                                      textColor: ColorUtils.GRAY_FORM_HINT,
                                      onTap: () async {
                                        await FirebaseAnalyticsUtils.analytics.logEvent(name: 'home_page__update_username_cancel_button_clicked');

                                        Navigator.of(context).pop();
                                      },
                                    ),


                                    SizedBox(width: Constants.mediaWidth(context)*.065,),
                                    ButtonMain(
                                      width: 100,
                                      height: 50,
                                      colorMain: ColorUtils.BLUE_MAIN,
                                      colorSec: ColorUtils.BLUE_LIGHT,
                                      text: "Update",
                                      onTap: () async {
                                        await FirebaseAnalyticsUtils.analytics.logEvent(name: 'home_page__update_username_update_button_clicked');

                                        if(_userBloc.canChangeUsername()) {
                                          BlocProvider.of<LoadingBloc>(context).add(StartLoad());
                                          await _userBloc.changeFirestoreUsername(userUUID);
                                          BlocProvider.of<LoadingBloc>(context).add(EndLoad());
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ]),
                        ),
                      );
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Text(
                            user.username ?? "",
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: ColorUtils.ORANGE_LIGHT,
                                fontWeight: FontWeight.bold,
                                fontSize: 22
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: Constants.mediaWidth(context)*.02,),
                      Icon(
                        Icons.edit,
                        size: 30,
                        color: ColorUtils.ORANGE_LIGHT,
                      ),
                    ],
                  ),
                );
              },
            ),

            Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                "${user.points} pts.",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: ColorUtils.GRAY_TEXT_LIGHT,
                  fontWeight: FontWeight.bold,
                  fontSize: 17
                ),
              ),
            ),
          ],
        ),

        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 0, left: 20),
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                GestureDetector(
                  onTap: () async {
                    await FirebaseAnalyticsUtils.analytics.logEvent(name: 'home_page__settings_button_clicked');

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsPage()
                    ));
                  },
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Icon(AntDesign.setting, size: 35, color: ColorUtils.GRAY_DARK,),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ) : Container(),
  );
}
