import 'package:todo/src/models/task.dart';
import 'package:todo/src/repository/isar/isar_datasource.dart';
import 'package:todo/src/repository/isar/task_model.dart';

import '../board_repository.dart';

class IsarBoardRepository implements BoardRepository {
  final IsarDatasource datasource;
  IsarBoardRepository(this.datasource);

  @override
  Future<List<Task>> fetch() async {
    final models = await datasource.getTask();
    return models
        .map((e) => Task(
              id: e.id,
              description: e.description,
              check: e.check,
            ))
        .toList();
  }

  @override
  Future<List<Task>> update(List<Task> tasks) async {
    final models = tasks.map((e) {
      final model = TaskModel()
        ..check = e.check
        ..description = e.description;

      if (e.id != -1) {
        model.id = e.id;
      }
      return model;
    }).toList();

    await datasource.deleteAllTask();
    await datasource.putAllTasks(models);
    return tasks;
  }
}
