class SubTask {
  final String id;
  final String rank;
  final String title;
  final bool done;

  const SubTask({
    required this.id,
    required this.rank,
    required this.title,
    required this.done,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['id'],
      rank: json['rank'],
      title: json['title'],
      done: json['complete'],
    );
  }

  SubTask copyWith({String? rank, String? title, bool? done}) {
    return SubTask(
      id: id,
      rank: rank ?? this.rank,
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rank': rank,
      'title': title,
      'complete': done,
    };
  }
}
