import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/providers/providers.dart';

class CategoriesWidget extends ConsumerWidget {
  const CategoriesWidget({
    Key? key,
    required this.offset,
    required this.selectedCategory,
    required this.onSelected,
    required this.onCreateNew,
  }) : super(key: key);

  final Offset offset;
  final String selectedCategory;
  final void Function(String category) onSelected;
  final void Function() onCreateNew;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    return categoriesAsyncValue.when(
      data: (categories) => PopupMenuButton(
        offset: offset,
        onSelected: (value) {
          if (value == 0) {
            onCreateNew();
          } else {
            onSelected(value as String);
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'No Category',
            child: Text('No Category'),
          ),
          ...categories.map(
            (category) => PopupMenuItem(
              value: category.title,
              child: Text(category.title),
            ),
          ),
          PopupMenuItem(
            value: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [Icon(Icons.add), Text('Create New')],
            ),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(selectedCategory),
        ),
      ),
      error: (error, stack) => const Text('??'),
      loading: () => Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(selectedCategory),
        ),
    );
  }
}
