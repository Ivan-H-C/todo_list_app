import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/providers/providers.dart';

final calendarViewModelProvider = ChangeNotifierProvider.autoDispose<CalendarViewModel>(
  (ref) {
    final tasks = ref.watch(tasksProvider).asData?.value ?? [];
    return CalendarViewModel(tasks);
  },
);

class CalendarViewModel extends ChangeNotifier {
  CalendarViewModel(this._tasks);

  final List<Task> _tasks;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;

  CalendarFormat get calendarFormat => _calendarFormat;

  List<Task> get tasks {
    return fetchTaskFromDay(_selectedDay);
  }

  set selectedDay(DateTime selectedDay) {
    _selectedDay = selectedDay;
    notifyListeners();
  }

  set focusedDay(DateTime focusedDay) {
    _focusedDay = focusedDay;
    notifyListeners();
  }

  set calendarFormat(CalendarFormat calendarFormat) {
    _calendarFormat = calendarFormat;
    notifyListeners();
  }

  List<Task> fetchTaskFromDay(DateTime day) {
    return _tasks.where((task) => task.dueDate == day).toList();
  }
}
