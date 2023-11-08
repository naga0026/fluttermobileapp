enum AppNameEnum {
  markdowns("Markdowns"),
  sgm("SGM"),
  ticketMaker("Ticket Maker"),
  transfers("Transfers"),
  returnItemLookup("Return Item Lookup"),
  recallTracking("Recall Tracking"),
  userMgmt("UserMgmt"),
  supplyReq("SupplyReq"),
  flashSales("FlashSales"),
  pos("POS"),
  language("Language"),
  password("Password"),
  cashOffice("CashOffice"),
  shoes("Shoes");

  final String rawValue;

  const AppNameEnum(this.rawValue);
}

extension AppName on String {
  AppNameEnum get appName {
    switch (this) {
      case "Markdowns":
        return AppNameEnum.markdowns;
      case "SGM":
        return AppNameEnum.sgm;
      case "Ticket Maker":
        return AppNameEnum.ticketMaker;
      case "Transfers":
        return AppNameEnum.transfers;
      case "Return Item Lookup":
        return AppNameEnum.returnItemLookup;
      case "Recall Tracking":
        return AppNameEnum.recallTracking;
      case "UserMgmt":
        return AppNameEnum.userMgmt;
      case "SupplyReq":
        return AppNameEnum.supplyReq;
      case "FlashSales":
        return AppNameEnum.flashSales;
      case "POS":
        return AppNameEnum.pos;
      case "Language":
        return AppNameEnum.language;
      case "Password":
        return AppNameEnum.password;
      case "CashOffice":
        return AppNameEnum.cashOffice;
      case "Shoes":
        return AppNameEnum.shoes;
      default:
        return AppNameEnum.markdowns;
    }
  }
}
