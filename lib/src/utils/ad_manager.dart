import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "/********** YOUR AD UNIT ID HERE **********/";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "/********** YOUR AD UNIT ID HERE **********/";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "/********** YOUR AD UNIT ID HERE **********/";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}