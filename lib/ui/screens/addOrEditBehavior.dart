import 'package:eschool_teacher/cubits/createBehaviorCubit.dart';
import 'package:eschool_teacher/data/models/behavior.dart';
import 'package:eschool_teacher/data/repositories/behaviorRepository.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool_teacher/ui/widgets/customRoundedButton.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/bottomSheetTextFiledContainer.dart';

class AddOrEditBehaviorScreen extends StatefulWidget {
  final int? studentId;
  final String teacherName;
  final Behavior? behavior;

  AddOrEditBehaviorScreen(
      {Key? key, this.studentId, this.behavior, required this.teacherName})
      : super(key: key);

  static Route<bool?> route(RouteSettings routeSettings) {
    final arguments = (routeSettings.arguments ?? Map<String, dynamic>.from({}))
        as Map<String, dynamic>;

    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      CreateBehaviorCubit(BehaviorRepository()),
                ),
              ],
              child: AddOrEditBehaviorScreen(
                studentId: arguments['studentId'],
                behavior: arguments['behavior'],
                teacherName: arguments['teacherName'],
              ),
            ));
  }

  @override
  State<AddOrEditBehaviorScreen> createState() =>
      _AddOrEditBehaviorScreenState();
}

class _AddOrEditBehaviorScreenState extends State<AddOrEditBehaviorScreen> {
  late TextEditingController _behaviorNameTextEditingController =
      TextEditingController(
          text: widget.behavior != null ? widget.behavior!.name : null);
  late TextEditingController _behaviorDescriptionTextEditingController =
      TextEditingController(
          text: widget.behavior != null ? widget.behavior!.description : null);

  @override
  void initState() {
    super.initState();
  }

  void showErrorMessage(String errorMessageKey) {
    UiUtils.showBottomToastOverlay(
        context: context,
        errorMessage: errorMessageKey,
        backgroundColor: Theme.of(context).colorScheme.error);
  }

  void createBehavior() {
    //
    if (_behaviorNameTextEditingController.text.trim().isEmpty) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseEnterBehaviorNameKey));
      return;
    }

    if (_behaviorDescriptionTextEditingController.text.trim().isEmpty) {
      showErrorMessage(UiUtils.getTranslatedLabel(
          context, pleaseEnterBehaviorDescriptionKey));
      return;
    }

    context.read<CreateBehaviorCubit>().createBehavior(
        studentId: context.read<AddOrEditBehaviorScreen>().studentId,
        teacherName: context.read<AddOrEditBehaviorScreen>().teacherName,
        behaviorDescription:
            _behaviorDescriptionTextEditingController.text.trim(),
        behaviorName: _behaviorNameTextEditingController.text.trim());
  }

  Widget _buildAppbar() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(
          onPressBackButton: () {
            if (context.read<CreateBehaviorCubit>().state
                is CreateBehaviorInProgress) {
              return;
            }
            Navigator.of(context).pop(false);
          },
          title: UiUtils.getTranslatedLabel(context, addBehaviorKey)),
    );
  }

  Widget _buildAddOrEditBehaviorForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
          bottom: 25,
          right: UiUtils.screenContentHorizontalPaddingPercentage *
              MediaQuery.of(context).size.width,
          left: UiUtils.screenContentHorizontalPaddingPercentage *
              MediaQuery.of(context).size.width,
          top: UiUtils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage)),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Column(
          children: [
            BottomSheetTextFieldContainer(
                hintText: UiUtils.getTranslatedLabel(context, chapterNameKey),
                margin: EdgeInsets.only(bottom: 20),
                maxLines: 1,
                contentPadding: EdgeInsetsDirectional.only(start: 15),
                textEditingController: _behaviorNameTextEditingController),
            BottomSheetTextFieldContainer(
                margin: EdgeInsets.only(bottom: 20),
                hintText:
                    UiUtils.getTranslatedLabel(context, chapterDescriptionKey),
                maxLines: 3,
                contentPadding: EdgeInsetsDirectional.only(start: 15),
                textEditingController:
                    _behaviorDescriptionTextEditingController),
            SizedBox(
              height: 20,
            ),
            BlocConsumer<CreateBehaviorCubit, CreateBehaviorState>(
              listener: (context, state) {
                if (state is CreateBehaviorSuccess) {
                  _behaviorDescriptionTextEditingController.text = "";
                  _behaviorNameTextEditingController.text = "";
                  setState(() {});
                  UiUtils.showBottomToastOverlay(
                      context: context,
                      errorMessage:
                          UiUtils.getTranslatedLabel(context, behaviorAddedKey),
                      backgroundColor: Theme.of(context).colorScheme.onPrimary);
                } else if (state is CreateBehaviorFailure) {
                  UiUtils.showBottomToastOverlay(
                      context: context,
                      errorMessage: UiUtils.getErrorMessageFromErrorCode(
                          context, state.errorMessage),
                      backgroundColor: Theme.of(context).colorScheme.error);
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: boxConstraints.maxWidth * (0.25)),
                  child: CustomRoundedButton(
                      onTap: () {
                        //
                        if (state is CreateBehaviorInProgress) {
                          return;
                        }
                        createBehavior();
                      },
                      child: state is CreateBehaviorInProgress
                          ? CustomCircularProgressIndicator(
                              strokeWidth: 2,
                              widthAndHeight: 20,
                            )
                          : null,
                      height: 45,
                      widthPercentage: boxConstraints.maxWidth * (0.45),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      buttonTitle:
                          UiUtils.getTranslatedLabel(context, addBehaviorKey),
                      showBorder: false),
                );
              },
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (context.read<CreateBehaviorCubit>().state
            is CreateBehaviorInProgress) {
          return Future.value(false);
        }
        Navigator.of(context).pop(false);
        return Future.value(false);
      },
      child: Scaffold(
          body: Stack(
        children: [
          _buildAddOrEditBehaviorForm(),
          _buildAppbar(),
        ],
      )),
    );
  }
}
