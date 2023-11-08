enum TransferStateEnum {
  oK(0),
  invalidDirective(1),
  boxTooSoon(2),
  invalidControlNumber(3),
  boxAlreadyReceived(4),
  invalidSender(5),
  noPermission(6),
  invalidReceiver(7),
  systemError(8),
  boxCreated(9);

  final int rawValue;
  const TransferStateEnum(this.rawValue);
}

enum BoxStateEnum {
  boxCreated,
  boxEnded,
  boxTransmitted,
  boxVoid,
  boxVoidTransmitted,
  boxNotReceived,
  boxReceived
}

enum BoxResultStatusEnum {
  noEnd,
  wrongTransferType,
  noItems,
  confirmLocation,
  systemError,
  boxEnded,
  noBox,
  boxOK
}

extension BoxResultStatus on int{
  get getBoxResultStatusEnumFromInt=>switch(this){
    1=>BoxResultStatusEnum.noEnd,
    2=>BoxResultStatusEnum.wrongTransferType,
    3=>BoxResultStatusEnum.noItems,
    4=>BoxResultStatusEnum.confirmLocation,
    5=>BoxResultStatusEnum.systemError,
    6=>BoxResultStatusEnum.boxEnded,
    7=>BoxResultStatusEnum.noBox,
  _=>BoxResultStatusEnum.systemError
  };
}

enum ControlNumberStatusEnum {
  itemFound(0),
  transferTypeDoesNotMatch(1),
  notExists(2),
  invalidStateForAction(3),
  wrongDivision(4);

  final int rawValue;
  const ControlNumberStatusEnum(this.rawValue);
}
extension ControlNumberStatus on int{
  get getControlNumberStatusEnumFromInt=>switch(this){
    0=>ControlNumberStatusEnum.itemFound,
    1=>ControlNumberStatusEnum.transferTypeDoesNotMatch,
    2=>ControlNumberStatusEnum.notExists,
    3=>ControlNumberStatusEnum.invalidStateForAction,
    5=>ControlNumberStatusEnum.wrongDivision,
  _=>ControlNumberStatusEnum.notExists
  };
}

enum ValidateStoreNumberStatusEnum { valid, invalid }

