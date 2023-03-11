import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/behaviorCubit.dart';
import 'package:eschool_teacher/cubits/createBehaviorCubit.dart';
import 'package:eschool_teacher/data/repositories/behaviorRepository.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/behaviorContainer.dart';
import 'package:eschool_teacher/ui/widgets/customFloatingActionButton.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BehaviorScreen extends StatelessWidget {
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
                  BlocProvider<CreateBehaviorCubit>(
                    create: (context) =>
                        CreateBehaviorCubit(BehaviorRepository()),
                  ),
                ],
                child: BehaviorScreen(
                  studentId: studentData['studentId'],
                  studentName: studentData['studentName'],
                  teacherName: studentData['teacherName'],
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionAddButton(onTap: () {
        Navigator.of(context).pushNamed(Routes.addOrEditBehavior, arguments: {
          studentId: studentId,
          teacherName: teacherName,
        });
      }),
      body: Stack(
        children: [
          BehaviorContainer(
            studentId: studentId,
            studentName: studentName,
            teacherName: teacherName,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, behaviorKey),
              subTitle: "${studentName} - ${teacherName}",
              showBackButton: true,
              onPressBackButton: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
