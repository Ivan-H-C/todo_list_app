import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> addSubTask() async {
    final subTasksRepository = read(subTasksRepositoryProvider(state.id));
    await subTasksRepository!.addSubTask();
  }

  Future<void> saveCategory(String title) async {
    final categoriesRepository = read(categoriesRepositoryProvider);
    await categoriesRepository!.saveCategory(title: title);
  }
}
