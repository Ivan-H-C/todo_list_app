import 'package:todo_list_app/models/task.dart';

abstract class TasksRepository {

  Stream<List<Task>> streamTasks();

  Future<void> addTask({
    required String title,
    required DateTime dueDate,
    required String category,
  });

  Future<void> updateTask(Task task);

  Future<void> deleteTask(String id);
}
