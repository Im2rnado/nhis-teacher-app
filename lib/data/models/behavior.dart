class Behavior {
  int? id;
  String? name;
  String? description;
  int? studentId;
  String? teacherName;

  Behavior(
      {required this.id,
      required this.name,
      required this.description,
      required this.studentId,
      required this.teacherName});

  Behavior.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    studentId = json['student_id'] ?? 0;
    teacherName = json['teacher_name'] ?? "";
  }
}
