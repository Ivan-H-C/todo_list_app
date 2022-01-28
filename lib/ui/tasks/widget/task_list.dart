import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/providers/providers.dart';
import 'package:todo_list_app/ui/details/task_details_page.dart';
import 'package:todo_list_app/ui/common_widgets/task_widget.dart';
import 'package:todo_list_app/ui/tasks/tasks_view_model.dart';

class TaskList extends ConsumerWidget {
  const TaskList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(tasksViewModelProvider);
    return Expanded(
      child: tasksAsyncValue.when(
        data: (tasks) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskWidget(
                task: task,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaskDetailsPage(
                            currentTask: task,
                          )),
                ),
                onChangedDoneValue: (value) =>
                    ref.read(tasksRepositoryProvider)?.updateTask(task.copyWith(done: value)),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
        error: (error, stack) {
          print(error);
          return const Center(child: Text('Something went wrong'));
        },
        //TODO: implement loading
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
