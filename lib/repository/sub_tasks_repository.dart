import 'package:todo_list_app/models/sub_task.dart';
abstract class SubTasksRepository {
  Stream<List<SubTask>> streamSubTasks();

  Future<void> addSubTask(String rank);

  Future<void> deleteSubTask(String id);

  Future<void> updateSubTask(SubTask subTask);
}
