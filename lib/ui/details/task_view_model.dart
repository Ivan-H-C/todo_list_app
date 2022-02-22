import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/models/sub_task.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/providers/providers.dart';

final taskViewModelProvider = StateNotifierProvider.family<TaskViewModel, Task, Task>(
  (ref, task) => TaskViewModel(state: task, read: ref.read),
);

class TaskViewModel extends StateNotifier<Task> {
  TaskViewModel({required Task state, required this.read}) : super(state);

  final Reader read;

  Future<void> updateTask({
    String? title,
    DateTime? dueDate,
    String? notes,
    String? category,
    bool? done,
  }) async {
    final tasksRepository = read(tasksRepositoryProvider);
    state = state.copyWith(
      title: title,
      dueDate: dueDate,
      notes: notes,
      category: category,
      done: done,
    );
    await tasksRepository!.updateTask(state);
  }

  Future<void> deleteTask(String id) async {
    final tasksRepository = read(tasksRepositoryProvider);
    await tasksRepository!.deleteTask(id);
  }

  Future<void> addSubTask({required String? lastRank}) async {
    final subTasksRepository = read(subTasksRepositoryProvider(state.id));

    /// This is an aproximation of what I did using lexicographic order.
    /// aaa = (0)(0)(0)
    /// ana == (0)(13)(0) = aaa + 'interval' = (0)(0)(0) + (0)(13)(0)
    /// baa == (1)(0)(0) = am0 + 'interval' = (0)(13)(0) + (0)(13)(0)
    /// bna == (1)(13)(0) = baa + 'interval' = (1)(0)(0) + (0)(13)(0)
    /// ...
    /// zna == (25)(13)(0) = zaa + 'interval' = (25)(0)(0) + (0)(13)(0)
    ///
    const base = 97;
    String rank = 'ana';
    if (lastRank != null) {
      final characteres = lastRank.split('');
      final firstCharCode = characteres[0].codeUnitAt(0);
      final secondCharCode = characteres[1].codeUnitAt(0);

      if (secondCharCode + 13 >= base + 25) {
        int code = firstCharCode + 1;
        if (code < base + 25) {
          rank = String.fromCharCode(code) + 'aa';
        }
      } else {
        int code = secondCharCode + 13;
        rank = characteres[0] + String.fromCharCode(code) + 'a';
      }
    }
    await subTasksRepository!.addSubTask(rank);
  }

  Future<void> reorderSubTask(SubTask subTask, String? preRank, String? postRank) async {
    final subTasksRepository = read(subTasksRepositoryProvider(state.id));
    final _preRank = preRank ?? 'aaa';
    final _postRank = postRank ?? 'zzz';

    final rank = _asignRank(preRank: _preRank, postRank: _postRank);
    await subTasksRepository!.updateSubTask(subTask.copyWith(rank: rank));
  }

  String? _asignRank({required String preRank, required String postRank}) {
    final preCharacteres = preRank.split('');
    final postCharacteres = postRank.split('');

    int before = 0;

    String? rank;

    for (int i = 0; i < 3; i++) {
      final preCharCode = preCharacteres[i].codeUnitAt(0);
      final postCharCode = postCharacteres[i].codeUnitAt(0);
      final semiDifference = (postCharCode - preCharCode) / 2;
      int toAdd = ((postCharCode - preCharCode) ~/ 2).abs();

      if (rank == null) {
        rank = String.fromCharCode(preCharCode + toAdd);
        before = ((semiDifference - toAdd) * 26).toInt();
      } else {
        int code = preCharCode + (before - toAdd).abs();
        if (code < 122) {
          rank += String.fromCharCode(code);
        } else {
          code = code - 25;
          rank = rank.substring(0, i - 1) +
              String.fromCharCode(rank.substring(i - 1, i).codeUnitAt(0) + 1) +
              String.fromCharCode(code);
        }
      }
    }
    if (rank == preRank || rank == postRank) return null;
    return rank;
  }

  Future<void> saveCategory(String title) async {
    final categoriesRepository = read(categoriesRepositoryProvider);
    await categoriesRepository!.saveCategory(title: title);
  }
}
