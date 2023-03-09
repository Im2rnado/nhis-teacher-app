import 'package:eschool_teacher/data/repositories/behaviorRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CreateBehaviorState {}

class CreateBehaviorInitial extends CreateBehaviorState {}

class CreateBehaviorInProgress extends CreateBehaviorState {}

class CreateBehaviorSuccess extends CreateBehaviorState {}

class CreateBehaviorFailure extends CreateBehaviorState {
  final String errorMessage;

  CreateBehaviorFailure(this.errorMessage);
}

class CreateBehaviorCubit extends Cubit<CreateBehaviorState> {
  final BehaviorRepository _behaviorRepository;

  CreateBehaviorCubit(this._behaviorRepository)
      : super(CreateBehaviorInitial());

  void createBehavior(
      {required String behaviorName,
      required int? studentId,
      required String teacherName,
      required String behaviorDescription}) async {
    emit(CreateBehaviorInProgress());
    try {
      await _behaviorRepository.createBehavior(
          behaviorName: behaviorName,
          studentId: studentId,
          teacherName: teacherName,
          behaviorDescription: behaviorDescription);
      emit(CreateBehaviorSuccess());
    } catch (e) {
      print(e.toString());
      emit(CreateBehaviorFailure(e.toString()));
    }
  }
}
