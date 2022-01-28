import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/repository/tasks_repository.dart';

class FirestoreTasksRepo implements TasksRepository {
  FirestoreTasksRepo(this.uid) {
    _tasksRef = FirebaseFirestore.instance.collection('users/$uid/tasks').withConverter<Task>(
          fromFirestore: (snapshot, _) => Task.fromJson(snapshot.data()!),
          toFirestore: (task, _) => task.toJson(),
        );
  }

  final String uid;

  late final CollectionReference<Task> _tasksRef;

  @override
  Future<void> addTask({
    required String title,
    required DateTime dueDate,
    required String category,
  }) async {
    final taskRef = _tasksRef.doc();
    final task = Task(
      id: taskRef.id,
      title: title,
      dueDate: dueDate,
      notes: '',
      category: category,
      done: false,
    );
    await taskRef.set(task);
  }

  @override
  Future<void> deleteTask(String id) => _tasksRef.doc(id).delete();

  @override
  Stream<List<Task>> streamTasks() {
    final snapshots = _tasksRef.orderBy('dueDate').snapshots();

    return snapshots.map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskRef = _tasksRef.doc(task.id);
    await taskRef.set(task);
  }
}
