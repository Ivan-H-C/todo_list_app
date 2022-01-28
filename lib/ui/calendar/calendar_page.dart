import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_list_app/providers/providers.dart';
import 'package:todo_list_app/ui/calendar/calendar_view_model.dart';
import 'package:todo_list_app/ui/common_widgets/task_widget.dart';
import 'package:todo_list_app/ui/details/task_details_page.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarViewModel = ref.watch(calendarViewModelProvider);
    final tasks = calendarViewModel.tasks;
    final date = DateTime.now();
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime(date.year - 2),
          lastDay: DateTime(date.year + 2),
          focusedDay: calendarViewModel.focusedDay,
          calendarFormat: calendarViewModel.calendarFormat,
          selectedDayPredicate: (day) => isSameDay(calendarViewModel.selectedDay, day),
          eventLoader: calendarViewModel.fetchTaskFromDay,
          onDaySelected: (selectedDay, focusedDay) {
            calendarViewModel.selectedDay = selectedDay;
            calendarViewModel.focusedDay = focusedDay;
          },
          onFormatChanged: (format) => calendarViewModel.calendarFormat = format,
          onPageChanged: (focusedDay) => calendarViewModel.focusedDay = focusedDay,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskWidget(
                task: task,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailsPage(
                      currentTask: task,
                    ),
                  ),
                ),
                onChangedDoneValue: (value) =>
                    ref.read(tasksRepositoryProvider)?.updateTask(task.copyWith(done: value)),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemCount: tasks.length,
          ),
        ),
      ],
    );
  }
}
