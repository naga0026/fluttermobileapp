import 'package:base_project/utility/enums/tag_type_enum.dart';

enum SignTypeEnum{
  vertical("VERTICAL"),
  lgHorizontal("LG HORIZONTAL"),
  smHorizontal("SM HORIZONTAL");

  final String rawValue;
  const SignTypeEnum(this.rawValue);
}
extension GetSignType on String{

  SignTypeEnum get getSignTypeFromString=>switch(this){
    "VERTICAL"=>SignTypeEnum.vertical,
    "SM HORIZONTAL"=>SignTypeEnum.vertical,
    "LG HORIZONTAL"=>SignTypeEnum.vertical,
    _=>SignTypeEnum.vertical

  };
}

extension GetTagType on SignTypeEnum{

  TagTypeEnum get getTagTypeEnumFromSignTypeEnum=>switch(this){
    SignTypeEnum.vertical=>TagTypeEnum.largeSignVertical,
    SignTypeEnum.lgHorizontal=>TagTypeEnum.largeSignHorizontal,
    SignTypeEnum.smHorizontal=>TagTypeEnum.smallSign,
  };

}
