import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:quizlabsmock/src/models/question_selected.dart';
import 'package:quizlabsmock/src/resources/repository.dart';
import 'package:quizlabsmock/src/resources/rest_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart' hide Headers;

class TriviaBloc {

  final _repository = Repository();
  final logger = Logger();
  RestClient _restClient;

  TriviaBloc() {
    final dio = Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true));
    _restClient = RestClient(dio);
  }

  BehaviorSubject<List<Trivia>> _triviaQuestions = BehaviorSubject();
  BehaviorSubject<QuestionSelected> _questionSelected = BehaviorSubject();
  BehaviorSubject<int> _correctAnswers = BehaviorSubject();

  Stream<List<Trivia>> get triviaQuestions => _triviaQuestions.stream;
  Function(List<Trivia>) get changeTriviaQuestions => _triviaQuestions.sink.add;

  Stream<int> get correctAnswers => _correctAnswers.stream;
  Function(int) get changeCorrectAnswers => _correctAnswers.sink.add;

  Stream<QuestionSelected> get questionSelected => _questionSelected.stream;
  Function(QuestionSelected) get changeQuestionSelected => _questionSelected.sink.add;

  int get totalOfCorrectAnswers => _correctAnswers.value;
  int get totalOfInCorrectAnswers => 15 - _correctAnswers.value;
  int get totalPoints => _correctAnswers.value * 25;

  Future<List<Trivia>> getTriviaWithAmount(int amount) async {
    TriviaResponse triviaResponse = await _restClient.getRandomTriviaWithAmount(amount);
    logger.i(triviaResponse);
    List<dynamic> triviaJson = triviaResponse.results;
    List<Trivia> triviaData = triviaJson.map((trivia) => Trivia.fromJson(trivia)).toList();
    changeTriviaQuestions(triviaData);
    changeCorrectAnswers(0);
    return triviaData;
  }

  void checkIfAnswerIsCorrect(String userUID) async {
    Trivia currentTriviaQuestion = _triviaQuestions.value != null ? _triviaQuestions.value[0] : null;
    QuestionSelected userAnswer = _questionSelected.value ?? null;

    if(currentTriviaQuestion != null && userAnswer != null) {
      userAnswer.selected = true;

      int currentCorrectAnswers = _correctAnswers.value;

      if(currentTriviaQuestion.correct_answer.toLowerCase() == userAnswer.questionSelected.toLowerCase()) {
        userAnswer.isCorrect = true;
        changeQuestionSelected(userAnswer);
        changeCorrectAnswers(currentCorrectAnswers + 1);

        await _repository.addUserPointsAndPointsToUserGraphMap(userUID);
      } else {
        userAnswer.isCorrect = false;
        changeQuestionSelected(userAnswer);
      }
    }
  }

  void removeTriviaQuestionAndGoToNext(Trivia trivia) {
    List<Trivia> currentTriviaQuestions = _triviaQuestions.value;

    if(currentTriviaQuestions != null && currentTriviaQuestions.remove(trivia)) {
      changeTriviaQuestions(currentTriviaQuestions);
      changeQuestionSelected(null);
    }
  }

  void dispose() async {
    await _triviaQuestions.drain();
    _triviaQuestions.close();
    await _questionSelected.drain();
    _questionSelected.close();
    await _correctAnswers.drain();
    _correctAnswers.close();
  }
}