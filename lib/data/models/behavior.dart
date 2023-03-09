class Behavior {
  Behavior(
      {required this.id,
      required this.name,
      required this.description,
      required this.studentId,
      required this.teacherName});

  late final int id;
  late final String name;
  late final String description;
  late final int studentId;
  late final String teacherName;

  Behavior.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    studentId = json['student_id'] ?? 0;
    teacherName = json['teacher_name'] ?? "";
  }
}
