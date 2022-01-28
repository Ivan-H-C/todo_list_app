import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/providers/providers.dart';
import 'package:todo_list_app/ui/categories/category_widget.dart';
import 'package:todo_list_app/ui/common_widgets/save_category_widget.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  void _saveCategory({required WidgetRef ref,String? id, required String title}) {
    ref.read(categoriesRepositoryProvider)!.saveCategory(id: id, title: title);
  }

  void _deleteCategory({required WidgetRef ref, required String id}) {
    ref.read(categoriesRepositoryProvider)!.deleteCategory(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories Management'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Flexible(
            child: categoriesAsyncValue.when(
              data: (categories) => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryWidget(
                    category: category,
                    onEdit: () {
                      showDialog(
                        context: context,
                        builder: (context) => SaveCategoryDialog(
                          category: category,
                          onSave: (title) => _saveCategory(ref: ref, id: category.id, title: title)
                        ),
                      );
                    },
                    onDelete: () => _deleteCategory(ref: ref, id: category.id),
                  );
                },
              ),
              error: (error, stack) {
                print(error);
                return const Center(child: Text('Something went wrong'));
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SaveCategoryDialog(
                  onSave: (title) => _saveCategory(ref: ref, title: title),
                ),
              );
            },
            child: Row(
              children: const [
                SizedBox(width: 20),
                Icon(Icons.add),
                SizedBox(width: 20),
                Text(
                  'Create new',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
