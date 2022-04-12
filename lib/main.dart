import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger_app_with_riverpod/app.dart';
import 'package:logger_app_with_riverpod/controller/todo_list.dart';
import 'package:logger_app_with_riverpod/domain/todo.dart';
import 'package:logger_app_with_riverpod/utils/enum/todo_list_filter.dart';

/// Some keys used for testing
final addTodoKey = UniqueKey();
final activeFilterKey = UniqueKey();
final completedFilterKey = UniqueKey();
final allFilterKey = UniqueKey();

final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) {
  return TodoList(const [
    Todo(id: 'todo-0', description: 'hi'),
    Todo(id: 'todo-1', description: 'hello'),
    Todo(id: 'todo-2', description: 'bonjour'),
  ]);
});

final todoListFilter = StateProvider((_) => TodoListFilter.all);

final uncompletedTodosCount = Provider<int>((ref) {
  return ref.watch(todoListProvider).where((todo) => !todo.completed).length;
});

final filteredTodos = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoListFilter);
  final todos = ref.watch(todoListProvider);

  switch (filter) {
    case TodoListFilter.completed:
      return todos.where((todo) => todo.completed).toList();
    case TodoListFilter.active:
      return todos.where((todo) => !todo.completed).toList();
    case TodoListFilter.all:
      return todos;
  }
});

/// A provider which exposes the [Todo] displayed by a [TodoItem].
///
/// By retreiving the [Todo] through a provider instead of through its
/// constructor, this allows [TodoItem] to be instantiated using the `const` keyword.
///
/// This ensures that when we add/remove/edit todos, only what the
/// impacted widgets rebuilds, instead of the entire list of items.
final currentTodo = Provider<Todo>((ref) => throw UnimplementedError());

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
