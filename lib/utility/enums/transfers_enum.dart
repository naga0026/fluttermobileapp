//region Transfers Option

enum TransfersDirection {
  shipping(1),
  receiving(2);

  final int rawValue;
  const TransfersDirection(this.rawValue);
}

extension TransferOptionValue on TransfersDirection {
  String get title {
    switch (this) {
      case TransfersDirection.shipping:
        return 'Shipping';
      case TransfersDirection.receiving:
        return 'Receiving';
    }
  }

  List<TransferType> get transferTypes {
    switch (this) {
      case TransfersDirection.shipping:
        return [
          TransferType.storeToStore,
          TransferType.damagedJewelry,
          TransferType.merchandiseRecall
        ];
      case TransfersDirection.receiving:
        return [
          TransferType.receivingStoreToStore,
          TransferType.specialProjects
        ];
    }
  }
}
//endregion

//region Transfer Type
enum TransferType {
  storeToStore('Store-to-Store'),
  merchandiseRecall('Merchandise Recall'),
  damagedJewelry('Damaged Jewelry'),
  receivingStoreToStore('Store-to-Store'),
  specialProjects('Special Projects');

  final String rawValue;

  const TransferType(this.rawValue);
}

extension TransferTypeValues on TransferType {
  String get title {
    switch (this) {
      case TransferType.storeToStore:
      case TransferType.receivingStoreToStore:
        return 'Store-to-Store';
      case TransferType.damagedJewelry:
        return 'Damaged Jewelry';
      case TransferType.merchandiseRecall:
        return 'Merchandise Recall';
      case TransferType.specialProjects:
        return 'Special Projects';
    }
  }

  List<ShippingActions> get actions {
    switch (this) {
      case TransferType.storeToStore:
      case TransferType.damagedJewelry:
        return [
          ShippingActions.newBox,
          ShippingActions.endBox,
          ShippingActions.adjustInquireBox,
          ShippingActions.reprintLabel
        ];
      case TransferType.merchandiseRecall:
        return [];
      default:
        return [];
    }
  }
}
//endregion

//region Shipping Actions
enum ShippingActions {
  newBox('New Box'),
  endBox('End Box'),
  adjustInquireBox('Adjust Inquire Box'),
  reprintLabel('Reprint Label'),
  addItem('Add Item'),
  deleteItem('Delete Item'),
  inquireBox('Inquire Box'),
  voidBox('Void Box');

  final String rawValue;

  const ShippingActions(this.rawValue);
}

extension ShippingActionValues on ShippingActions {
  String get title {
    return switch (this) {
      ShippingActions.newBox => 'New Box',
      ShippingActions.endBox => 'End Box',
      ShippingActions.adjustInquireBox => 'Adjust Inquire Box',
      ShippingActions.reprintLabel => 'Reprint Label',
      ShippingActions.addItem => 'Add Item',
      ShippingActions.deleteItem => 'Delete Item',
      ShippingActions.inquireBox => 'Inquire Box',
      ShippingActions.voidBox => 'Void Box'
    };
  }
}
//endregion
//
// extension TransfersTitles on String {
//   String get title {
//
//   }
// }

enum NewBoxOptions {
  deleteBox,
  addBox,
  endBox,
  inquireBox,
  voidBox
}

extension NewBoxValues on NewBoxOptions {
  String get title {
    return switch (this) {
      NewBoxOptions.endBox => 'End Box',
      NewBoxOptions.inquireBox => 'Inquire Box',
      NewBoxOptions.voidBox => 'Void Box',
      NewBoxOptions.addBox => 'Add Box',
      NewBoxOptions.deleteBox => 'Delete Box',
    };
  }
}


enum TransferTypeEnum {
  storeToStore(1), merchandiseRecall(2), damagedJewelery(3), specialProject(4);

  final int rawValue;
  const TransferTypeEnum(this.rawValue);
}

enum TransferRequestTypeEnum {
  adjustOrInquireBox(0),
  addOrDeleteItem(1),
  voidBox(2),
  endBox(3),
  reprintLabels(4);

  final int rawValue;
  const TransferRequestTypeEnum(this.rawValue);
}

enum ReceivingValidationResult {
  validStoreSameStore,
  validStoreCrossStore,
  notValid
}