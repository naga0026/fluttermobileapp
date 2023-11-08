import 'package:base_project/services/physical_response/beep_service.dart';
import 'package:base_project/services/physical_response/vibrate_service.dart';
import 'package:get/get.dart';

class PhysicalResponseService extends GetxService {

  final _beepService = Get.put<BeepService>(BeepService());
  final _vibrateService = Get.put<VibrateService>(VibrateService());

  void beep() {
    _beepService.playBeep();
    _vibrateService.playAcknowledgeVibration();
  }

  void fiveBeeps() {
    _beepService.playFiveBeeps();
    _vibrateService.playVibrationFiveBeeps();
  }

  void errorBeep() {
    _beepService.playErrorBeep();
    _vibrateService.playErrorVibration();
  }

  void scanBeep() {
    _beepService.playScanBeep();
    _vibrateService.playSuccessVibration();
  }

  void s1Beep() {
    _beepService.playS1Beep();
    _vibrateService.playSuccessVibration();
  }

  void s2Beep() {
    _beepService.playS1Beep();
  }

}