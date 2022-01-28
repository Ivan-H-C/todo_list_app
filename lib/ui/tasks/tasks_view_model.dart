import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/models/category.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/providers/providers.dart';

final searchingProvider = StateProvider<bool>((ref) => false);

final tasksViewModelProvider = StateNotifierProvider.autoDispose<TasksViewModel, AsyncValue<List<Task>>>(
  (ref) {
    final tasksAsyncValue = ref.watch(tasksProvider);

    return TasksViewModel(state: tasksAsyncValue, read: ref.read);
  },
);

class TasksViewModel extends StateNotifier<AsyncValue<List<Task>>> {
  TasksViewModel({required AsyncValue<List<Task>> state, required this.read}) : super(state) {
    allTasks = state.asData?.value ?? [];
  }

  final Reader read;
  late final List<Task> allTasks;

  String? _categoryTitle;
  String _textQuery = '';

  void changeCategory({TaskCategory? category}) {
    read(currentCategoryProvider.state).state = category;
    _categoryTitle = category?.title;
    _refresh();
  }

  void changeTextQuery({required String textQuery}) async {
    _textQuery = textQuery;
    _refresh();
  }

  Future<void> _refresh() async {
    state = AsyncValue.data(
      _filterTasks(
        tasks: allTasks,
        categoryTitle: _categoryTitle,
        textQuery: _textQuery,
      ),
    );
  }

  List<Task> _filterTasks({
    required List<Task> tasks,
    required String? categoryTitle,
    required String textQuery,
  }) {
    if (categoryTitle == null) {
      return tasks
          .where(
            (task) => task.title.toLowerCase().contains(textQuery.toLowerCase()),
          )
          .toList();
    } else {
      return tasks
          .where(
            (task) => (task.category == categoryTitle && task.title.toLowerCase().contains(textQuery.toLowerCase())),
          )
          .toList();
    }
  }
}
