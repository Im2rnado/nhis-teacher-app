import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/behaviorCubit.dart';
import 'package:eschool_teacher/data/repositories/behaviorRepository.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customFloatingActionButton.dart';
import 'package:eschool_teacher/ui/widgets/customRefreshIndicator.dart';
import 'package:eschool_teacher/ui/widgets/behaviorContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BehaviorScreen extends StatefulWidget {
  final int? studentId;
  final String? studentName;
  final String teacherName;

  const BehaviorScreen(
      {Key? key, this.studentId, this.studentName, required this.teacherName})
      : super(key: key);

  static Route route(RouteSettings routeSettings) {
    final studentData = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<BehaviorCubit>(
                    create: (context) => BehaviorCubit(BehaviorRepository()),
                  ),
                ],
                child: BehaviorScreen(
                  studentId: studentData['studentId'],
                  studentName: studentData['studentName'],
                  teacherName: studentData['teacherName'],
                )));
  }

  @override
  State<BehaviorScreen> createState() => _BehaviorScreenState();
}

class _BehaviorScreenState extends State<BehaviorScreen> {
  @override
  void initState() {
    context.read<BehaviorCubit>().fetchBehavior(
          studentId: context.read<BehaviorScreen>().studentId,
          teacherName: context.read<BehaviorScreen>().teacherName,
        );
    super.initState();
  }

  void fetchBehavior() {
    context.read<BehaviorCubit>().fetchBehavior(
          studentId: context.read<BehaviorScreen>().studentId,
          teacherName: context.read<BehaviorScreen>().teacherName,
        );
  }

  Widget _buildAppbar() {
    return Align(
      alignment: Alignment.topCenter,
      child:
          CustomAppBar(title: UiUtils.getTranslatedLabel(context, behaviorKey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionAddButton(onTap: () {
          Navigator.of(context).pushNamed(Routes.addOrEditBehavior);
        }),
        body: Stack(
          children: [
            CustomRefreshIndicator(
              displacment: UiUtils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage:
                      UiUtils.appBarSmallerHeightPercentage),
              onRefreshCallback: () {
                fetchBehavior();
              },
              child: ListView(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width *
                        UiUtils.screenContentHorizontalPaddingPercentage,
                    right: MediaQuery.of(context).size.width *
                        UiUtils.screenContentHorizontalPaddingPercentage,
                    top: UiUtils.getScrollViewTopPadding(
                        context: context,
                        appBarHeightPercentage:
                            UiUtils.appBarSmallerHeightPercentage)),
                children: [
                  BehaviorContainer(
                    key: context.read<BehaviorScreen>().key,
                    studentId: context.read<BehaviorScreen>().studentId,
                    studentName: context.read<BehaviorScreen>().studentName,
                    teacherName: context.read<BehaviorScreen>().teacherName,
                  )
                ],
              ),
            ),
            _buildAppbar()
          ],
        ));
  }
}
