part of 'loading_bloc.dart';

abstract class LoadingEvent {
  const LoadingEvent();

  @override
  List<Object> get props => [];
}

class StartLoad extends LoadingEvent {
  @override
  String toString() => 'StartLoad';
}

class EndLoad extends LoadingEvent {
  @override
  String toString() => 'EndLoad';
}