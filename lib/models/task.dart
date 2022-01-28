class Task {
  final String id;
  final String title;
  final DateTime dueDate;
  final String notes;
  final String? category;
  final bool done;

  const Task({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.notes,
    required this.category,
    required this.done,
  });

  factory Task.fromJson(Map<String, dynamic> map) {
    final date = DateTime.now();
    final alternativeDueDate = DateTime.utc(date.year, date.month, date.day);
    return Task(
      id: map['id'],
      title: map['title'],
      dueDate: map['dueDate']?.toDate().toUtc() ?? alternativeDueDate,
      notes: map['notes'] ?? '',
      category: map['category'],
      done: map['done'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate,
      'notes': notes,
      'category': category,
      'done': done,
    };
  }

  Task copyWith({
    String? title,
    DateTime? dueDate,
    String? notes,
    String? category,
    bool? done,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      done: done ?? this.done,
    );
  }

  String stringDueDate() {
    var dateString = dueDate.toString().split(' ')[0];
    var elements = dateString.split('-');
    return elements[2] + '/' + elements[1] + '/' + elements[0];
  }
}
