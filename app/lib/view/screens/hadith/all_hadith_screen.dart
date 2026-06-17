// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qalb/shimmer/all_shimmer_loder.dart';
import 'package:qalb/view/base/custom_app_bar.dart';

import '../../../controller/hadith_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';

class AllHadithScreen extends StatefulWidget {
  final bool appBackButton;
  const AllHadithScreen({super.key, required this.appBackButton});

  @override
  State<AllHadithScreen> createState() => _AllHadithScreenState();
}

class _AllHadithScreenState extends State<AllHadithScreen> {
  HadithController hadithController = Get.put(HadithController());
  @override
  void initState() {
    hadithController.getAllHadithData(Get.arguments[1], Get.arguments[2]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar start ===>
      appBar: CustomAppBar(
        title: "${Get.arguments[0]} ${"hadith".tr}",
        isBackButtonExist: widget.appBackButton == true ? true : false,
      ),

      // body start ===>
      body: GetBuilder<HadithController>(
        builder: (_) {
          if (hadithController.isLoadingHadith.value) {
            return const Center(child: HadisChapterShimmer());
          }
          if (hadithController.hadithModel == null || 
              hadithController.hadithModel!.hadiths == null || 
              hadithController.hadithModel!.hadiths!.data == null ||
              hadithController.hadithModel!.hadiths!.data!.isEmpty) {
            return Center(child: Text("no_hadith_found".tr));
          }
          
          return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                    itemCount:
                        hadithController.hadithModel!.hadiths!.data!.length + 1,
                    itemBuilder: (context, index) {
                      if (index ==
                          hadithController.hadithModel!.hadiths!.data!.length) {
                        if (hadithController.hadithModel?.hadiths?.lastPage !=
                                null &&
                            hadithController.currentHadithPage >=
                                hadithController
                                    .hadithModel!.hadiths!.lastPage!) {
                          return const SizedBox(height: 20);
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: hadithController.isMoreHadithLoading.value
                                ? const CircularProgressIndicator()
                                : OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_LARGE),
                                      ),
                                    ),
                                    onPressed: () {
                                      hadithController.getMoreHadithData(
                                          Get.arguments[1], Get.arguments[2]);
                                    },
                                    child: Text(
                                      'load_more'.tr,
                                      style: robotoMedium.copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteHelper.hadithDetails,
                              arguments: hadithController
                                  .hadithModel!.hadiths!.data![index]);
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal:
                                    Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            horizontalTitleGap: 5,
                            leading: Stack(
                              alignment: Alignment.center,
                              children: [
                                // bismillah image ==>
                                SvgPicture.asset(
                                  Images.Icon_Star,
                                  height: 50,
                                  fit: BoxFit.fill,
                                  color: Theme.of(context).primaryColor,
                                ),
                                // serial number show ==>
                                Text(
                                  (index + 1).toString(),
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              hadithController.hadithModel!.hadiths!
                                  .data![index].hadithEnglish!,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            subtitle: Text(
                              "${"writer:".tr} ${hadithController.hadithModel!.hadiths!.data![index].book!.writerName!}"
                                  .tr,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT),
                            ),
                          ),
                        ),
                      );
                    },
                  );
        },
      ),
    );
  }
}
