// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trivia _$TriviaFromJson(Map<String, dynamic> json) {
  return Trivia(
    category: json['category'] as String,
    type: json['type'] as String,
    difficulty: json['difficulty'] as String,
    question: json['question'] as String,
    correct_answer: json['correct_answer'] as String,
    incorrect_answers:
        (json['incorrect_answers'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$TriviaToJson(Trivia instance) => <String, dynamic>{
      'category': instance.category,
      'type': instance.type,
      'difficulty': instance.difficulty,
      'question': instance.question,
      'correct_answer': instance.correct_answer,
      'incorrect_answers': instance.incorrect_answers,
    };

TriviaResponse _$TriviaResponseFromJson(Map<String, dynamic> json) {
  return TriviaResponse(
    responseCode: json['responseCode'] as int,
    results: json['results'] as List,
  );
}

Map<String, dynamic> _$TriviaResponseToJson(TriviaResponse instance) =>
    <String, dynamic>{
      'responseCode': instance.responseCode,
      'results': instance.results,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://opentdb.com/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  getRandomTriviaWithAmount(amount) async {
    ArgumentError.checkNotNull(amount, 'amount');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'amount': amount};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/api.php',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = TriviaResponse.fromJson(_result.data);
    return value;
  }
}
