import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/src/cubits/board_cubit.dart';
import 'package:todo/src/models/task.dart';
import 'package:todo/src/repository/board_repository.dart';
import 'package:todo/src/states/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit = BoardCubit(repository);
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  group('fetchTasks | ', () {
    test('Deve pegar todas as Tasks', () async {
      when(() => repository.fetch()).thenAnswer(
        (_) async => [
          const Task(id: 1, description: "", check: false),
        ],
      );

      expect(
        cubit.stream,
        emitsInOrder([
          isA<LoadingBoardState>(),
          isA<GettedTaskBoardState>(),
        ]),
      );

      await cubit.fetchTasks();
    });

    test("Deve retornar um estado de erro ao falhar", () async {
      when(() => repository.fetch()).thenThrow(FailureBoardState("Erro"));

      expect(
          cubit.stream,
          emitsInOrder([
            isA<LoadingBoardState>(),
            isA<FailureBoardState>(),
          ]));

      await cubit.fetchTasks();
    });
  });

  group('addTasks | ', () {
    test('Deve adicionar uma Tasks', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTaskBoardState>(),
        ]),
      );

      const task = Task(id: 1, description: "");
      await cubit.addTask(task);
      final state = cubit.state as GettedTaskBoardState;
      expect(state.tasks, [task]);
      expect(state.tasks.length, 1);
    });

    test("Deve retornar um estado de erro ao falhar", () async {
      when(() => repository.update(any())).thenThrow(FailureBoardState("Erro"));

      expect(
          cubit.stream,
          emitsInOrder([
            isA<FailureBoardState>(),
          ]));

      const task = Task(id: 1, description: "");
      await cubit.addTask(task);
    });
  });

  group('removeTasks | ', () {
    test('Deve remover uma Tasks', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);
      const task = Task(id: 1, description: "");
      cubit.addTasks([task]);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTaskBoardState>(),
        ]),
      );

      final state = cubit.state as GettedTaskBoardState;
      expect((cubit.state as GettedTaskBoardState).tasks.length, 1);
      expect(state.tasks, [task]);

      await cubit.removeTask(task);
    });

    test("Deve retornar um estado de erro ao falhar", () async {
      when(() => repository.update(any())).thenThrow(FailureBoardState("Erro"));
      const task = Task(id: 1, description: "");
      cubit.addTasks([task]);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<FailureBoardState>(),
          ]));

      await cubit.removeTask(task);
    });
  });

  group('checkTasks | ', () {
    test('Deve checar uma Tasks', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);
      const task = Task(id: 1, description: "");
      cubit.addTasks([task]);
      expect((cubit.state as GettedTaskBoardState).tasks.length, 1);
      expect((cubit.state as GettedTaskBoardState).tasks.first.check, false);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTaskBoardState>(),
        ]),
      );

      await cubit.checkbox(task);
      final state = cubit.state as GettedTaskBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks.first.check, true);
    });

    test("Deve retornar um estado de erro ao falhar", () async {
      when(() => repository.update(any())).thenThrow(FailureBoardState("Erro"));
      const task = Task(id: 1, description: "");
      cubit.addTasks([task]);
      expect((cubit.state as GettedTaskBoardState).tasks.length, 1);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<FailureBoardState>(),
          ]));

      await cubit.checkbox(task);
    });
  });
}
