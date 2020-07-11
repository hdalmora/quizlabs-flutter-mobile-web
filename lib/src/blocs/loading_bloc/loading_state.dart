part of 'loading_bloc.dart';

abstract class LoadingState {
  const LoadingState();

  List<Object> get props => [];
}

class LoadingInitial extends LoadingState {}

class Loading extends LoadingState {
  @override
  String toString() => 'Loading..';
}

class Loaded extends LoadingState {
  @override
  String toString() => 'Loaded..';
}
