import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qalb/controller/monetization_controller.dart';
import 'package:qalb/util/dimensions.dart';
import 'package:qalb/util/styles.dart';

class PremiumDialog extends StatelessWidget {
  final String featureId;
  final Function() onUnlock;

  const PremiumDialog({super.key, required this.featureId, required this.onUnlock});

  static Future<void> checkAndShow({required String featureId, required Function() onUnlock}) async {
    final MonetizationController controller = Get.put(MonetizationController(), permanent: true);
    if (await controller.isFeatureUnlocked(featureId)) {
      onUnlock();
    } else {
      Get.dialog(
        PremiumDialog(
          featureId: featureId,
          onUnlock: () {
            Get.back(); // close dialog
            onUnlock(); // run feature
          },
        ),
        barrierDismissible: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final MonetizationController controller = Get.find<MonetizationController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE)),
      backgroundColor: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Icon(
              Icons.workspace_premium_outlined,
              size: 60,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            
            // Title
            Text(
              'Premium Feature'.tr,
              style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            
            // Subtitle
            Text(
              'Unlock this feature for 24 hours by watching a quick ad.'.tr,
              style: robotoMedium.copyWith(
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
            
            // Watch Ad Button
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE)),
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT),
                ),
                onPressed: controller.isAdLoading.value
                    ? null
                    : () {
                        controller.loadAndShowRewardedAd(featureId: featureId, onUnlock: onUnlock);
                      },
                icon: controller.isAdLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.play_circle_outline, color: Colors.white),
                label: Text(
                  'Watch Ad to Unlock'.tr,
                  style: robotoBold.copyWith(color: Colors.white),
                ),
              )),
            ),
            
          ],
        ),
      ),
    );
  }
}
