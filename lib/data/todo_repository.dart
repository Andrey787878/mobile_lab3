import '../models/todo.dart';

class TodoRepository {
  final List<Todo> _todos = [];

  List<Todo> get todos => List.unmodifiable(_todos);

  void add(Todo todo) {
    _todos.add(todo);
  }

  void remove(int id) {
    _todos.removeWhere((todo) => todo.id == id);
  }
}
