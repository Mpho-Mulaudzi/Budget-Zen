// lib/config.dart
import 'dart:io';

// class AdConfig {
//   // Default: Google (AdMob)
//   static const String admobInterstitialId = 'ca-app-pub-6722748206860300/3676878980';
//   static const String admobBannerId = 'ca-app-pub-6722748206860300/7269860829';
//
//   // Huawei test IDs
//   static const String huaweiAppId = '115739033';
//   static const String huaweiInterstitialId = 'm1roawe0st';
//   static const String huaweiBannerId = 'testw6vs28auh3';
//
//   /// Detect preferred ad network — you can later make this configurable.
//   static AdNetwork get currentNetwork {
//     if (Platform.isAndroid) {
//       // simplistic detection; you can refine with package_info_plus to check installOrigin
//       // For now, let's choose Huawei if device lacks Google Play Services.
//       return AdNetwork.auto;
//     }
//     return AdNetwork.admob;
//   }
// }
//
// enum AdNetwork { admob, huawei, auto }


class AdConfig {
  // Default: Google (AdMob)
  static const String admobInterstitialId = 'ca-app-pub-6722748206860300/3676878980';
  static const String admobBannerId = 'ca-app-pub-6722748206860300/7269860829';

  // Unity Ads IDs
  static const String unityGameId = '5736623'; // Android test Game ID
  static const String unityGameIdIOS = '5736622'; // iOS test Game ID
  static const String unityInterstitialId = 'Interstitial_Android';
  static const String unityBannerId = 'Banner_Android';
  static const bool unityTestMode = true; // Set to false for production

  /// Detect preferred ad network — you can later make this configurable.
  static AdNetwork get currentNetwork {
    if (Platform.isAndroid) {
      // simplistic detection; you can refine with package_info_plus to check installOrigin
      // For now, let's choose Unity if device lacks Google Play Services.
      return AdNetwork.auto;
    }
    return AdNetwork.admob;
  }

  /// Get Unity Game ID based on platform
  static String get unityGameIdForPlatform {
    if (Platform.isIOS) {
      return unityGameIdIOS;
    }
    return unityGameId;
  }
}

enum AdNetwork { admob, unity, auto }