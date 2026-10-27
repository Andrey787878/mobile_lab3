import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../todo_state.dart';
import 'todo_form_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _state = TodoState();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openForm([Todo? todo]) async {
    FocusScope.of(context).unfocus();
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => TodoFormScreen(state: _state, todo: todo),
      ),
    );
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final todos = _state.visibleTodos;

    return Center(
      child: SizedBox(
        width: 480,
        child: Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                  sliver: SliverToBoxAdapter(child: _header()),
                ),
                if (todos.isEmpty)
                  SliverFillRemaining(hasScrollBody: false, child: _emptyList())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 104),
                    sliver: SliverList.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _todoCard(todos[index]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Добавить задачу',
            onPressed: () => _openForm(),
            child: const Icon(Icons.add, size: 30),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Мои задачи',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Активных задач: ${_state.activeCount}',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _state.query = value),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Поиск задач',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Очистить поиск',
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _state.query = '');
                    },
                    icon: const Icon(Icons.close, size: 20),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            for (final filter in TodoFilter.values)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: filter == TodoFilter.done ? 0 : 8,
                  ),
                  child: FilledButton(
                    onPressed: () => setState(() => _state.filter = filter),
                    style: FilledButton.styleFrom(
                      backgroundColor: _state.filter == filter
                          ? Colors.amber.shade700
                          : Colors.grey.shade900,
                      foregroundColor: _state.filter == filter
                          ? Colors.white
                          : Colors.grey.shade400,
                      minimumSize: const Size(0, 46),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        filter.label,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _todoCard(Todo todo) {
    final Color priorityColor;
    switch (todo.priority) {
      case TodoPriority.high:
        priorityColor = Colors.amber.shade700;
      case TodoPriority.medium:
        priorityColor = Colors.grey.shade300;
      case TodoPriority.low:
        priorityColor = Colors.grey;
    }

    return Material(
      key: ValueKey(todo.id),
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openForm(todo),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Tooltip(
                message: todo.isDone
                    ? 'Вернуть в активные'
                    : 'Выполнить задачу',
                child: Checkbox(
                  value: todo.isDone,
                  onChanged: (_) => setState(() => _state.toggle(todo)),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        color: todo.isDone ? Colors.grey : Colors.white,
                        fontSize: 17,
                        height: 1.4,
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          todo.dateText,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: priorityColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            todo.priority.label,
                            style: TextStyle(
                              color: priorityColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyList() {
    String title;
    String message;
    if (_state.todos.isEmpty) {
      title = 'Пока нет задач';
      message = 'Нажмите +, чтобы добавить первую';
    } else if (_state.query.trim().isNotEmpty) {
      title = 'Задачи не найдены';
      message = 'Попробуйте другой запрос или фильтр';
    } else if (_state.filter == TodoFilter.done) {
      title = 'Нет выполненных задач';
      message = 'Здесь появятся задачи с отметкой';
    } else {
      title = 'Нет активных задач';
      message = 'Все задачи выполнены';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 104),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _state.query.trim().isEmpty
                  ? Icons.checklist_rounded
                  : Icons.search_off_rounded,
              size: 44,
              color: Colors.grey.shade700,
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 19, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
