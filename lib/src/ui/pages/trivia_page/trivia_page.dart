import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:quizlabsmock/src/blocs/trivia_bloc/trivia_bloc.dart';
import 'package:quizlabsmock/src/blocs/trivia_bloc/trivia_bloc_provider.dart';
import 'package:quizlabsmock/src/models/question_selected.dart';
import 'package:quizlabsmock/src/resources/rest_client.dart';
import 'package:quizlabsmock/src/ui/widgets/app_bar.dart';
import 'package:quizlabsmock/src/ui/widgets/button_main.dart';
import 'package:quizlabsmock/src/utils/ad_manager.dart';
import 'package:quizlabsmock/src/utils/color_utils.dart';
import 'package:quizlabsmock/src/utils/constants.dart';
import 'package:quizlabsmock/src/utils/firebase_analytics_utils.dart';

class TriviaPage extends StatefulWidget {
  static const String routeName = 'quiz_page';

  @override
  _TriviaPageState createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  TriviaBloc _triviaBloc;

  Future<List<Trivia>> _triviaFuture;

  bool _canSelect = true;

  InterstitialAd _interstitialAd;

  bool _isInterstitialAdReady;

  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  int answersCount = 0;

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      default:
      // do nothing
    }
  }

  @override
  void didChangeDependencies() {
    _triviaBloc = TriviaBlocProvider.of(context);
    _triviaFuture = _triviaBloc.getTriviaWithAmount(15);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _canSelect = true;
    _isInterstitialAdReady = false;

    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );
    super.initState();
  }

  @override
  void dispose() {
    _triviaBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    String userUUID = "";

    if (arguments != null) {
      userUUID = arguments['userUUID'];
      print('USER UUID: $userUUID');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: FutureBuilder(
        future: _triviaFuture,
        builder: (context, AsyncSnapshot<List<Trivia>> trivia) {
          if (!trivia.hasData ||
              trivia.connectionState == ConnectionState.waiting)
            return Center(
              child: Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            );

          if (trivia.data == null)
            return Center(
              child: Text(
                "It was not possible to retrieve Trivia questions for now. Please, try again later",
                style: Theme.of(context).textTheme.headline4.copyWith(
                    color: ColorUtils.GRAY_TEXT_LIGHT,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomAppBar(
                  title: 'Trivia Quiz',
                  backActionIcon: Icons.close,
                ),
                SizedBox(
                  height: Constants.mediaHeight(context) * .015,
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: StreamBuilder(
                    stream: _triviaBloc.triviaQuestions,
                    builder: (context, AsyncSnapshot<List<Trivia>> triviaQuestions) {

                      if (triviaQuestions.data == null) return Container();

                      if(triviaQuestions.data.length <= 0)
                        return Center(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                SizedBox(height: Constants.mediaHeight(context)*0.025,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[

                                    Icon(
                                      Icons.check,
                                      color: ColorUtils.GREEN_MAIN,
                                      size: 28,
                                    ),

                                    Text(
                                      _triviaBloc.totalOfCorrectAnswers.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),

                                SizedBox(height: Constants.mediaHeight(context)*0.025,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[

                                    Icon(
                                      Icons.close,
                                      color: ColorUtils.RED_DARK,
                                      size: 28,
                                    ),

                                    Text(
                                      _triviaBloc.totalOfInCorrectAnswers.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),

                                SizedBox(height: Constants.mediaHeight(context)*0.025,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[

                                    Text(
                                      "+${_triviaBloc.totalPoints}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),

                                    Text(
                                      "Points in total",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                          color: ColorUtils.ORANGE_LIGHT,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ],
                                ),

                                SizedBox(height: Constants.mediaHeight(context)*0.08,),

                                ButtonMain(
                                  width: 100,
                                  height: 50,
                                  colorMain: ColorUtils.BLUE_MAIN,
                                  colorSec: ColorUtils.BLUE_LIGHT,
                                  text: "Finish",
                                  onTap: () async {
                                    await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__finish_button_clicked');

                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );

                      Trivia currentTriviaQuestion = triviaQuestions.data[0];

                      List<String> answers = currentTriviaQuestion.escapedIncorrectAnswers;
                      answers.add(currentTriviaQuestion.escapedCorrectAnswer);
                      answers.shuffle();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: ColorUtils.ORANGE_LIGHT,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Center(
                                    child: Text(
                                      "${16 - triviaQuestions.data.length}/15",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Constants.mediaHeight(context) * .015,
                          ),
                          Text(
                            currentTriviaQuestion.escapedQuestion,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                                    color: ColorUtils.GRAY_TEXT_LIGHT,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                          ),
                          SizedBox(
                            height: Constants.mediaHeight(context) * .035,
                          ),
                          StreamBuilder(
                            stream: _triviaBloc.questionSelected,
                            builder: (context, AsyncSnapshot<QuestionSelected> question) {
                              QuestionSelected questionSelected = QuestionSelected(
                                questionSelected: "",
                                isCorrect: false,
                                selected: false
                              );

                              if (question.data != null)
                                questionSelected = question.data;

                              if (currentTriviaQuestion.type == 'multiple') {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__option_1_button_clicked');

                                                print(_canSelect.toString());
                                                if(!_canSelect) {
                                                  return;
                                                }

                                                questionSelected.questionSelected = answers[0];
                                                _triviaBloc
                                                    .changeQuestionSelected(questionSelected);
                                              },
                                              child: ButtonMain(
                                                width: Constants.mediaWidth(
                                                        context) *
                                                    .85,
                                                height: 50,
                                                colorMain: questionSelected.questionSelected ==
                                                        answers[0]
                                                    ? questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_MAIN : ColorUtils.RED_DARK : ColorUtils.BLUE_MAIN
                                                    : ColorUtils.GRAY_LIGHT,
                                                colorSec: questionSelected.questionSelected ==
                                                        answers[0]
                                                    ? questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_LIGHT : ColorUtils.RED_LIGHT : ColorUtils.BLUE_LIGHT
                                                    : ColorUtils.GRAY_DARK,
                                                textColor: questionSelected.questionSelected ==
                                                        answers[0]
                                                    ? Colors.white
                                                    : ColorUtils.GRAY_FORM_HINT,
                                                text: answers[0],
                                              ),
                                            )),
                                        SizedBox(
                                          height:
                                              Constants.mediaHeight(context) *
                                                  .015,
                                        ),
                                        questionSelected.questionSelected == answers[0]
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(right: 15),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: ButtonMain(
                                                    width: Constants.mediaWidth(
                                                            context) *
                                                        .25,
                                                    height: 50,
                                                    colorMain:
                                                        questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_MAIN : ColorUtils.RED_DARK : ColorUtils.BLUE_MAIN,
                                                    colorSec:
                                                        questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_LIGHT : ColorUtils.RED_LIGHT : ColorUtils.BLUE_LIGHT,
                                                    textColor:
                                                        questionSelected.questionSelected ==
                                                                answers[0]
                                                            ? Colors.white
                                                            : ColorUtils
                                                                .GRAY_FORM_HINT,
                                                    text: "Confirm",
                                                    onTap: () async {
                                                      await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__confirm_1_button_clicked');

                                                      _canSelect = false;
                                                      _triviaBloc.checkIfAnswerIsCorrect(userUUID);

                                                      await Future.delayed(Duration(seconds: 2));
                                                      _triviaBloc.removeTriviaQuestionAndGoToNext(currentTriviaQuestion);
                                                      _canSelect = true;


                                                      answersCount += 1;
                                                      if(answersCount >= 7 && !_isInterstitialAdReady) {
                                                        _loadInterstitialAd();
                                                      }

                                                      if(answersCount >= 10 && _isInterstitialAdReady) {
                                                        answersCount = 0;
                                                        _interstitialAd.show();
                                                      }
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          Constants.mediaHeight(context) * .035,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__options_2_button_clicked');

                                                if(!_canSelect) {
                                                  return;
                                                }

                                                questionSelected.questionSelected = answers[1];
                                                _triviaBloc
                                                    .changeQuestionSelected(questionSelected);
                                              },
                                              child: ButtonMain(
                                                width: Constants.mediaWidth(
                                                        context) *
                                                    .85,
                                                height: 50,
                                                colorMain: questionSelected.questionSelected ==
                                                    answers[1]
                                                    ? questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_MAIN : ColorUtils.RED_DARK : ColorUtils.BLUE_MAIN
                                                    : ColorUtils.GRAY_LIGHT,
                                                colorSec: questionSelected.questionSelected ==
                                                    answers[1]
                                                    ? questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_LIGHT : ColorUtils.RED_LIGHT : ColorUtils.BLUE_LIGHT
                                                    : ColorUtils.GRAY_DARK,
                                                textColor: questionSelected.questionSelected ==
                                                        answers[1]
                                                    ? Colors.white
                                                    : ColorUtils.GRAY_FORM_HINT,
                                                text: answers[1],
                                              ),
                                            )),
                                        SizedBox(
                                          height:
                                              Constants.mediaHeight(context) *
                                                  .015,
                                        ),
                                        questionSelected.questionSelected == answers[1]
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(right: 15),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: ButtonMain(
                                                    width: Constants.mediaWidth(
                                                            context) *
                                                        .25,
                                                    height: 50,
                                                    colorMain:
                                                        questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_MAIN : ColorUtils.RED_DARK : ColorUtils.BLUE_MAIN,
                                                    colorSec:
                                                        questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_LIGHT : ColorUtils.RED_LIGHT : ColorUtils.BLUE_LIGHT,
                                                    textColor:
                                                        questionSelected.questionSelected ==
                                                                answers[1]
                                                            ? Colors.white
                                                            : ColorUtils
                                                                .GRAY_FORM_HINT,
                                                    text: "Confirm",
                                                    onTap: () async {
                                                      await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__confirm_2_button_clicked');

                                                      _canSelect = false;
                                                      _triviaBloc.checkIfAnswerIsCorrect(userUUID);

                                                      await Future.delayed(Duration(seconds: 2));
                                                      _triviaBloc.removeTriviaQuestionAndGoToNext(currentTriviaQuestion);
                                                      _canSelect = true;

                                                      answersCount += 1;
                                                      if(answersCount >= 7 && !_isInterstitialAdReady) {
                                                        _loadInterstitialAd();
                                                      }

                                                      if(answersCount >= 10 && _isInterstitialAdReady) {
                                                        answersCount = 0;
                                                        _interstitialAd.show();
                                                      }
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          Constants.mediaHeight(context) * .035,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__option_3_button_clicked');

                                                if(!_canSelect) {
                                                  return;
                                                }

                                                questionSelected.questionSelected = answers[2];
                                                _triviaBloc
                                                    .changeQuestionSelected(questionSelected);
                                              },
                                              child: ButtonMain(
                                                width: Constants.mediaWidth(
                                                        context) *
                                                    .85,
                                                height: 50,
                                                colorMain: questionSelected.questionSelected ==
                                                    answers[2]
                                                    ? questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_MAIN : ColorUtils.RED_DARK : ColorUtils.BLUE_MAIN
                                                    : ColorUtils.GRAY_LIGHT,
                                                colorSec: questionSelected.questionSelected ==
                                                    answers[2]
                                                    ? questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_LIGHT : ColorUtils.RED_LIGHT : ColorUtils.BLUE_LIGHT
                                                    : ColorUtils.GRAY_DARK,
                                                textColor: questionSelected.questionSelected ==
                                                        answers[2]
                                                    ? Colors.white
                                                    : ColorUtils.GRAY_FORM_HINT,
                                                text: answers[2],
                                              ),
                                            )),
                                        SizedBox(
                                          height:
                                              Constants.mediaHeight(context) *
                                                  .015,
                                        ),
                                        questionSelected.questionSelected == answers[2]
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(right: 15),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: ButtonMain(
                                                    width: Constants.mediaWidth(
                                                            context) *
                                                        .25,
                                                    height: 50,
                                                    colorMain:
                                                    questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_MAIN : ColorUtils.RED_DARK : ColorUtils.BLUE_MAIN,
                                                    colorSec:
                                                    questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_LIGHT : ColorUtils.RED_LIGHT : ColorUtils.BLUE_LIGHT,
                                                    textColor:
                                                        questionSelected.questionSelected ==
                                                                answers[2]
                                                            ? Colors.white
                                                            : ColorUtils
                                                                .GRAY_FORM_HINT,
                                                    text: "Confirm",
                                                    onTap: () async {
                                                      await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__confirm_3_button_clicked');

                                                      _canSelect = false;
                                                      _triviaBloc.checkIfAnswerIsCorrect(userUUID);

                                                      await Future.delayed(Duration(seconds: 2));
                                                      _triviaBloc.removeTriviaQuestionAndGoToNext(currentTriviaQuestion);
                                                      _canSelect = true;

                                                      answersCount += 1;
                                                      if(answersCount >= 7 && !_isInterstitialAdReady) {
                                                        _loadInterstitialAd();
                                                      }

                                                      if(answersCount >= 10 && _isInterstitialAdReady) {
                                                        answersCount = 0;
                                                        _interstitialAd.show();
                                                      }
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          Constants.mediaHeight(context) * .035,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__option_4_button_clicked');

                                                if(!_canSelect) {
                                                  return;
                                                }

                                                questionSelected.questionSelected = answers[3];
                                                _triviaBloc
                                                    .changeQuestionSelected(questionSelected);
                                              },
                                              child: ButtonMain(
                                                width: Constants.mediaWidth(
                                                        context) *
                                                    .85,
                                                height: 50,
                                                colorMain: questionSelected.questionSelected ==
                                                    answers[3]
                                                    ? questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_MAIN : ColorUtils.RED_DARK : ColorUtils.BLUE_MAIN
                                                    : ColorUtils.GRAY_LIGHT,
                                                colorSec: questionSelected.questionSelected ==
                                                    answers[3]
                                                    ? questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_LIGHT : ColorUtils.RED_LIGHT : ColorUtils.BLUE_LIGHT
                                                    : ColorUtils.GRAY_DARK,
                                                textColor: questionSelected.questionSelected ==
                                                        answers[3]
                                                    ? Colors.white
                                                    : ColorUtils.GRAY_FORM_HINT,
                                                text: answers[3],
                                              ),
                                            )),
                                        SizedBox(
                                          height:
                                              Constants.mediaHeight(context) *
                                                  .015,
                                        ),
                                        questionSelected.questionSelected == answers[3]
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(right: 15),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: ButtonMain(
                                                    width: Constants.mediaWidth(
                                                            context) *
                                                        .25,
                                                    height: 50,
                                                    colorMain:
                                                    questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_MAIN : ColorUtils.RED_DARK : ColorUtils.BLUE_MAIN,
                                                    colorSec:
                                                    questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_LIGHT : ColorUtils.RED_LIGHT : ColorUtils.BLUE_LIGHT,
                                                    textColor:
                                                        questionSelected.questionSelected ==
                                                                answers[3]
                                                            ? Colors.white
                                                            : ColorUtils
                                                                .GRAY_FORM_HINT,
                                                    text: "Confirm",
                                                    onTap: () async {
                                                      await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__confirm_4_button_clicked');

                                                      _canSelect = false;
                                                      _triviaBloc.checkIfAnswerIsCorrect(userUUID);

                                                      await Future.delayed(Duration(seconds: 2));
                                                      _triviaBloc.removeTriviaQuestionAndGoToNext(currentTriviaQuestion);
                                                      _canSelect = true;

                                                      answersCount += 1;
                                                      if(answersCount >= 7 && !_isInterstitialAdReady) {
                                                        _loadInterstitialAd();
                                                      }

                                                      if(answersCount >= 10 && _isInterstitialAdReady) {
                                                        answersCount = 0;
                                                        _interstitialAd.show();
                                                      }
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height:
                                        Constants.mediaHeight(context) * .03,
                                  ),
                                  Text(
                                    currentTriviaQuestion.escapedQuestion,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                            color: ColorUtils.GRAY_TEXT_LIGHT,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () async {
                                              await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__boolean_option_1_button_clicked');

                                              if(!_canSelect) {
                                                return;
                                              }

                                              questionSelected.questionSelected = answers[0];
                                              _triviaBloc
                                                  .changeQuestionSelected(questionSelected);
                                            },
                                            child: ButtonMain(
                                              width: Constants.mediaWidth(
                                                      context) *
                                                  .85,
                                              height: 50,
                                              colorMain: questionSelected.questionSelected ==
                                                  answers[0]
                                                  ? questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_MAIN : ColorUtils.RED_DARK : ColorUtils.BLUE_MAIN
                                                  : ColorUtils.GRAY_LIGHT,
                                              colorSec: questionSelected.questionSelected ==
                                                  answers[0]
                                                  ? questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_LIGHT : ColorUtils.RED_LIGHT : ColorUtils.BLUE_LIGHT
                                                  : ColorUtils.GRAY_DARK,
                                              textColor: questionSelected.questionSelected ==
                                                      answers[0]
                                                  ? Colors.white
                                                  : ColorUtils.GRAY_FORM_HINT,
                                              text: answers[0],
                                            ),
                                          )),
                                      SizedBox(
                                        height: Constants.mediaHeight(context) *
                                            .015,
                                      ),
                                      questionSelected.questionSelected == answers[0]
                                          ? Container(
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: ButtonMain(
                                                  width: Constants.mediaWidth(
                                                          context) *
                                                      .25,
                                                  height: 50,
                                                  colorMain:
                                                  questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_MAIN : ColorUtils.RED_DARK : ColorUtils.BLUE_MAIN,
                                                  colorSec:
                                                  questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_LIGHT : ColorUtils.RED_LIGHT : ColorUtils.BLUE_LIGHT,
                                                  textColor: questionSelected.questionSelected ==
                                                          answers[0]
                                                      ? Colors.white
                                                      : ColorUtils
                                                          .GRAY_FORM_HINT,
                                                  text: "Confirm",
                                                  onTap: () async {
                                                    await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__boolean_confirm_1_button_clicked');

                                                    _canSelect = false;
                                                    _triviaBloc.checkIfAnswerIsCorrect(userUUID);

                                                    await Future.delayed(Duration(seconds: 2));
                                                    _triviaBloc.removeTriviaQuestionAndGoToNext(currentTriviaQuestion);
                                                    _canSelect = true;

                                                    answersCount += 1;
                                                    if(answersCount >= 7 && !_isInterstitialAdReady) {
                                                      _loadInterstitialAd();
                                                    }

                                                    if(answersCount >= 10 && _isInterstitialAdReady) {
                                                      answersCount = 0;
                                                      _interstitialAd.show();
                                                    }
                                                  },
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        Constants.mediaHeight(context) * .035,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () async {
                                              await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__boolean_option_2_button_clicked');

                                              if(!_canSelect) {
                                                return;
                                              }

                                              questionSelected.questionSelected = answers[1];
                                              _triviaBloc
                                                  .changeQuestionSelected(questionSelected);
                                            },
                                            child: ButtonMain(
                                              width: Constants.mediaWidth(
                                                      context) *
                                                  .85,
                                              height: 50,
                                              colorMain: questionSelected.questionSelected ==
                                                  answers[1]
                                                  ? questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_MAIN : ColorUtils.RED_DARK : ColorUtils.BLUE_MAIN
                                                  : ColorUtils.GRAY_LIGHT,
                                              colorSec: questionSelected.questionSelected ==
                                                  answers[1]
                                                  ? questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_LIGHT : ColorUtils.RED_LIGHT : ColorUtils.BLUE_LIGHT
                                                  : ColorUtils.GRAY_DARK,
                                              textColor: questionSelected.questionSelected ==
                                                      answers[1]
                                                  ? Colors.white
                                                  : ColorUtils.GRAY_FORM_HINT,
                                              text: answers[1],
                                            ),
                                          )),
                                      SizedBox(
                                        height: Constants.mediaHeight(context) *
                                            .015,
                                      ),
                                      questionSelected.questionSelected == answers[1]
                                          ? Container(
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: ButtonMain(
                                                  width: Constants.mediaWidth(
                                                          context) *
                                                      .25,
                                                  height: 50,
                                                  colorMain:
                                                  questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_MAIN : ColorUtils.RED_DARK : ColorUtils.BLUE_MAIN,
                                                  colorSec:
                                                  questionSelected.selected ? questionSelected.isCorrect ? ColorUtils.GREEN_LIGHT : ColorUtils.RED_LIGHT : ColorUtils.BLUE_LIGHT,
                                                  textColor: questionSelected.questionSelected ==
                                                          answers[1]
                                                      ? Colors.white
                                                      : ColorUtils
                                                          .GRAY_FORM_HINT,
                                                  text: "Confirm",
                                                  onTap: () async {
                                                    await FirebaseAnalyticsUtils.analytics.logEvent(name: 'trivia_page__boolean_confirm_2_button_clicked');

                                                    _canSelect = false;
                                                    _triviaBloc.checkIfAnswerIsCorrect(userUUID);

                                                    await Future.delayed(Duration(seconds: 2));
                                                    _triviaBloc.removeTriviaQuestionAndGoToNext(currentTriviaQuestion);
                                                    _canSelect = true;

                                                    answersCount += 1;
                                                    if(answersCount >= 7 && !_isInterstitialAdReady) {
                                                      _loadInterstitialAd();
                                                    }

                                                    if(answersCount >= 10 && _isInterstitialAdReady) {
                                                      answersCount = 0;
                                                      _interstitialAd.show();
                                                    }
                                                  },
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
