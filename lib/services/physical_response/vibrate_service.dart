import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';


class VibrateService extends GetxService {

   static const int _shortVibrationMs = 100;
   static const int _mediumVibrationMs = 400;
   static const int _longVibrationMs = 1000;
   bool isVibrationSupported = false;

   @override
   onInit() {
     super.onInit();
     _isVibrationSupported();
   }

  Future<void> playAcknowledgeVibration() async {
    if (isVibrationSupported) {
    Vibration.vibrate(duration: _shortVibrationMs);
    }
  }

  void playSuccessVibration() {
    if (isVibrationSupported) {
      Vibration.vibrate(duration: _mediumVibrationMs);
    }
  }

  void playErrorVibration() {
    if (isVibrationSupported) {
      Vibration.vibrate(duration: _longVibrationMs);
    }
  }

  void playVibrationFiveBeeps() {
    if (isVibrationSupported) {
      Vibration.vibrate(duration: _shortVibrationMs, repeat: 5);
    }
  }

  Future<void> _isVibrationSupported() async {
    isVibrationSupported =  await Vibration.hasVibrator() ?? false;
    debugPrint('Vibration supported: $isVibrationSupported');
  }
}