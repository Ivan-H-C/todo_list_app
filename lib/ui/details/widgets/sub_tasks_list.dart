import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/models/sub_task.dart';
import 'package:todo_list_app/providers/providers.dart';
import 'package:todo_list_app/ui/details/widgets/subtask_widget.dart';

class SubTasksList extends ConsumerWidget {
  const SubTasksList({Key? key, required this.taskID, required this.onReorder}) : super(key: key);

  final void Function(SubTask subTask, String? preRank, String? postRank) onReorder;
  final String taskID;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subTasksAsynValue = ref.watch(subTasksProvider(taskID));
    return subTasksAsynValue.when(
      data: (subTasks) => ReorderableListView.builder(
        shrinkWrap: true,
        itemCount: subTasks.length,
        itemBuilder: (context, index) {
          final subTask = subTasks[index];
          final subTasksRepository = ref.read(subTasksRepositoryProvider(taskID));
          return SubTaskWidget(
            key: ValueKey(subTask.id),
            subTask: subTasks[index],
            onCheck: (done) => subTasksRepository!.updateSubTask(subTask.copyWith(done: done)),
            onChangeTitle: (title) => subTasksRepository!.updateSubTask(subTask.copyWith(title: title)),
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          SubTask subTask = subTasks[oldIndex];
          String? preRank;
          String? postRank;
          if (newIndex < oldIndex) {
            if (newIndex != 0) {
              preRank = subTasks[newIndex - 1].rank;
            }
            postRank = subTasks[newIndex].rank;
          } else if (newIndex > oldIndex) {
            newIndex -= 1;
            if (newIndex < subTasks.length - 1) {
              postRank = subTasks[newIndex + 1].rank;
            }
            preRank = subTasks[newIndex].rank;
          }
          onReorder(subTask, preRank, postRank);
        },
      ),
      error: (error, stack) {
        print(error);
        return const Center(child: Text('Something went wrong'));
      },
      loading: () => const CircularProgressIndicator(),
    );
  }
}
