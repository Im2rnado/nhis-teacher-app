import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/behaviorCubit.dart';
import 'package:eschool_teacher/data/models/behavior.dart';
import 'package:eschool_teacher/data/repositories/behaviorRepository.dart';
import 'package:eschool_teacher/ui/widgets/customShimmerContainer.dart';
import 'package:eschool_teacher/ui/widgets/errorContainer.dart';
import 'package:eschool_teacher/ui/widgets/noDataContainer.dart';
import 'package:eschool_teacher/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BehaviorContainer extends StatelessWidget {
  final int? studentId;
  final String? studentName;
  final String teacherName;

  const BehaviorContainer(
      {Key? key, this.studentId, this.studentName, required this.teacherName})
      : super(key: key);

  Widget _buildBehaviorDetailsShimmerContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        child: LayoutBuilder(builder: (context, boxConstraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                margin: EdgeInsetsDirectional.only(
                    end: boxConstraints.maxWidth * (0.7)),
              )),
              SizedBox(
                height: 5,
              ),
              ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                margin: EdgeInsetsDirectional.only(
                    end: boxConstraints.maxWidth * (0.5)),
              )),
              SizedBox(
                height: 15,
              ),
              ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                margin: EdgeInsetsDirectional.only(
                    end: boxConstraints.maxWidth * (0.7)),
              )),
              SizedBox(
                height: 5,
              ),
              ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                margin: EdgeInsetsDirectional.only(
                    end: boxConstraints.maxWidth * (0.5)),
              )),
            ],
          );
        }),
        padding: EdgeInsets.symmetric(vertical: 15.0),
        width: MediaQuery.of(context).size.width * (0.85),
      ),
    );
  }

  Widget _buildBehaviorDetailsContainer(
      {required Behavior behavior, required BuildContext context}) {
    return BlocProvider<BehaviorCubit>(
      create: (context) => BehaviorCubit(BehaviorRepository()),
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Opacity(
            opacity: 1.0,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(UiUtils.getTranslatedLabel(context, behaviorTypeKey),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0),
                        textAlign: TextAlign.left),
                  ]),
                  SizedBox(
                    height: 2.5,
                  ),
                  Text(behavior.name,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                      UiUtils.getTranslatedLabel(
                          context, behaviorDescriptionKey),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0),
                      textAlign: TextAlign.left),
                  SizedBox(
                    height: 2.5,
                  ),
                  Text(behavior.description,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(10.0)),
              width: MediaQuery.of(context).size.width * (0.85),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BehaviorCubit, BehaviorState>(
      builder: (context, state) {
        if (state is BehaviorFetchSuccess) {
          return state.behavior.isEmpty
              ? NoDataContainer(titleKey: noBehaviorKey)
              : Column(
                  children: state.behavior
                      .map((behavior) => _buildBehaviorDetailsContainer(
                          behavior: behavior, context: context))
                      .toList(),
                );
        }
        if (state is BehaviorFetchFailure) {
          return Center(
            child: ErrorContainer(
              errorMessageCode: state.errorMessage,
              onTapRetry: () {
                context.read<BehaviorCubit>().fetchBehavior(
                    studentId: studentId, teacherName: teacherName);
              },
            ),
          );
        }
        return Column(
          children: List.generate(
                  UiUtils.defaultShimmerLoadingContentCount, (index) => index)
              .map((e) => _buildBehaviorDetailsShimmerContainer(context))
              .toList(),
        );
      },
    );
  }
}
