class Task {
  final String? id;
  final String title;
  final String description;
  final String status;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.status = 'To Do',
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'To Do',
    );
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "description": description, "status": status};
  }
}
