import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qalb/theme/light_theme.dart';
import 'package:qalb/util/app_constants.dart';
import 'controller/localization_controller.dart';
import 'controller/theme_controller.dart';
import 'helper/audio_service_helper.dart';
import 'helper/get_di.dart' as di;
import 'helper/route_helper.dart';
import 'theme/dark_theme.dart';
import 'util/messages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await di.init();
  // Initialize the AudioHandler
  await AudioServiceHelper.init();
  Map<String, Map<String, String>> languages = await di.init();
  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return GetMaterialApp(
              title: AppConstants.APP_NAME,
              debugShowCheckedModeBanner: false,
              navigatorKey: Get.key,
              theme: themeController.darkTheme ? dark : light,
              locale: localizeController.locale,
              initialRoute: RouteHelper.initial,
              getPages: RouteHelper.routes,
              defaultTransition: Transition.topLevel,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
                  AppConstants.languages[0].countryCode),
              transitionDuration: const Duration(milliseconds: 500),
            );
          },
        );
      },
    );
  }
}
