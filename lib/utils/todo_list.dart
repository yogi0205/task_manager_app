import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.searchText,
    required this.onEdit,
  });

  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final String searchText;
  final Function(BuildContext)? onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 0,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                checkColor: Colors.black,
                activeColor: Colors.white,
                side: const BorderSide(color: Colors.white),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: _highlightOccurrences(taskName, searchText),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _highlightOccurrences(String text, String query) {
    if (query.isEmpty) {
      return [
        TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 18,
            decoration: taskCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: Colors.white,
          ),
        ),
      ];
    }

    final matches = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index < 0) {
        matches.add(TextSpan(
          text: text.substring(start),
          style: TextStyle(
            fontSize: 18,
            decoration: taskCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: Colors.white,
          ),
        ));
        break;
      }

      if (index > start) {
        matches.add(TextSpan(
          text: text.substring(start, index),
          style: TextStyle(
            fontSize: 18,
            decoration: taskCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: Colors.white,
          ),
        ));
      }

      matches.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color:Colors.yellow,
          decoration: taskCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ));

      start = index + query.length;
    }

    return matches;
  }
}
