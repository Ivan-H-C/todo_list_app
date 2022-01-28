import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/models/category.dart';
import 'package:todo_list_app/models/sub_task.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/repository/categories_repository.dart';
import 'package:todo_list_app/repository/firestore_categories_repo.dart';
import 'package:todo_list_app/repository/firestore_subtasks_repo.dart';
import 'package:todo_list_app/repository/firestore_tasks_repo.dart';
import 'package:todo_list_app/repository/sub_tasks_repository.dart';
import 'package:todo_list_app/repository/tasks_repository.dart';

final authProvider = Provider((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>(
  (ref) => ref.watch(authProvider).authStateChanges(),
);

final tasksRepositoryProvider = Provider<TasksRepository?>(
  (ref) {
    final uid = ref.watch(authStateChangesProvider).asData?.value?.uid;

    if (uid != null) {
      return FirestoreTasksRepo(uid);
    }

    return null;
  },
);

final categoriesRepositoryProvider = Provider<CategoriesRepository?>(
  (ref) {
    final uid = ref.watch(authStateChangesProvider).asData?.value?.uid;

    if (uid != null) {
      return FirestoreCategoriesRepo(uid);
    }
    return null;
  },
);

final subTasksRepositoryProvider = Provider.family<SubTasksRepository?, String>(
  (ref, taskID) {
    final uid = ref.watch(authStateChangesProvider).asData?.value?.uid;

    if (uid != null) {
      return FirestoreSubTaskRepo(uid: uid, taskID: taskID);
    }
    return null;
  },
);

final tasksProvider = StreamProvider.autoDispose<List<Task>>(
  (ref) => ref.watch(tasksRepositoryProvider)?.streamTasks() ?? const Stream.empty(),
);

final categoriesProvider = StreamProvider.autoDispose<List<TaskCategory>>(
  (ref) => ref.watch(categoriesRepositoryProvider)?.streamCategories() ?? const Stream.empty(),
);

final subTasksProvider = StreamProvider.autoDispose.family<List<SubTask>, String>(
  (ref, taskID) => ref.watch(subTasksRepositoryProvider(taskID))?.streamSubTasks() ?? const Stream.empty(),
);

final currentCategoryProvider = StateProvider<TaskCategory?>((ref) => null);

final currentTaskProvider = Provider<Task>((ref) => throw UnimplementedError());
