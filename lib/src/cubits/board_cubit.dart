import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/src/models/task.dart';
import 'package:todo/src/repository/board_repository.dart';
import 'package:todo/src/states/board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository repository;
  BoardCubit(this.repository) : super(EmptyBoardState());

  Future<void> fetchTasks() async {
    emit(LoadingBoardState());
    try {
      final tasks = await repository.fetch();
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState("Erro"));
    }
  }

  Future<void> addTask(Task newTask) async {
    final tasks = _getTasksAndSttate();
    if (tasks == null) return;
    tasks.add(newTask);

    await emitTasks(tasks);
  }

  Future<void> removeTask(Task task) async {
    final tasks = _getTasksAndSttate();
    if (tasks == null) return;
    tasks.remove(task);

    await emitTasks(tasks);
  }

  Future<void> checkbox(Task newTask) async {
    final tasks = _getTasksAndSttate();
    if (tasks == null) return;

    final index = tasks.indexOf(newTask);
    tasks[index] = newTask.copyWith(check: !newTask.check);

    await emitTasks(tasks);
  }

  List<Task>? _getTasksAndSttate() {
    final state = this.state;
    if (state is! GettedTaskBoardState) return null;

    return state.tasks.toList();
  }

  Future<void> emitTasks(List<Task> tasks) async {
    try {
      await repository.update(tasks);
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState("Falha ao atualizar a tarefa"));
    }
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(GettedTaskBoardState(tasks: tasks));
  }
}
