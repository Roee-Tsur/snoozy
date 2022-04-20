// import 'package:firebase_admob/firebase_admob.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:snozzy/main.dart';
//
// class Ads {
//   static BannerAd _bannerAd;
//   static InterstitialAd _interstitialAd;
//   static bool _bannerLoaded;
//   static MyAppState _myAppState;
//
//   static BannerAd displayBannerAd(BuildContext context) {
//     _bannerAd = BannerAd(
//         adUnitId: BannerAd.testAdUnitId,
//         size: AdSize.smartBanner,
//         listener: (event) {
//           _myAppState.bottomPadding = getBannerHeight(context);
//           _myAppState.setState(() {});
//         });
//     if (_bannerLoaded)
//       _bannerAd.show(anchorType: AnchorType.bottom);
//     else
//       _bannerAd.load().then((value) {
//         _bannerAd.show(anchorType: AnchorType.bottom);
//         _bannerLoaded = true;
//       });
//     return _bannerAd;
//   }
//
//   static InterstitialAd displayInterstitialAd() {
//     _interstitialAd = InterstitialAd(adUnitId: InterstitialAd.testAdUnitId);
//     _interstitialAd
//       ..load()
//       ..show();
//     return _interstitialAd;
//   }
//
//   static hideBannerAd() {
//     _bannerAd.show(anchorOffset: -60.0, horizontalCenterOffset: -50.0);
//     _bannerAd.isLoaded().then((value) {
//       if(value) {
//         _bannerAd.dispose();
//         _bannerAd = null;
//       }
//     });
//   }
//
//   static double getBannerHeight(BuildContext context) {
//     if (!_bannerLoaded) return 0;
//
//     MediaQueryData mediaScreen = MediaQuery.of(context);
//     double height = mediaScreen.orientation == Orientation.portrait
//         ? mediaScreen.size.height
//         : mediaScreen.size.width;
//     if (height <= 400.0)
//       return 32.0;
//     if(height > 400 && height <=720)
//       return 50.0;
//     if (height > 720.0)
//       return 90.0;
//     return 0;
//   }
//
//   static void initAdMob(MyAppState myAppState) {
//     FirebaseAdMob.instance
//         .initialize(appId: 'ca-app-pub-1541488806882161~6789847431');
//     _bannerLoaded = false;
//     _myAppState = myAppState;
//   }
// }
