import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:qalb/data/model/response/hadis_book_model.dart';
import 'package:qalb/data/model/response/hadith_chapter_model.dart';
import 'package:qalb/data/model/response/hadith_model.dart';
import 'package:qalb/util/app_constants.dart';


class HadithController extends GetxController {
  // local variable
  RxBool isLoadingHadithChapter = false.obs;
  RxBool isLoadingHadith = false.obs;
  RxBool isMoreHadithLoading = false.obs;
  int currentHadithPage = 1;

// hadith api key
  String hadithApiKey =
      r"$2y$10$o0AXquYL5FO5kPOz8yQ1u0yCbrZ05Hj98emzZ0vsT5jt2TPWXGum";

  @override
  void onInit() {

    getHadishBookNameData();

    super.onInit();
  }

  HadisBookModel? hadisBookModel;
  HadithChapterModel? hadithChapterModel;
  HadithModel? hadithModel;

// get hadith book list api call here
  getHadishBookNameData() async {
    isLoadingHadithChapter(true);
    try {
      const hadithApiKey =
          r"$2y$10$o0AXquYL5FO5kPOz8yQ1u0yCbrZ05Hj98emzZ0vsT5jt2TPWXGum";
      final response = await http.get(Uri.parse(
          "${AppConstants.HADITH_BASE_URL}/api/books?apiKey=$hadithApiKey"));

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        hadisBookModel = HadisBookModel.fromJson(data);
      }
    } catch (error) {
      // Ignore or log properly
    } finally {
      isLoadingHadithChapter(false);
      update();
    }
  }

// get hadith chaptar here
  getHadithBookChaptersData(arguments) async {
    isLoadingHadithChapter(true);
    try {
      final response = await http.get(Uri.parse(
          "${AppConstants.HADITH_BASE_URL}/api/$arguments/chapters?apiKey=$hadithApiKey"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        hadithChapterModel = HadithChapterModel.fromJson(data);
      }
    } catch (error) {
      // Ignore or log properly
    } finally {
      isLoadingHadithChapter(false);
      update();
    }
  }

// get hadith data here
  getAllHadithData(bookName, chapter) async {
    isLoadingHadith(true);
    currentHadithPage = 1;
    try {
      final response = await http.get(Uri.parse(
          "${AppConstants.HADITH_BASE_URL}/api/hadiths?apiKey=$hadithApiKey&book=$bookName&chapter=$chapter&paginate=200&page=$currentHadithPage"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        hadithModel = HadithModel.fromJson(data);
      } else {
        Get.snackbar("message".tr, "no_hadith_found_in_this_chapter".tr);
      }
    } catch (error) {
      Get.snackbar("Error", "Failed to load hadiths. Please try again.");
    } finally {
      isLoadingHadith(false);
      update();
    }
  }

  // fetch more hadith data for pagination
  Future<void> getMoreHadithData(bookName, chapter) async {
    if (hadithModel?.hadiths?.lastPage != null &&
        currentHadithPage >= hadithModel!.hadiths!.lastPage!) {
      return; // No more pages
    }
    isMoreHadithLoading(true);
    update();
    currentHadithPage++;
    try {
      final response = await http.get(Uri.parse(
          "${AppConstants.HADITH_BASE_URL}/api/hadiths?apiKey=$hadithApiKey&book=$bookName&chapter=$chapter&paginate=200&page=$currentHadithPage"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var newModel = HadithModel.fromJson(data);
        if (newModel.hadiths?.data != null) {
          hadithModel!.hadiths!.data!.addAll(newModel.hadiths!.data!);
        }
      }
    } catch (error) {
      currentHadithPage--;
    } finally {
      isMoreHadithLoading(false);
      update();
    }
  }

}
