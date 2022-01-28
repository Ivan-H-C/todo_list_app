import 'package:todo_list_app/models/category.dart';

abstract class CategoriesRepository {
  Stream<List<TaskCategory>> streamCategories();

  Future<void> saveCategory({String? id, required String title, int? color});

  Future<void> deleteCategory(String id);
}
