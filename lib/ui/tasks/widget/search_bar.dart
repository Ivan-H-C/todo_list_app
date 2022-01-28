import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.hintText,
    required this.onSearch,
    required this.onFinished,
  }) : super(key: key);

  final void Function(String query) onSearch;
  final void Function() onFinished;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onFinished,
          icon: const Icon(Icons.arrow_back),
        ),
        Expanded(
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: hintText),
            onChanged: onSearch,
          ),
        ),
      ],
    );
  }
}
