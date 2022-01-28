import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/models/sub_task.dart';
import 'package:todo_list_app/repository/sub_tasks_repository.dart';

class FirestoreSubTaskRepo implements SubTasksRepository {
  FirestoreSubTaskRepo({required this.uid, required this.taskID}) {
    _subTasksRef = FirebaseFirestore.instance.collection('users/$uid/tasks/$taskID/subTasks').withConverter(
          fromFirestore: (snapshot, _) => SubTask.fromJson(snapshot.data()!),
          toFirestore: (subTask, _) => subTask.toJson(),
        );
  }
  final String uid;
  final String taskID;
  late final CollectionReference<SubTask> _subTasksRef;
  
  @override
  Future<void> addSubTask() async {
    final subTaskRef = _subTasksRef.doc();
    final subTask = SubTask(id: subTaskRef.id, title: '', done: false);
    await subTaskRef.set(subTask);
  }

  @override
  Future<void> deleteSubTask(String id) => _subTasksRef.doc(id).delete();

  @override
  Stream<List<SubTask>> streamSubTasks() {
    final snaphots = _subTasksRef.snapshots();
    return snaphots.map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Future<void> updateSubTask(SubTask subTask) async {
    final subTaskRef = _subTasksRef.doc(subTask.id);
    await subTaskRef.set(subTask);
  }
}
