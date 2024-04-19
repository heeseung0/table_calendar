import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late final BannerAd banner;

  @override
  void initState() {
    super.initState();

    //개발 환경에서 실제 광고 ID를 사용하면 안된다.
    const adUnitId = 'ca-app-pub-9690219734026499/3052153608';

    //광고 생성
    banner = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,

      //광고의 생명주기가 변경될 때마다 실행할 함수들을 설정
      listener: BannerAdListener(onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }),

      //광고 요청 정보를 담고 있는 클래스
      request: const AdRequest(),
    );
    banner.load();
  }

  @override
  void dispose() {
    //위젯이 dispose 되면 광고 또한 dispose 해야 한다.
    banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: AdWidget(ad: banner),
    );
  }
}
