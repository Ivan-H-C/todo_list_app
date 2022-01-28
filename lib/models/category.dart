class TaskCategory {
  final String id;
  final String title;
  final int? color;

  const TaskCategory({
    required this.id,
    required this.title,
    required this.color,
  });

  factory TaskCategory.fromJson(Map<String, dynamic> map) {
    return TaskCategory(
      id: map['id'],
      title: map['title'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'color': color,
    };
  }
}
