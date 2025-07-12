class Task {
  String id;
  String title;
  bool isDone;
  bool isImportant;
  bool isPlanned;
  String? subtitle;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    this.isImportant = false,
    this.isPlanned = false,
    this.subtitle,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'isImportant': isImportant,
      'isPlanned': isPlanned,
      'subtitle': subtitle,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] ?? false,
      isImportant: map['isImportant'] ?? false,
      isPlanned: map['isPlanned'] ?? false,
      subtitle: map['subtitle'],
    );
  }
}
