import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/models/category.dart';
import 'package:todo_list_app/repository/categories_repository.dart';

class FirestoreCategoriesRepo implements CategoriesRepository {
  FirestoreCategoriesRepo(this.uid) {
    _categoriesRef = FirebaseFirestore.instance.collection('users/$uid/categories').withConverter(
          fromFirestore: (snapshot, _) => TaskCategory.fromJson(snapshot.data()!),
          toFirestore: (category, _) => category.toJson(),
        );
  }

  final String uid;

  late final CollectionReference<TaskCategory> _categoriesRef;

  @override
  Future<void> saveCategory({String? id, required String title, int? color}) async {
    final categoryRef = _categoriesRef.doc(id);
    final category = TaskCategory(id: categoryRef.id, title: title, color: color);
    await categoryRef.set(category);
  }

  @override
  Future<void> deleteCategory(String id) => _categoriesRef.doc(id).delete();

  @override
  Stream<List<TaskCategory>> streamCategories() {
    final snapshots = _categoriesRef.snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
