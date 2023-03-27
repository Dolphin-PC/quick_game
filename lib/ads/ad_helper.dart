import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    /// 운영 모드
    if (kReleaseMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-7134346559226034/4534551859'; // 운영 광고 ID
      } else if (Platform.isIOS) {
        return 'ca-app-pub-7134346559226034/4534551859'; // 운영 광고 ID
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    }

    /// 디버그 모드
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // 테스트 광고 ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // 테스트 광고 ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    /// 운영 모드
    if (kReleaseMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-7134346559226034/7740501405'; // 운영 광고 ID
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/7552160883'; // 운영 광고 ID
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    }

    /// 디버그 모드
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // 테스트 광고 ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/7552160883'; // 테스트 광고 ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/7049598008'; // 테스트 광고 ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3964253750'; // 테스트 광고 ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
