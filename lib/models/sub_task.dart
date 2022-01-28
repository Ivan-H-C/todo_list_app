class SubTask {
  final String id;
  final String title;
  final bool done;

  const SubTask({
    required this.id,
    required this.title,
    required this.done,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['id'],
      title: json['title'],
      done: json['complete'],
    );
  }

  SubTask copyWith({String? title, bool? done}) {
    return SubTask(
      id: id,
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'complete': done};
  }
}
