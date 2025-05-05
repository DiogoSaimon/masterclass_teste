import 'package:todo/src/models/task.dart';

sealed class BoardState {}

class LoadingBoardState implements BoardState {}

class GettedTaskBoardState implements BoardState {
  final List<Task> tasks;
  GettedTaskBoardState({
    required this.tasks,
  });
}

class EmptyBoardState extends GettedTaskBoardState {
  EmptyBoardState() : super(tasks: []);
}

class FailureBoardState implements BoardState {
  final String message;
  FailureBoardState(this.message);
}
