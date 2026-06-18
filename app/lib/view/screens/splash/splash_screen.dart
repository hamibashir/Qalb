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
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 1500),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.easeOutQuint,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: 0.5 + (value * 0.5), // Scales from 0.5 to 1.0
              child: Opacity(
                opacity: value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // logo image
                    Image.asset(
                      Get.isDarkMode ? Images.Dark_APP_LOGO : Images.Light_APP_LOGO,
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    // app name
                    Text(
                      AppConstants.APP_NAME,
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                        color: Colors.black87,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
