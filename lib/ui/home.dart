import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/providers/providers.dart';
import 'package:todo_list_app/ui/user/user_page.dart';
import 'package:todo_list_app/ui/calendar/calendar_page.dart';
import 'package:todo_list_app/ui/common_widgets/add_task_widget.dart';
import 'package:todo_list_app/ui/tasks/tasks_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final pages = const [
    TasksPage(),
    CalendarPage(),
    UserPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
      ),
      floatingActionButton: Visibility(
        visible: currentIndex != 2,
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              builder: (context) => Consumer(builder: (context, ref, child) {
                
                return AddTaskWidget(
                  onAddTask: (taskTitle, category, datePicked) {
                    final DateTime dueDate;
                    if (datePicked != null) {
                      dueDate = DateTime.utc(datePicked.year, datePicked.month, datePicked.day);
                    } else {
                      final date = DateTime.now();
                      dueDate = DateTime.utc(date.year, date.month, date.day);
                    }
                    ref.read(tasksRepositoryProvider)?.addTask(
                          title: taskTitle,
                          dueDate: dueDate,
                          category: category,
                        );
                    Navigator.pop(context);
                  },
                );
              }),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'User',
          )
        ],
      ),
    );
  }
}
