import 'package:flutter/material.dart';
import 'package:todo_list_app/models/category.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    Key? key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  final TaskCategory category;
  final void Function() onEdit;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 15,
          width: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(category.color ?? 0xff2196f3),
          ),          
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(category.title),
        ),
        PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 0:
                onEdit();
                break;
              case 1:
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 0,
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 1,
              child: Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}
