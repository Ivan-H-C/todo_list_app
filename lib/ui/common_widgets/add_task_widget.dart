import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/providers/providers.dart';
import 'package:todo_list_app/ui/common_widgets/categories.dart';
import 'package:todo_list_app/ui/common_widgets/save_category_widget.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({Key? key, required this.onAddTask}) : super(key: key);

  final void Function(
    String taskTitle,
    String category,
    DateTime? datePicked,
  ) onAddTask;

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final controller = TextEditingController();
  String _category = 'No Category';
  DateTime? datePicked = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            controller: controller,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'Input new task here',
              filled: true,
              fillColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CategoriesWidget(
                      offset: const Offset(0, -40),
                      selectedCategory: _category,
                      onSelected: (category) => setState(() => _category = category),
                      onCreateNew: () => showDialog(
                        context: context,
                        builder: (context) => Consumer(
                          builder: (context, ref, child) => SaveCategoryDialog(
                            onSave: (title) => ref.read(categoriesRepositoryProvider)!.saveCategory(title: title),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final dateTime = DateTime.now();
                        datePicked = await showDatePicker(
                          context: context,
                          initialDate: dateTime,
                          firstDate: DateTime(dateTime.year - 2),
                          lastDate: DateTime(dateTime.year + 2),
                        );
                      },
                      icon: const Icon(Icons.calendar_today),
                      iconSize: 15,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  widget.onAddTask(controller.text, _category, datePicked);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Icon(Icons.done),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
