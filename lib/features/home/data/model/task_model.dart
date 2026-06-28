class TaskModel {
  static const String collectionName = 'tasks';
  TaskModel({
    this.id,
    this.title,
    this.description,
    this.selectedDate,
    this.priorityIndex,
    this.isCompleted = false,
  });
  String? id;
  String? title;
  String? description;
  DateTime? selectedDate;
  int? priorityIndex;
  bool? isCompleted;
  Map<String, dynamic> toJoson() {
    final normalDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
    );
    return {
      'id': id,
      'title': title,
      'description': description,
      'selectedDate': normalDate.millisecondsSinceEpoch,
      'priorityIndex': priorityIndex,
      'isCompleted': isCompleted,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priorityIndex: json['priorityIndex'],
      selectedDate: DateTime.fromMillisecondsSinceEpoch(json['selectedDate']),
      isCompleted: json['isCompleted'] as bool?,
    );
  }
}
