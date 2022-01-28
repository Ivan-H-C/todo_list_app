import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/ui/categories/categories.dart';
import 'package:todo_list_app/ui/tasks/widget/categories_list.dart';
import 'package:todo_list_app/ui/tasks/widget/search_bar.dart';
import 'package:todo_list_app/ui/tasks/tasks_view_model.dart';

class TopBar extends ConsumerWidget {
  const TopBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksViewModel = ref.watch(tasksViewModelProvider.notifier);
    final searching = ref.watch(searchingProvider);

    return searching
        ? SearchBar(
            hintText: 'Search',
            onSearch: (query) => tasksViewModel.changeTextQuery(textQuery: query),
            onFinished: () {
              ref.read(searchingProvider.state).state = false;
              tasksViewModel.changeTextQuery(textQuery: '');
            },
          )
        : SizedBox(
            height: 60,
            child: Row(
              children: [
                const CategoriesList(),
                PopupMenuButton(
                  offset: const Offset(0, 40),
                  onSelected: (value) {
                    if (value == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CategoriesPage()),
                      );
                    } else if (value == 1) {
                      ref.read(searchingProvider.state).state = true;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 0,
                      child: Text('Categories Management'),
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Search'),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
