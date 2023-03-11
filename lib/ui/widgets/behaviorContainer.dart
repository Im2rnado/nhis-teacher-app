import 'package:eschool_teacher/cubits/behaviorCubit.dart';
import 'package:eschool_teacher/data/models/behavior.dart';
import 'package:eschool_teacher/data/repositories/behaviorRepository.dart';
import 'package:eschool_teacher/ui/widgets/customRefreshIndicator.dart';
import 'package:eschool_teacher/ui/widgets/customShimmerContainer.dart';
import 'package:eschool_teacher/ui/widgets/errorContainer.dart';
import 'package:eschool_teacher/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';

import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BehaviorContainer extends StatefulWidget {
  final int? studentId;
  final String? studentName;
  final String? teacherName;

  const BehaviorContainer(
      {Key? key, this.studentId, this.studentName, this.teacherName})
      : super(key: key);

  @override
  State<BehaviorContainer> createState() => _BehaviorContainerState();
}

class _BehaviorContainerState extends State<BehaviorContainer> {
  void fetchBehavior() {
    context.read<BehaviorCubit>().fetchBehavior(
          studentId: widget.studentId!,
          teacherName: widget.teacherName!,
        );
  }

  Widget _buildBehaviorShimmerLoadingContainer() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 20,
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
          horizontal: UiUtils.screenContentHorizontalPaddingPercentage *
              MediaQuery.of(context).size.width),
      child: ShimmerLoadingContainer(
        child: LayoutBuilder(builder: (context, boxConstraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.teacherName!),
              ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                height: 9,
                width: boxConstraints.maxWidth * (0.3),
              )),
              SizedBox(
                height: boxConstraints.maxWidth * (0.02),
              ),
              ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                height: 10,
                width: boxConstraints.maxWidth * (0.8),
              )),
              SizedBox(
                height: boxConstraints.maxWidth * (0.1),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBehaviorLoading() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: UiUtils.appBarMediumtHeightPercentage *
                  MediaQuery.of(context).size.height,
              right: 20.0,
              left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(UiUtils.defaultShimmerLoadingContentCount,
                (index) => _buildBehaviorShimmerLoadingContainer()),
          ),
        ),
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
                  Text(behavior.name ?? "",
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
                  Text(behavior.description ?? "",
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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) => fetchBehavior());
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: CustomRefreshIndicator(
          onRefreshCallback: () {
            fetchBehavior();
          },
          displacment: UiUtils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage),
          child: BlocBuilder<BehaviorCubit, BehaviorState>(
            builder: (context, state) {
              if (state is BehaviorFetchFailure) {
                return Center(
                  child: ErrorContainer(
                    errorMessageCode: state.errorMessage,
                    onTapRetry: () {
                      fetchBehavior();
                    },
                  ),
                );
              } else if (state is BehaviorFetchSuccess) {
                return ListView.builder(
                  padding: EdgeInsets.only(
                      top: UiUtils.getScrollViewTopPadding(
                          context: context,
                          appBarHeightPercentage:
                              UiUtils.appBarSmallerHeightPercentage)),
                  itemCount: state.behavior.length,
                  itemBuilder: (context, index) {
                    Behavior behaviorData = state.behavior[index];
                    return _buildBehaviorDetailsContainer(
                        behavior: behaviorData, context: context);
                  },
                );
              }
              return _buildBehaviorLoading();
            },
          ),
        ));
  }
}
