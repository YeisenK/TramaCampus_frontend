enum TaskStatus { todo, inProgress, done }

enum TaskPriority { low, med, high }

extension TaskStatusLabel on TaskStatus {
  String get label => switch (this) {
    TaskStatus.todo => 'Pendiente',
    TaskStatus.inProgress => 'En progreso',
    TaskStatus.done => 'Completada',
  };
}

class Task {
  const Task({
    required this.id,
    required this.code,
    required this.title,
    required this.status,
    required this.assigneeName,
    required this.due,
    required this.priority,
  });

  final String id;
  final String code;
  final String title;
  final TaskStatus status;
  final String assigneeName;
  final String due;
  final TaskPriority priority;
}
