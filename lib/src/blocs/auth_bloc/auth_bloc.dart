import 'dart:async';
import 'package:quizlabsmock/src/models/basic_response.dart';
import 'package:quizlabsmock/src/resources/repository.dart';
import 'package:quizlabsmock/src/utils/string_utils.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc {

  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  Stream<String> get email => _email.stream.transform(_validateEmail);
  Stream<String> get password => _password.stream.transform(_validatePassword);

  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  final _validateEmail = StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (StringUtils.validateEmail(email)) {
      sink.add(email);
    } else {
      sink.addError('You must enter a valid email');
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(handleData: (password, sink) {
    if (StringUtils.validateStringLength(password)) {
      sink.add(password);
    } else {
      sink.addError('Password must be at least 6 characters');
    }
  });

  bool validateEmailAndPassword() {
    return _email.value != null &&
        _email.value.isNotEmpty &&
        StringUtils.validateEmail(_email.value) &&
        _password.value != null &&
        _password.value.isNotEmpty &&
        StringUtils.validateStringLength(_password.value);
  }

  bool canAuthenticate() {
    return validateEmailAndPassword();
  }

  // Firebase methods
  Future<BasicResponse> loginUser() async {
    BasicResponse response = await _repository.loginWithEmailAndPassword(_email.value, _password.value);
    return response;
  }

  Future<BasicResponse> registerUser() async {
    BasicResponse response = await _repository.signUpWithEmailAndPassword(_email.value, _password.value);
    return response;
  }

  void clearFields() {
    _email.value = '';
    _password.value = '';
  }

  void signOut() => _repository.signOut();

  void dispose() async {
    await _email.drain();
    _email.close();
    await _password.drain();
    _password.close();
  }
}