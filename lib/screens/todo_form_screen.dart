import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../todo_state.dart';

class TodoFormScreen extends StatefulWidget {
  const TodoFormScreen({super.key, required this.state, this.todo});

  final TodoState state;
  final Todo? todo;

  @override
  State<TodoFormScreen> createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _validationMode = AutovalidateMode.disabled;
  late final TextEditingController _titleController;
  late TodoPriority _priority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _priority = widget.todo?.priority ?? TodoPriority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _validationMode = AutovalidateMode.onUserInteraction);
      return;
    }
    final todo = widget.todo;
    if (todo == null) {
      widget.state.add(_titleController.text, _priority);
    } else {
      widget.state.update(todo, _titleController.text, _priority);
    }
    Navigator.pop(context);
  }

  Future<void> _delete() async {
    FocusScope.of(context).unfocus();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Удалить задачу?'),
        content: const Text('Задача будет удалена из списка.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    widget.state.remove(widget.todo!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;

    return Center(
      child: SizedBox(
        width: 480,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Назад',
              onPressed: () => Navigator.pop(context),
              icon: const Icon(CupertinoIcons.chevron_back, size: 22),
            ),
            titleSpacing: 0,
            title: Text(
              isEditing ? 'Редактирование задачи' : 'Новая задача',
              maxLines: 2,
              style: const TextStyle(fontSize: 20),
            ),
            actions: [
              if (isEditing)
                IconButton(
                  tooltip: 'Удалить задачу',
                  onPressed: _delete,
                  color: Colors.amber.shade700,
                  icon: const Icon(Icons.delete_outline),
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Form(
                key: _formKey,
                autovalidateMode: _validationMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Название задачи',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleController,
                      minLines: 2,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 18, height: 1.5),
                      decoration: const InputDecoration(
                        hintText: 'Что нужно сделать?',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Введите название задачи';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Приоритет',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final priority in TodoPriority.values)
                          ChoiceChip(
                            label: Text(priority.label),
                            selected: _priority == priority,
                            showCheckmark: false,
                            onSelected: (_) =>
                                setState(() => _priority = priority),
                            selectedColor: Colors.amber.shade700,
                            backgroundColor: Colors.grey.shade900,
                            labelStyle: TextStyle(
                              color: _priority == priority
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    FilledButton(
                      onPressed: _save,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          isEditing
                              ? 'Сохранить изменения'
                              : 'Сохранить задачу',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
