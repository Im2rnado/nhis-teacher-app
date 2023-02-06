import 'package:eschool_teacher/utils/labelKeys.dart';

final String schoolName = "New Horizon";

final String schoolTagLine = "New Horizon International School";

final String androidAppPackageName = "com.bedro.nhis";
final String iosAppPackageName = "com.bedro.nhis";

//database urls
//Please add your admin panel url here and make sure you do not add '/' at the end of the url
const String baseUrl =
    "https://nhis-admin.com"; //https://testschool.wrteam.in
const String databaseUrl = "$baseUrl/api/";

//error message display duration
const Duration errorMessageDisplayDuration = Duration(milliseconds: 3000);

String getExamStatusTypeKey(String examStatus) {
  if (examStatus == "0") {
    return upComingKey;
  }
  if (examStatus == "1") {
    return onGoingKey;
  }
  return completedKey;
}

List<String> examFilters = [allExamsKey, upComingKey, onGoingKey, completedKey];
