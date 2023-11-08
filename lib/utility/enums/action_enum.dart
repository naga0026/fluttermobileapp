// Add all action of markdown, sgm, ticket maker etc here
import 'package:get/get.dart';

import '../../translations/translation_keys.dart';

enum ActionEnum {
  initials,
  subs,
  mlu,
  voidPrevious,
  reprintLabel
}

extension StringValue on ActionEnum {
    String get title {
      switch(this){
        case ActionEnum.initials:
          return TranslationKey.initialsLabel.tr;
        case ActionEnum.subs:
          return TranslationKey.subsLabel.tr;
        case ActionEnum.mlu:
          return TranslationKey.mluLabel.tr;
        case ActionEnum.voidPrevious:
          return TranslationKey.voidPrevLabel.tr;
        case ActionEnum.reprintLabel:
          return TranslationKey.reprintLabel.tr;
      }
    }
}
