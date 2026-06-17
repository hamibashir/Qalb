import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qalb/controller/quran_settings_controller.dart';
import 'package:qalb/view/base/custom_app_bar.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';

class ZakatDetaile extends StatelessWidget {
  final bool appBackButton;
  const ZakatDetaile({super.key, required this.appBackButton});

  @override
  Widget build(BuildContext context) {
    Get.find<SettingsController>().fetchMosqueSettingsData();
    return Scaffold(
      appBar: CustomAppBar(
        title: "about_zakat".tr,
        isBackButtonExist: appBackButton == true ? true : false,
      ),
      body: GetBuilder<SettingsController>(
        builder: (settingsController) {
          if (settingsController.mosqueSettingsApiData == null ||
              settingsController.mosqueSettingsApiData!.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final String zakatDescription = settingsController
              .mosqueSettingsApiData!.data!.zakatDescription
              .toString();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.info_outline,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        zakatDescription,
                        textAlign: TextAlign.justify,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          height: 1.6, // Better line-height for readability
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
