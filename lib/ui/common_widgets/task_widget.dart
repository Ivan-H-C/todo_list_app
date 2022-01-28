import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onChangedDoneValue,
  }) : super(key: key);

  final Task task;
  final void Function() onTap;
  final void Function(bool value) onChangedDoneValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Checkbox(
              value: task.done,
              onChanged: (value) {
                if (value != null) {
                  onChangedDoneValue(value);
                }
              },
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                textStyle: TextStyle(
                  color: task.done
                      ? Colors.grey
                      : task.dueDate.isBefore(DateTime.now())
                          ? Colors.red
                          : Colors.black,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      task.stringDueDate(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
