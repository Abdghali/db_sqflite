class Task {
  int? id;
  String? taskName;
  int? isDone;

  Task({this.id, this.taskName, this.isDone});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskName = json['task_name'];
    isDone = json['isDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_name'] = this.taskName;
    data['isDone'] = this.isDone;
    return data;
  }
}