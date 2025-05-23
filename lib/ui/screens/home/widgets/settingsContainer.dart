import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/appConfigurationCubit.dart';
import 'package:eschool_teacher/cubits/appLocalizationCubit.dart';
import 'package:eschool_teacher/cubits/changePasswordCubit.dart';
import 'package:eschool_teacher/data/repositories/authRepository.dart';
import 'package:eschool_teacher/ui/screens/home/widgets/changeLanguageBottomsheetContainer.dart';
import 'package:eschool_teacher/ui/screens/home/widgets/changePasswordBottomsheet.dart';
import 'package:eschool_teacher/ui/screens/home/widgets/logoutButton.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/utils/appLanguages.dart';
import 'package:eschool_teacher/utils/errorMessageKeysAndCodes.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({Key? key}) : super(key: key);

  void _shareApp(BuildContext context) async {
    final appUrl = context.read<AppConfigurationCubit>().getAppLink();
    if (await canLaunchUrl(Uri.parse(appUrl))) {
      launchUrl(Uri.parse(appUrl));
    } else {
      UiUtils.showBottomToastOverlay(
          context: context,
          errorMessage: UiUtils.getTranslatedLabel(
              context, ErrorMessageKeysAndCode.defaultErrorMessageKey),
          backgroundColor: Theme.of(context).colorScheme.error);
    }
  }

  Widget _buildAppbar(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(
          showBackButton: false,
          title: UiUtils.getTranslatedLabel(context, settingKey)),
    );
  }

  Widget _buildMoreSettingDetailsTile(
      {required String title,
      required Function onTap,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: DecoratedBox(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.transparent)),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.8),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w400),
              ),
              Spacer(),
              Icon(
                Icons.chevron_right,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreSettingsContainer(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 15,
              width: 15,
              child: SvgPicture.asset(
                UiUtils.getImagePath("more_icon.svg"),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * (0.05),
            ),
            Text(
              UiUtils.getTranslatedLabel(context, moreKey),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        ),
        SizedBox(
          height: 10,
        ),
        _buildMoreSettingDetailsTile(
            title: UiUtils.getTranslatedLabel(context, changePasswordKey),
            onTap: () {
              if (UiUtils.isDemoVersionEnable()) {
                UiUtils.showFeatureDisableInDemoVersion(context);
                return;
              }
              UiUtils.showBottomSheet(
                      child: BlocProvider<ChangePasswordCubit>(
                        create: (_) => ChangePasswordCubit(AuthRepository()),
                        child: ChangePasswordBottomsheet(),
                      ),
                      context: context)
                  .then((value) {
                if (value != null && !value['error']) {
                  UiUtils.showBottomToastOverlay(
                      context: context,
                      errorMessage: UiUtils.getTranslatedLabel(
                          context, passwordChangedSuccessfullyKey),
                      backgroundColor: Theme.of(context).colorScheme.onPrimary);
                }
              });
            },
            context: context),
        _buildMoreSettingDetailsTile(
            title: UiUtils.getTranslatedLabel(context, privacyPolicyKey),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.privacyPolicy);
            },
            context: context),
        _buildMoreSettingDetailsTile(
            title: UiUtils.getTranslatedLabel(context, schoolPolicyKey),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.schoolPolicy);
            },
            context: context),
        _buildMoreSettingDetailsTile(
            title: UiUtils.getTranslatedLabel(context, termsAndConditionKey),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.termsAndCondition);
            },
            context: context),
        _buildMoreSettingDetailsTile(
            title: UiUtils.getTranslatedLabel(context, aboutUsKey),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.aboutUs);
            },
            context: context),
        _buildMoreSettingDetailsTile(
            title: UiUtils.getTranslatedLabel(context, contactUsKey),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.contactUs);
            },
            context: context),
        _buildMoreSettingDetailsTile(
            title: UiUtils.getTranslatedLabel(context, rateUsKey),
            onTap: () {
              _shareApp(context);
            },
            context: context),
        _buildMoreSettingDetailsTile(
            title: UiUtils.getTranslatedLabel(context, shareKey),
            onTap: () {
              _shareApp(context);
            },
            context: context),
      ],
    );
  }

  Widget _buildLanguageContainer(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                UiUtils.getImagePath("language.svg"),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * (0.05),
            ),
            Text(
              UiUtils.getTranslatedLabel(context, appLanguageKey),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        ),
        GestureDetector(
          onTap: () {
            UiUtils.showBottomSheet(
                child: ChangeLanguageBottomsheetContainer(), context: context);
          },
          child: Row(
            children: [
              BlocBuilder<AppLocalizationCubit, AppLocalizationState>(
                builder: (context, state) {
                  final String languageName = appLanguages
                      .where((element) =>
                          element.languageCode == state.language.languageCode)
                      .toList()
                      .first
                      .languageName;
                  return Text(
                    languageName,
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                        fontSize: 13.0),
                  );
                },
              ),
              Spacer(),
              Icon(
                Icons.chevron_right,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildLanguageContainer(context),
                  _buildMoreSettingsContainer(context),
                  SizedBox(
                    height: 20.0,
                  ),
                  LogoutButton(),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                      "${UiUtils.getTranslatedLabel(context, appVersionKey)}  ${context.read<AppConfigurationCubit>().getAppVersion()}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.0),
                      textAlign: TextAlign.start),
                ],
              ),
              padding: EdgeInsetsDirectional.only(
                  bottom: UiUtils.getScrollViewBottomPadding(context),
                  start: MediaQuery.of(context).size.width * (0.075),
                  end: MediaQuery.of(context).size.width * (0.075),
                  top: UiUtils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          UiUtils.appBarSmallerHeightPercentage))),
        ),
        _buildAppbar(context),
      ],
    );
  }
}
