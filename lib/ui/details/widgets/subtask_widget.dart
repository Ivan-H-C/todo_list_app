import 'package:flutter/material.dart';
import 'package:todo_list_app/models/sub_task.dart';

class SubTaskWidget extends StatefulWidget {
  const SubTaskWidget({
    Key? key,
    required this.subTask,
    required this.onCheck,
    required this.onChangeTitle,
  }) : super(key: key);

  final SubTask subTask;
  final void Function(bool done) onCheck;
  final void Function(String title) onChangeTitle;

  @override
  State<SubTaskWidget> createState() => _SubTaskWidgetState();
}

class _SubTaskWidgetState extends State<SubTaskWidget> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    controller.text = widget.subTask.title;
    if (controller.text.isEmpty) {
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.subTask.done,
          onChanged: (value) => widget.onCheck(value ?? false),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onSubmitted: widget.onChangeTitle,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            style: widget.subTask.done
                ? const TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  )
                : null,
          ),
        ),
        const Icon(Icons.drag_handle),
      ],
    );
  }
}
