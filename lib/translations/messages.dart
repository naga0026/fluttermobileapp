import 'package:get/get.dart';

import 'en.dart';
import 'fr.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': En().messages,
    'fr': Fr().messages
  };

}