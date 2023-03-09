import 'package:eschool_teacher/data/models/behavior.dart';
import 'package:eschool_teacher/data/repositories/behaviorRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BehaviorState {}

class BehaviorInitial extends BehaviorState {}

class BehaviorFetchInProgress extends BehaviorState {}

class BehaviorFetchSuccess extends BehaviorState {
  final List<Behavior> behavior;

  BehaviorFetchSuccess(this.behavior);
}

class BehaviorFetchFailure extends BehaviorState {
  final String errorMessage;

  BehaviorFetchFailure(this.errorMessage);
}

class BehaviorCubit extends Cubit<BehaviorState> {
  final BehaviorRepository _behaviorRepository;

  BehaviorCubit(this._behaviorRepository) : super(BehaviorInitial());

  void fetchBehavior(
      {required int? studentId, required String? teacherName}) async {
    emit(BehaviorFetchInProgress());
    try {
      emit(BehaviorFetchSuccess(await _behaviorRepository.getBehavior(
          studentId: studentId, teacherName: teacherName)));
    } catch (e) {
      emit(BehaviorFetchFailure(e.toString()));
    }
  }

  void updateState(BehaviorState updatedState) {
    emit(updatedState);
  }
}
