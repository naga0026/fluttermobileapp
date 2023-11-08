import 'package:base_project/services/base/base_service.dart';
import 'package:just_audio/just_audio.dart';

class BeepService extends BaseService {

  final String _s1ErrorBeep = "assets/sound/S1.wav";
  final String _s2ErrorBeep = "assets/sound/S2.wav";
  final String _s3ErrorBeep = "assets/sound/S3.wav";
  final String _scanBeep = "assets/sound/ScanSound.wav";
  final String _beepSound = "assets/sound/beep.wav";
  final String _fiveBeepSound = "assets/sound/recall_tracking_5_beeps.wav";

  final _audioPlayer = AudioPlayer();

  void playFiveBeeps() {
    playSound(_fiveBeepSound);
  }

  void playErrorBeep() {
    playSound(_s3ErrorBeep);
  }

  void playScanBeep() {
    playSound(_scanBeep);
  }

  void playBeep() {
    playSound(_beepSound);
  }

  void playS1Beep() {
    playSound(_s1ErrorBeep);
  }

  void playS2Beep() {
    playSound(_s2ErrorBeep);
  }

  Future<void> playSound(String soundFileName) async {
    try{
      var _ = await _audioPlayer.setAsset(soundFileName);
      _audioPlayer.play();
    } catch (error){
      logger.d('Error in playing asset audio: ${error.toString()}');
    }
  }

}