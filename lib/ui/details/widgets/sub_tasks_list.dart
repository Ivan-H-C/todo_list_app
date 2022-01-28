import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/providers/providers.dart';
import 'package:todo_list_app/ui/details/widgets/subtask_widget.dart';

class SubTasksList extends ConsumerWidget {
  const SubTasksList({Key? key, required this.taskID}) : super(key: key);
  final String taskID;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subTasksAsynValue = ref.watch(subTasksProvider(taskID));
    return subTasksAsynValue.when(
      data: (subTasks) => ListView.builder(
        shrinkWrap: true,
        itemCount: subTasks.length,
        itemBuilder: (context, index) {
          final subTask = subTasks[index];
          final subTasksRepository = ref.read(subTasksRepositoryProvider(taskID));
          return SubTaskWidget(
            subTask: subTasks[index],
            onCheck: (done) =>  subTasksRepository!.updateSubTask(subTask.copyWith(done: done)),
            onChangeTitle: (title) => subTasksRepository!.updateSubTask(subTask.copyWith(title: title)),
          );
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
