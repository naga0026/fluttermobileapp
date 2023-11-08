import 'package:get/get.dart';

import '../../translations/translation_keys.dart';

enum MarkdownOperationEnum { initials, subs, mlu, voidPrevious, reprint }

extension RawValue on MarkdownOperationEnum {
  String get rawValue {
    switch (this) {
      case MarkdownOperationEnum.initials:
        return TranslationKey.initialsLabel.tr;
      case MarkdownOperationEnum.subs:
        return TranslationKey.subsLabel.tr;
      case MarkdownOperationEnum.mlu:
        return TranslationKey.mluLabel.tr;
      case MarkdownOperationEnum.voidPrevious:
        return TranslationKey.voidPrevLabel.tr;
      case MarkdownOperationEnum.reprint:
        return TranslationKey.reprintLabel.tr;
    }
  }
}
