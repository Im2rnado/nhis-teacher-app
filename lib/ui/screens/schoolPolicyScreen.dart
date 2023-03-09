import 'package:eschool_teacher/cubits/appSettingsCubit.dart';
import 'package:eschool_teacher/data/repositories/systemInfoRepository.dart';
import 'package:eschool_teacher/ui/widgets/appSettingsBlocBuilder.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchoolPolicyScreen extends StatefulWidget {
  const SchoolPolicyScreen({Key? key}) : super(key: key);

  @override
  State<SchoolPolicyScreen> createState() => _SchoolPolicyScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => BlocProvider<AppSettingsCubit>(
              create: (context) => AppSettingsCubit(SystemRepository()),
              child: SchoolPolicyScreen(),
            ));
  }
}

class _SchoolPolicyScreenState extends State<SchoolPolicyScreen> {
  final String schoolPolicyType = "school_policy";

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context
          .read<AppSettingsCubit>()
          .fetchAppSettings(type: schoolPolicyType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppSettingsBlocBuilder(
            appSettingsType: schoolPolicyType,
          ),
          CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, schoolPolicyKey))
        ],
      ),
    );
  }
}
