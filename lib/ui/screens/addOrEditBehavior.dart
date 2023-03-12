import 'package:eschool_teacher/cubits/createBehaviorCubit.dart';
import 'package:eschool_teacher/data/repositories/behaviorRepository.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool_teacher/ui/widgets/customRoundedButton.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eschool_teacher/ui/widgets/bottomSheetTextFiledContainer.dart';

class AddOrEditBehaviorScreen extends StatelessWidget {
  final int? studentId;
  final String teacherName;

  const AddOrEditBehaviorScreen(
      {Key? key, this.studentId, required this.teacherName})
      : super(key: key);

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;

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
                teacherName: arguments['teacherName'],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AddBehaviorContainer(
            studentId: studentId,
            teacherName: teacherName,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, addBehaviorKey),
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

class AddBehaviorContainer extends StatefulWidget {
  final int? studentId;
  final String? teacherName;

  const AddBehaviorContainer({Key? key, this.studentId, this.teacherName})
      : super(key: key);

  @override
  State<AddBehaviorContainer> createState() => _AddBehaviorContainerState();
}

class _AddBehaviorContainerState extends State<AddBehaviorContainer> {
  late TextEditingController _behaviorNameTextEditingController =
      TextEditingController(text: null);
  late TextEditingController _behaviorDescriptionTextEditingController =
      TextEditingController(text: null);

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: _buildAddOrEditBehaviorForm(),
    );
  }
}
