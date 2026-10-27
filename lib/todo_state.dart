import 'data/todo_repository.dart';
import 'models/todo.dart';

enum TodoFilter {
  all('Все'),
  active('Активные'),
  done('Выполненные');

  const TodoFilter(this.label);

  final String label;
}

class TodoState {
  final _repository = TodoRepository();
  int _nextId = 1;

  String query = '';
  TodoFilter filter = TodoFilter.all;

  List<Todo> get todos => _repository.todos;

  int get activeCount => todos.where((todo) => !todo.isDone).length;

  List<Todo> get visibleTodos {
    final search = query.trim().toLowerCase();
    return todos.where((todo) {
      if (filter == TodoFilter.active && todo.isDone) return false;
      if (filter == TodoFilter.done && !todo.isDone) return false;
      return todo.title.toLowerCase().contains(search);
    }).toList();
  }

  void add(String title, TodoPriority priority) {
    final name = title.trim();
    if (name.isEmpty) return;
    _repository.add(
      Todo(
        id: _nextId++,
        title: name,
        priority: priority,
        createdAt: DateTime.now(),
      ),
    );
  }

  void update(Todo todo, String title, TodoPriority priority) {
    final name = title.trim();
    if (name.isEmpty) return;
    todo.title = name;
    todo.priority = priority;
  }

  void toggle(Todo todo) {
    todo.isDone = !todo.isDone;
  }

  void remove(Todo todo) {
    _repository.remove(todo.id);
  }
}
