import 'package:eschool_teacher/data/models/behavior.dart';
import 'package:eschool_teacher/data/repositories/behaviorRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BehaviorState {}

class BehaviorInitial extends BehaviorState {}

class BehaviorFetchInProgress extends BehaviorState {}

class BehaviorFetchSuccess extends BehaviorState {
  final List<Behavior> behavior;

  BehaviorFetchSuccess({required this.behavior});
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
    try {
      print('calling');
      emit(BehaviorFetchInProgress());
      var result = await _behaviorRepository.getBehavior(
          studentId: studentId, teacherName: teacherName);

      emit(BehaviorFetchSuccess(behavior: result));
    } catch (e) {
      emit(BehaviorFetchFailure(e.toString()));
    }
  }
}
