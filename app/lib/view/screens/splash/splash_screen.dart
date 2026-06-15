import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qalb/controller/package_prayer_time_controller.dart';
import 'package:qalb/controller/splash_controller.dart';
import 'package:qalb/util/app_constants.dart';
import 'package:qalb/util/dimensions.dart';
import 'package:qalb/util/images.dart';
import 'package:qalb/util/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // _checkNotificationPermission();
  }

  // Future<void> _checkNotificationPermission() async {
  //   if (Platform.isAndroid || Platform.isIOS) {
  //     var status = await Permission.notification.status;
  //     if (!status.isGranted) {
  //       await Permission.notification.request();
  //     }
  //   }

  // }

  @override
  Widget build(BuildContext context) {
    Get.find<PrayerTimeController>().getLocation();
    Get.find<SplashController>().navigator();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // logo image
            Image.asset(
              Get.isDarkMode ? Images.Dark_APP_LOGO : Images.Light_APP_LOGO,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            // app name
            Text(
              AppConstants.APP_NAME,
              style: robotoMedium.copyWith(
                fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
