import 'package:flutter/material.dart';
import 'package:todo_list_app/ui/tasks/widget/task_list.dart';
import 'package:todo_list_app/ui/tasks/widget/top_bar.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TopBar(),
        TaskList(),
      ],
    );
  }
}
