class TaskList {
  final int? id;
  final String title;

  TaskList({this.id, required this.title});

  factory TaskList.fromMap(Map<String, Object?> m) =>
      TaskList(id: m['id'] as int?, title: m['title'] as String);

  Map<String, Object?> toMap() => {'id': id, 'title': title};
}

class Task {
  final int? id;
  final int listId;
  final String title;
  final String? description;
  final int? dueDate;
  final int priority;
  final String status;

  Task({
    this.id,
    required this.listId,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = 1,
    this.status = 'todo',
  });

  Task copyWith({
    int? id,
    int? listId,
    String? title,
    String? description,
    int? dueDate,
    int? priority,
    String? status,
  }) => Task(
    id: id ?? this.id,
    listId: listId ?? this.listId,
    title: title ?? this.title,
    description: description ?? this.description,
    dueDate: dueDate ?? this.dueDate,
    priority: priority ?? this.priority,
    status: status ?? this.status,
  );

  factory Task.fromMap(Map<String, Object?> m) => Task(
    id: m['id'] as int?,
    listId: m['listId'] as int,
    title: m['title'] as String,
    description: m['description'] as String?,
    dueDate: m['dueDate'] as int?,
    priority: m['priority'] as int? ?? 1,
    status: m['status'] as String? ?? 'todo',
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'listId': listId,
    'title': title,
    'description': description,
    'dueDate': dueDate,
    'priority': priority,
    'status': status,
  };
}
