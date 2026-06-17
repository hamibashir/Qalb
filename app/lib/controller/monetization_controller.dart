import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonetizationController extends GetxController {
  // Constants
  static const String _premiumKey = 'is_premium';

  // State
  RxBool isPremium = false.obs;
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
    
    // Check premium
    isPremium.value = prefs.getBool(_premiumKey) ?? false;
    
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

  bool isFeatureUnlocked(String featureId) {
    if (isPremium.value) return true;
    final expiry = adUnlockExpiries[featureId];
    if (expiry != null && DateTime.now().isBefore(expiry)) {
      return true;
    }
    return false;
  }

  // --- AdMob ---
  String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Android Test ID
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

  // --- In-App Purchase ---
  // In production, this must use InAppPurchase connection streams.
  // We mock a successful purchase for demonstration.
  Future<void> purchasePremium() async {
    // In production, uncomment the InAppPurchase verification:
    // final bool available = await InAppPurchase.instance.isAvailable();
    // if (!available) {
    //   Get.snackbar('Error', 'Store is not available.');
    //   return;
    // }
    
    // Simulate payment process
    await Future.delayed(const Duration(seconds: 1));
    await grantPremium();
  }

  Future<void> grantPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, true);
    isPremium.value = true;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 60, color: Colors.green),
              const SizedBox(height: 15),
              Text('Success'.tr, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                'Premium unlocked forever! Thank you for your support.'.tr,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => Get.back(),
                child: Text('Close'.tr, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
