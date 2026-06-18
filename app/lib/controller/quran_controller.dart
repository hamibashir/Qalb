import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qalb/data/model/response/juz_list_model.dart';
import 'package:qalb/data/model/response/sifat_name_details_model.dart';
import 'package:qalb/data/model/response/sifat_name_list_model.dart';
import 'package:qalb/data/model/response/sura_detile_model.dart';
import 'package:qalb/data/model/response/sura_list_model.dart';
import 'package:qalb/data/repository/sifatname_list_repo.dart';

class QuranController extends GetxController implements GetxService {
  final QuranRepo quranRepo;
  QuranController({required this.quranRepo});
  @override
  void onInit() {
    // fetchSifatNameListData();
    super.onInit();
  }

// local variable
  RxBool isSifatNameListLoading = false.obs;
  SifatNameListModel? sifatNameApiData;

// get dua list form here
  Future<void> fetchSifatNameListData() async {
    try {
      isSifatNameListLoading(true);

      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('sifat_name_list_cache');
      
      if (cachedData != null) {
        try {
          sifatNameApiData = SifatNameListModel.fromJson(jsonDecode(cachedData));
          isSifatNameListLoading(false);
          update();
          return;
        } catch (e) {
          // If decoding fails, fallback to network
        }
      }

      final response = await quranRepo.getSifatNameRepo();

      if (response.statusCode == 200) {
        await prefs.setString('sifat_name_list_cache', jsonEncode(response.body));
        sifatNameApiData = SifatNameListModel.fromJson(response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
    } finally {
      isSifatNameListLoading(false);
      update();
    }
  }

  RxBool isSifatNameDetailsLoading = false.obs;
  SifatNameDetailsModel? sifatnameDetailsApidata;

// get dua details function
  Future<void> fetchSifatNameDetailsData({String? sifatNameId}) async {
    try {
      isSifatNameDetailsLoading(true);

      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'sifat_name_details_cache_$sifatNameId';
      final cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        try {
          sifatnameDetailsApidata = SifatNameDetailsModel.fromJson(jsonDecode(cachedData));
          isSifatNameDetailsLoading(false);
          update();
          return;
        } catch (e) {
          // Fallback to network
        }
      }

      final response =
          await quranRepo.getSifatNameDetailsRepo(sifatNameId.toString());

      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, jsonEncode(response.body));
        sifatnameDetailsApidata = SifatNameDetailsModel.fromJson(response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
    } finally {
      isSifatNameDetailsLoading(false);
      update();
    }
  }

  // local variable
  SuraListModel? suraListApiData;
  SuraDetaileModel? suraDetaileApiData;
  JuzListModel? juzListApiData;

  RxBool isJuzListLoading = false.obs;
  RxBool isSuraListLoading = false.obs;
  RxBool isSuraDetaileLoading = false.obs;
  int? suraNumber;

// get sura list function
  Future<void> fetchSuraListData({String? translatorId, bool isRefresh = false}) async {
    try {
      isSuraListLoading(true);
      update();
      final prefs = await SharedPreferences.getInstance();
      var selectedTranslatorId =
          translatorId ?? prefs.getString('selectedTranslatorId') ?? 1;

      final cacheKey = 'sura_list_cache_$selectedTranslatorId';
      if (!isRefresh) {
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          try {
            suraListApiData = SuraListModel.fromJson(jsonDecode(cachedData));
            isSuraListLoading(false);
            update();
            return;
          } catch (e) {
            // fallback to network
          }
        }
      }

      final response =
          await quranRepo.getSuraListRepo(selectedTranslatorId.toString());

      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, jsonEncode(response.body));
        suraListApiData = SuraListModel.fromJson(response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
    } finally {
      isSuraListLoading(false);
      update();
    }
  }

// get sura detail function
  Future<void> fetchSuraDetaileData(
      {String? suraId, String? translatorId, bool isRefresh = false}) async {
    try {
      isSuraDetaileLoading(true);
      update();
      final prefs = await SharedPreferences.getInstance();
      var selectedTranslatorId =
          translatorId ?? prefs.getString('selectedTranslatorId') ?? 1;

      final cacheKey = 'sura_detaile_cache_${suraId}_$selectedTranslatorId';
      if (!isRefresh) {
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          try {
            suraDetaileApiData = SuraDetaileModel.fromJson(jsonDecode(cachedData));
            isSuraDetaileLoading(false);
            update();
            return;
          } catch (e) {
            // fallback to network
          }
        }
      }

      final response = await quranRepo.getSuraDetailsRepo(
          suraId.toString(), selectedTranslatorId.toString());

      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, jsonEncode(response.body));
        suraDetaileApiData = SuraDetaileModel.fromJson(response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
    } finally {
      isSuraDetaileLoading(false);
      update();
    }
  }

// get juz list form here
  Future<void> fetchJuzListData({String? translatorId, bool isRefresh = false}) async {
    try {
      isJuzListLoading(true);
      update();
      final prefs = await SharedPreferences.getInstance();
      var selectedTranslatorId =
          translatorId ?? prefs.getString('selectedTranslatorId') ?? 1;

      final cacheKey = 'juz_list_cache_$selectedTranslatorId';
      if (!isRefresh) {
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          try {
            juzListApiData = JuzListModel.fromJson(jsonDecode(cachedData));
            isJuzListLoading(false);
            update();
            return;
          } catch (e) {
            // fallback to network
          }
        }
      }

      final response =
          await quranRepo.getJuzListRepo(selectedTranslatorId.toString());

      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, jsonEncode(response.body));
        juzListApiData = JuzListModel.fromJson(response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
    } finally {
      isJuzListLoading(false);
      update();
    }
  }
}
