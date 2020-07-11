import 'dart:async';

import 'package:bloc/bloc.dart';

part 'loading_event.dart';
part 'loading_state.dart';

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  @override
  LoadingState get initialState => LoadingInitial();

  @override
  Stream<LoadingState> mapEventToState(
    LoadingEvent event,
  ) async* {
    if (event is StartLoad) {
      yield (Loading());
    } else {
      yield (Loaded());
    }
  }
}
