import 'package:eschool_teacher/data/models/behavior.dart';
import 'package:eschool_teacher/utils/api.dart';

class BehaviorRepository {
  Future<void> createBehavior(
      {required String behaviorName,
      required String behaviorDescription,
      required int? studentId,
      required String teacherName}) async {
    try {
      Map<String, dynamic> body = {
        "student_id": studentId,
        "teacher_name": teacherName,
        "name": behaviorName,
        "description": behaviorDescription
      };
      await Api.post(body: body, url: Api.createBehavior, useAuthToken: true);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<Behavior>> getBehavior(
      {required int? studentId, required String? teacherName}) async {
    try {
      Map<String, dynamic> queryParameters = {
        'student_id': studentId,
        'teacher_name': teacherName
      };

      final result = await Api.get(
          url: Api.getBehavior,
          useAuthToken: true,
          queryParameters: queryParameters);

      return ((result['data'] ?? []) as List)
          .map((behavior) => Behavior.fromJson(Map.from(behavior)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
