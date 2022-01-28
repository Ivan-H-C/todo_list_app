import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/providers/providers.dart';
import 'package:todo_list_app/ui/tasks/tasks_view_model.dart';

class CategoriesList extends ConsumerWidget {
  const CategoriesList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksViewModel = ref.watch(tasksViewModelProvider.notifier);

    final categoriesAsyncValue = ref.watch(categoriesProvider);
    final currentCategory = ref.watch(currentCategoryProvider);

    return Flexible(
      child: categoriesAsyncValue.when(
        data: (categories) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ChoiceChip(
                  label: const Text('All'),
                  selected: currentCategory == null,
                  onSelected: (_) => tasksViewModel.changeCategory(),
                );
              } else {
                final category = categories[index - 1];
                return ChoiceChip(
                  label: Text(category.title),
                  selected: category.title == currentCategory?.title,
                  onSelected: (selected) {
                    if (selected) {
                      tasksViewModel.changeCategory(category: category);
                    } else {
                      tasksViewModel.changeCategory();
                    }
                  },
                );
              }
            },
            separatorBuilder: (context, index) => const SizedBox(width: 10),
          );
        },
        error: (error, stack) {
          print(error);
          return const Center(child: Text('Something went wrong'));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
