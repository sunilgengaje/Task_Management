class Task {
  final int id;
  String title;
  String description;
  bool isCompleted;
  DateTime? dueDate;
  String priority;

  // Constructor
  Task({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    this.priority = 'High', // Default priority
    this.isCompleted = false,
  });

  // Convert Task to JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(), // Convert to string if not null
      'priority': priority,
    };
  }

  // Convert JSON (Map<String, dynamic>) to Task
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : null, // Convert back to DateTime if not null
      priority: json['priority'] ?? 'High',
    );
  }
}
