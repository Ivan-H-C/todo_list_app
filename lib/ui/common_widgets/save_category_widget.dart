import 'package:flutter/material.dart';
import 'package:todo_list_app/models/category.dart';

class SaveCategoryDialog extends StatefulWidget {
  const SaveCategoryDialog({
    Key? key,
    this.category,
    required this.onSave,
  }) : super(key: key);

  final TaskCategory? category;
  final void Function(String title) onSave;

  @override
  _SaveCategoryDialogState createState() => _SaveCategoryDialogState();
}

class _SaveCategoryDialogState extends State<SaveCategoryDialog> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      controller.text = widget.category!.title;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Create a new category'),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      children: [
        TextField(
          controller: controller,
          maxLength: 50,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Enter here',
            border: InputBorder.none,
            filled: true,
            fillColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onSave(controller.text);
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
