import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/models/sub_task.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/providers/providers.dart';
import 'package:todo_list_app/ui/common_widgets/categories.dart';
import 'package:todo_list_app/ui/common_widgets/save_category_widget.dart';
import 'package:todo_list_app/ui/details/widgets/sub_tasks_list.dart';
import 'package:todo_list_app/ui/details/task_view_model.dart';
import 'package:todo_list_app/ui/common_widgets/info_widget.dart';

class TaskDetailsPage extends ConsumerWidget {
  const TaskDetailsPage({Key? key, required this.currentTask}) : super(key: key);

  final Task currentTask;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskViewModelProvider(currentTask));
    final taskViewModel = ref.watch(taskViewModelProvider(currentTask).notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: [
            PopupMenuButton(
              offset: const Offset(0, 50),
              onSelected: (value) {
                switch (value) {
                  case 0:
                    taskViewModel.updateTask(done: !task.done);
                    break;
                  case 1:
                    taskViewModel.deleteTask(task.id);
                    Navigator.pop(context);
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Text(
                    task.done ? 'Mark as undone' : 'Mark as done',
                  ),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategoriesWidget(
                offset: const Offset(0, 40),
                selectedCategory: task.category ?? 'No category',
                onSelected: (category) => taskViewModel.updateTask(category: category),
                onCreateNew: () => showDialog(
                  context: context,
                  builder: (context) => SaveCategoryDialog(
                    onSave: (title) => taskViewModel.saveCategory(title),
                  ),
                ),
              ),
              TextField(
                controller: TextEditingController(text: task.title),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (title) => taskViewModel.updateTask(title: title),
              ),
              Flexible(
                child: SubTasksList(
                  taskID: task.id,
                  onReorder: taskViewModel.reorderSubTask,
                ),
              ),
              const SizedBox(height: 20),
              Consumer(builder: (context, ref, child) {
                return InkWell(
                  onTap: () {
                    final subTasksAsyncValue = ref.watch(subTasksProvider(task.id));
                    subTasksAsyncValue.whenData(
                      (subTasks) {
                        if (subTasks.isEmpty) {
                          taskViewModel.addSubTask(lastRank: null);
                        } else {
                          taskViewModel.addSubTask(lastRank: subTasks.last.rank);
                        }
                      },
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.add),
                      const SizedBox(width: 20),
                      Text(
                        'Add Sub-task',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(),
              InkWell(
                onTap: () async {
                  final dateTime = DateTime.now();
                  final datePicked = await showDatePicker(
                    context: context,
                    initialDate: task.dueDate,
                    firstDate: DateTime(dateTime.year - 2),
                    lastDate: DateTime(dateTime.year + 2),
                  );
                  if (datePicked != null) {
                    final dueDate = DateTime.utc(datePicked.year, datePicked.month, datePicked.day);
                    taskViewModel.updateTask(dueDate: dueDate);
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Text(
                        'Due Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    InfoWidget(label: task.stringDueDate()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
