import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:quizlabsmock/src/resources/repository.dart';
import 'package:quizlabsmock/src/utils/string_utils.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {

  final _repository = Repository();
  final logger = Logger();

  BehaviorSubject<int> _pageSelected = BehaviorSubject<int>();
  BehaviorSubject<String> _username = BehaviorSubject<String>();

  Stream<int> get pageSelected => _pageSelected.stream;
  Function(int) get changePageSelected => _pageSelected.sink.add;

  Stream<String> get username => _username.stream.transform(_validateUsername);
  Function(String) get changeUsername => _username.sink.add;

  Stream<DocumentSnapshot> userDoc(String userUID) => _repository.userDoc(userUID);
  Stream<QuerySnapshot> getTenFirstRakingUsersAsc() => _repository.getTenFirstRakingUsersAsc();

  final _validateUsername = StreamTransformer<String, String>.fromHandlers(handleData: (username, sink) {
    if (StringUtils.validateStringLength(username)) {
      sink.add(username);
    } else {
      sink.addError('Username must be at least 6 characters');
    }
  });

  void clearUsername() {
    _username.value = '';
  }

  bool canChangeUsername() {
    return _username.value != null &&
        _username.value.isNotEmpty &&
        StringUtils.validateStringLength(_username.value);
  }

  Future<void> changeFirestoreUsername(String userUUID) => _repository.changeFirestoreUsername(userUUID, _username.value);

  void signOut() => _repository.signOut();

  void dispose() async {
    await _pageSelected.drain();
    _pageSelected.close();    
    await _username.drain();
    _username.close();
  }
}