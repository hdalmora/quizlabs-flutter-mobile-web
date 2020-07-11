import 'package:html_unescape/html_unescape_small.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quizlabsmock/src/utils/string_utils.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'rest_client.g.dart';


@RestApi(baseUrl: "https://opentdb.com/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/api.php")
  Future<TriviaResponse> getRandomTriviaWithAmount(@Query("amount") int amount);
}

@JsonSerializable()
class Trivia {
  String category;
  String type;
  String difficulty;
  String question;
  // ignore: non_constant_identifier_names
  String correct_answer;
  // ignore: non_constant_identifier_names
  List<String> incorrect_answers;

  String get escapedQuestion => StringUtils.escapeString(question);
  String get escapedCorrectAnswer => StringUtils.escapeString(correct_answer);
  List<String> get escapedIncorrectAnswers => incorrect_answers.map((e) => StringUtils.escapeString(e)).toList();

  // ignore: non_constant_identifier_names
  Trivia({this.category, this.type, this.difficulty, this.question, this.correct_answer, this.incorrect_answers});

  factory Trivia.fromJson(Map<String, dynamic> json) => _$TriviaFromJson(json);
  Map<String, dynamic> toJson() => _$TriviaToJson(this);
}

@JsonSerializable()
class TriviaResponse {
  int responseCode;
  List<dynamic> results;

  TriviaResponse({this.responseCode, this.results});

  factory TriviaResponse.fromJson(Map<String, dynamic> json) => _$TriviaResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TriviaResponseToJson(this);
}