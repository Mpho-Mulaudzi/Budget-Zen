import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;
import 'package:huawei_ads/huawei_ads.dart' as hms;
import '../configs.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  admob.InterstitialAd? _admobInterstitial;
  hms.InterstitialAd? _hmsInterstitial;
  hms.BannerView? _huaweiBanner;
  bool _isLoading = false;
  bool _isInitialized = false;
  AdNetwork? _activeNet;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      if (Platform.isAndroid) {
        await hms.HwAds.init();
        _activeNet = AdNetwork.huawei;
        return;
      }

      switch (AdConfig.currentNetwork) {

        case AdNetwork.huawei:
          await hms.HwAds.init();
          _activeNet = AdNetwork.huawei;
          break;

        case AdNetwork.admob:
          await admob.MobileAds.instance.initialize();
          _activeNet = AdNetwork.admob;
          break;


        case AdNetwork.auto:
          try {

            await hms.HwAds.init();
            _activeNet = AdNetwork.huawei;

          } catch (_) {


            await admob.MobileAds.instance.initialize();
            _activeNet = AdNetwork.admob;
          }
          break;
      }

      await loadAd();
    } catch (e) {
      debugPrint("Ad init error: $e");
    }
  }

  Future<void> loadAd() async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      if (_activeNet == AdNetwork.huawei) {
        _hmsInterstitial = hms.InterstitialAd(
          adSlotId: AdConfig.huaweiInterstitialId,
        );
        await _hmsInterstitial!.loadAd();
      } else {
        await admob.InterstitialAd.load(
          adUnitId: AdConfig.admobInterstitialId,
          request: const admob.AdRequest(),
          adLoadCallback: admob.InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              _admobInterstitial = ad;
              _isLoading = false;
            },
            onAdFailedToLoad: (error) {
              debugPrint("AdMob failed to load: $error");
              _isLoading = false;
            },
          ),
        );
      }
    } catch (e) {
      debugPrint("LoadAd error: $e");
    } finally {
      _isLoading = false;
    }
  }

  /// Call this safely — it will auto reload the next ad.
  void showAdIfAvailable() {
    if (_activeNet == AdNetwork.huawei) {
      if (_hmsInterstitial != null) {
        _hmsInterstitial!.show();
        loadAd(); // preload next
      } else {
        loadAd();
      }
      return;
    }

    if (_admobInterstitial != null) {
      _admobInterstitial!.fullScreenContentCallback =
          admob.FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _admobInterstitial = null;
              loadAd();
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _admobInterstitial = null;
              loadAd();
            },
          );
      _admobInterstitial!.show();
      _admobInterstitial = null;
    } else {
      loadAd();
    }
  }
}

