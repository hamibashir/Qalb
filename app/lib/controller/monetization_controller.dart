import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonetizationController extends GetxController {
  // State
  RxMap<String, DateTime> adUnlockExpiries = <String, DateTime>{}.obs;
  RxBool isAdLoading = false.obs;
  
  RewardedAd? _rewardedAd;

  @override
  void onInit() {
    super.onInit();
    _loadSavedState();
  }

  // --- State Management ---
  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check ad unlock for all features
    final keys = prefs.getKeys();
    for (var key in keys) {
      if (key.startsWith('ad_unlock_expiry_')) {
        final featureId = key.replaceAll('ad_unlock_expiry_', '');
        final expiryString = prefs.getString(key);
        if (expiryString != null) {
          adUnlockExpiries[featureId] = DateTime.parse(expiryString);
        }
      }
    }
  }

  Future<bool> isFeatureUnlocked(String featureId) async {
    // Read directly from SharedPreferences to avoid race conditions on app start
    final prefs = await SharedPreferences.getInstance();
    final expiryString = prefs.getString('ad_unlock_expiry_$featureId');
    if (expiryString != null) {
      final expiry = DateTime.parse(expiryString);
      if (DateTime.now().isBefore(expiry)) {
        adUnlockExpiries[featureId] = expiry; // sync local cache
        return true;
      }
    }
    return false;
  }

  // --- AdMob ---
  String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9732144098985211/5417327251'; // Android Production ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; // iOS Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  Future<void> loadAndShowRewardedAd({required String featureId, required Function() onUnlock}) async {
    isAdLoading.value = true;
    
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          isAdLoading.value = false;
          _showRewardedAd(featureId: featureId, onUnlock: onUnlock);
        },
        onAdFailedToLoad: (error) {
          isAdLoading.value = false;
          Get.snackbar('Error', 'Failed to load ad. Please try again later.');
        },
      ),
    );
  }

  void _showRewardedAd({required String featureId, required Function() onUnlock}) {
    if (_rewardedAd == null) return;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        Get.snackbar('Error', 'Failed to show ad.');
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
      // Grant reward (24 hours unlock)
      final prefs = await SharedPreferences.getInstance();
      final expiry = DateTime.now().add(const Duration(hours: 24));
      await prefs.setString('ad_unlock_expiry_$featureId', expiry.toIso8601String());
      adUnlockExpiries[featureId] = expiry;
      onUnlock();
    });
  }

}
