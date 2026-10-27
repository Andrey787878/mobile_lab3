enum TodoPriority {
  high('Высокий'),
  medium('Средний'),
  low('Низкий');

  const TodoPriority(this.label);

  final String label;
}

class Todo {
  Todo({
    required this.id,
    required this.title,
    required this.priority,
    required this.createdAt,
    this.isDone = false,
  });

  final int id;
  String title;
  TodoPriority priority;
  final DateTime createdAt;
  bool isDone;

  String get dateText {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    return '$day.$month.${createdAt.year}';
  }
}
