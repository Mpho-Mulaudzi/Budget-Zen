/*
    Copyright 2020-2025. Huawei Technologies Co., Ltd. All rights reserved.

    Licensed under the Apache License, Version 2.0 (the "License")
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

part of '../huawei_ads.dart';

class Ads {
  final MethodChannel channel;
  final MethodChannel channelSplash;
  final MethodChannel channelBanner;
  final MethodChannel channelReward;
  final MethodChannel channelInterstitial;
  final MethodChannel channelInstream;
  final MethodChannel channelVast;
  final MethodChannel channelConsent;
  final MethodChannel channelReferrer;
  final EventChannel streamConsent;

  Ads._({
    required this.channel,
    required this.channelSplash,
    required this.channelBanner,
    required this.channelReward,
    required this.channelInterstitial,
    required this.channelInstream,
    required this.channelVast,
    required this.streamConsent,
    required this.channelConsent,
    required this.channelReferrer,
  }) {
    channelReferrer.setMethodCallHandler(InstallReferrerClient.onMethodCall);
  }

  static final Ads _instance = Ads._(
    channel: const MethodChannel(_LIBRARY_METHOD_CHANNEL),
    channelSplash: const MethodChannel(_SPLASH_METHOD_CHANNEL),
    channelBanner: const MethodChannel(_BANNER_METHOD_CHANNEL),
    channelReward: const MethodChannel(_REWARD_METHOD_CHANNEL),
    channelInterstitial: const MethodChannel(_INTERSTITIAL_METHOD_CHANNEL),
    channelInstream: const MethodChannel(_INSTREAM_METHOD_CHANNEL),
    channelVast: const MethodChannel(_VAST_METHOD_CHANNEL),
    streamConsent: const EventChannel(_CONSENT_EVENT_CHANNEL),
    channelConsent: const MethodChannel(_CONSENT_METHOD_CHANNEL),
    channelReferrer: const MethodChannel(_REFERRER_METHOD_CHANNEL),
  );

  static Ads get instance => _instance;

  static AdEvent? toAdEvent(String event) {
    return _adEventMap[event];
  }

  static ReportUrlEvent? toReportUrlEvent(String event) {
    return _reportUrlEvent[event];
  }

  static const Map<String, AdEvent> _adEventMap = <String, AdEvent>{
    'onAdLoaded': AdEvent.loaded,
    'onAdFailed': AdEvent.failed,
    'onAdClicked': AdEvent.clicked,
    'onAdImpression': AdEvent.impression,
    'onAdOpened': AdEvent.opened,
    'onAdLeave': AdEvent.leave,
    'onAdClosed': AdEvent.closed,
    'onAdDisliked': AdEvent.disliked,
  };

  static const Map<String, ReportUrlEvent> _reportUrlEvent =
      <String, ReportUrlEvent>{
    'reportSuccess': ReportUrlEvent.success,
    'reportFailed': ReportUrlEvent.failed,
  };
}

typedef AdListener = void Function(
  AdEvent event, {
  int? errorCode,
});

typedef ReportUrlListener = void Function(ReportUrlEvent event);

enum AdEvent {
  clicked,
  closed,
  failed,
  impression,
  leave,
  loaded,
  opened,
  disliked,
}

enum ReportUrlEvent {
  success,
  failed,
}

enum Macro {
  /// Highest bid of other DSPs when Petal Ads wins, in CNY. The value is a price in plaintext, for example, 3.6.
  secondPrice('SECOND_PRICE'),

  /// Highest bid of other DSPs when Petal Ads loses, in CNY. The value is a price in plaintext, for example, 3.6.
  auctionPrice('AUCTION_PRICE'),

  /// Bidding result. If the process does not reach the bidding stage, a callback is still necessary.
  /// Replace **auctionLoss** with the specific result code.
  ///
  /// **102**: Bidding failed.
  ///
  /// **103**: The advertiser is filtered out because the eCPM offered is lower than the minimum.
  ///
  /// **104**: The advertiser is filtered out because the package name is forbidden.
  ///
  /// **105**: The advertiser is filtered out due to other reasons.
  ///
  /// **4005**: No response is returned due to timeout. Theoretically, this result code does not exist. If a timeout occurs in the media, this result code is used.
  auctionLoss('AUCTION_LOSS'),

  /// Price currency.
  /// Supported currencies: **CNY, USD, EUR, GBP, and JPY**.
  auctionCurrency('AUCTION_CURRENCY'),

  /// Package name of the app promoted by the winning DSP when Petal Ads loses.
  auctionAppPkg('AUCTION_APP_PKG'),

  /// Name of the app promoted by the winning DSP when Petal Ads loses.
  auctionAppName('AUCTION_APP_NAME'),

  /// ID of the winning DSP when Petal Ads loses.
  ///
  /// **1**: Tencent Ads
  ///
  /// **2**: Pangle
  ///
  /// **3**: Baiqingteng (Baidu's ad platform)
  ///
  /// **4**: Kuaishoulianmeng (Kuaishou alliance)
  ///
  /// **5**: iQIYI
  ///
  /// **6**: Alibaba
  ///
  /// **7**: vivo
  ///
  /// **8**: OPPO
  ///
  /// **9**: Xiaomi
  ///
  /// **10**: JD
  ///
  /// **11**: Pinduoduo
  ///
  /// **100**: others
  auctionCpId('AUCTION_CP_ID');

  final String val;

  const Macro(this.val);
}

const yz = Macro.auctionCpId;
