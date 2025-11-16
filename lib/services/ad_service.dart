import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;
import 'package:huawei_ads/huawei_ads.dart' as hms;
import '../configs.dart';

// class AdManager {
//   static final AdManager _instance = AdManager._internal();
//   factory AdManager() => _instance;
//   AdManager._internal();
//
//   admob.InterstitialAd? _admobInterstitial;
//   hms.InterstitialAd? _hmsInterstitial;
//   bool _isLoading = false;
//   bool _isInitialized = false;
//   AdNetwork? _activeNet;
//
//   Future<void> initialize() async {
//     if (_isInitialized) return;
//     _isInitialized = true;
//
//     try {
//       if (Platform.isAndroid) {
//         await hms.HwAds.init();
//         _activeNet = AdNetwork.huawei;
//         return;
//       }
//
//       switch (AdConfig.currentNetwork) {
//
//         case AdNetwork.huawei:
//           await hms.HwAds.init();
//           _activeNet = AdNetwork.huawei;
//           break;
//
//         case AdNetwork.admob:
//           await admob.MobileAds.instance.initialize();
//           _activeNet = AdNetwork.admob;
//           break;
//
//
//         case AdNetwork.auto:
//           try {
//
//             await hms.HwAds.init();
//             _activeNet = AdNetwork.huawei;
//
//           } catch (_) {
//
//
//             await admob.MobileAds.instance.initialize();
//             _activeNet = AdNetwork.admob;
//           }
//           break;
//       }
//
//       await loadAd();
//     } catch (e) {
//       debugPrint("Ad init error: $e");
//     }
//   }
//
//   Future<void> loadAd() async {
//     if (_isLoading) return;
//     _isLoading = true;
//
//     try {
//       if (_activeNet == AdNetwork.huawei) {
//         _hmsInterstitial = hms.InterstitialAd(
//           adSlotId: AdConfig.huaweiInterstitialId,
//         );
//         await _hmsInterstitial!.loadAd();
//       } else {
//         await admob.InterstitialAd.load(
//           adUnitId: AdConfig.admobInterstitialId,
//           request: const admob.AdRequest(),
//           adLoadCallback: admob.InterstitialAdLoadCallback(
//             onAdLoaded: (ad) {
//               _admobInterstitial = ad;
//               _isLoading = false;
//             },
//             onAdFailedToLoad: (error) {
//               debugPrint("AdMob failed to load: $error");
//               _isLoading = false;
//             },
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint("LoadAd error: $e");
//     } finally {
//       _isLoading = false;
//     }
//   }
//
//   /// Call this safely — it will auto reload the next ad.
//   void showAdIfAvailable() {
//     if (_activeNet == AdNetwork.huawei) {
//       if (_hmsInterstitial != null) {
//         _hmsInterstitial!.show();
//         loadAd(); // preload next
//       } else {
//         loadAd();
//       }
//       return;
//     }
//
//     if (_admobInterstitial != null) {
//       _admobInterstitial!.fullScreenContentCallback =
//           admob.FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (ad) {
//               ad.dispose();
//               _admobInterstitial = null;
//               loadAd();
//             },
//             onAdFailedToShowFullScreenContent: (ad, err) {
//               ad.dispose();
//               _admobInterstitial = null;
//               loadAd();
//             },
//           );
//       _admobInterstitial!.show();
//       _admobInterstitial = null;
//     } else {
//       loadAd();
//     }
//   }
// }


import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import '../configs.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  admob.InterstitialAd? _admobInterstitial;
  bool _unityInterstitialLoaded = false;
  bool _isLoading = false;
  bool _isInitialized = false;
  AdNetwork? _activeNet;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      if (Platform.isAndroid) {
        await UnityAds.init(
          gameId: AdConfig.unityGameIdForPlatform,
          testMode: AdConfig.unityTestMode,
          onComplete: () {
            debugPrint('Unity Ads Initialization Complete');
          },
          onFailed: (error, message) => debugPrint('Unity Ads Initialization Failed: $error $message'),
        );
        _activeNet = AdNetwork.unity;
        return;
      }

      switch (AdConfig.currentNetwork) {

        case AdNetwork.unity:
          await UnityAds.init(
            gameId: AdConfig.unityGameIdForPlatform,
            testMode: AdConfig.unityTestMode,
            onComplete: () {
              debugPrint('Unity Ads Initialization Complete');
            },
            onFailed: (error, message) => debugPrint('Unity Ads Initialization Failed: $error $message'),
          );
          _activeNet = AdNetwork.unity;
          break;

        case AdNetwork.admob:
          await admob.MobileAds.instance.initialize();
          _activeNet = AdNetwork.admob;
          break;


        case AdNetwork.auto:
          try {
            await UnityAds.init(
              gameId: AdConfig.unityGameIdForPlatform,
              testMode: AdConfig.unityTestMode,
              onComplete: () {
                debugPrint('Unity Ads Initialization Complete');
              },
              onFailed: (error, message) => debugPrint('Unity Ads Initialization Failed: $error $message'),
            );
            _activeNet = AdNetwork.unity;

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
      if (_activeNet == AdNetwork.unity) {
        // Load Unity interstitial ad
        UnityAds.load(
          placementId: AdConfig.unityInterstitialId,
          onComplete: (placementId) {
            debugPrint('Unity Load Complete $placementId');
            _unityInterstitialLoaded = true;
            _isLoading = false;
          },
          onFailed: (placementId, error, message) {
            debugPrint('Unity Load Failed $placementId: $error $message');
            _unityInterstitialLoaded = false;
            _isLoading = false;
          },
        );
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
    if (_activeNet == AdNetwork.unity) {
      if (_unityInterstitialLoaded) {
        UnityAds.showVideoAd(
          placementId: AdConfig.unityInterstitialId,
          onComplete: (placementId) {
            debugPrint('Unity Ad Complete $placementId');
            _unityInterstitialLoaded = false;
            loadAd(); // preload next
          },
          onFailed: (placementId, error, message) {
            debugPrint('Unity Ad Failed $placementId: $error $message');
            _unityInterstitialLoaded = false;
            loadAd();
          },
          onStart: (placementId) => debugPrint('Unity Ad Start $placementId'),
          onClick: (placementId) => debugPrint('Unity Ad Click $placementId'),
          onSkipped: (placementId) {
            debugPrint('Unity Ad Skipped $placementId');
            _unityInterstitialLoaded = false;
            loadAd();
          },
        );
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

  /// Get Unity Banner widget
  UnityBannerAd getBanner() {
    return UnityBannerAd(
      placementId: AdConfig.unityBannerId,
      onLoad: (placementId) => debugPrint('Unity Banner loaded: $placementId'),
      onClick: (placementId) => debugPrint('Unity Banner clicked: $placementId'),
      onShown: (placementId) => debugPrint('Unity Banner shown: $placementId'),
      onFailed: (placementId, error, message) =>
          debugPrint('Unity Banner Ad Failed $placementId: $error $message'),
    );
  }
}