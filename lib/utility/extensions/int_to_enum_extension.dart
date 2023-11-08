
import '../enums/markdown_operation_result_enum.dart';
import '../enums/transfers_response_enums.dart';

extension IntToControlNumberResponseEnum on int {

  ControlNumberStatusEnum get rawValue {
    switch(this){
      case 0:
        return ControlNumberStatusEnum.itemFound;
      case 1:
        return ControlNumberStatusEnum.transferTypeDoesNotMatch;
      case 2:
        return ControlNumberStatusEnum.notExists;
      case 3:
        return ControlNumberStatusEnum.invalidStateForAction;
      case 4:
        return ControlNumberStatusEnum.wrongDivision;
      default:
        return ControlNumberStatusEnum.notExists;
    }
  }
}

extension IntToEnum on int {
  BoxStateEnum get enumBoxState {
    switch(this){
      case 0:
        return BoxStateEnum.boxCreated;
      case 1:
        return BoxStateEnum.boxEnded;
      case 2:
        return BoxStateEnum.boxTransmitted;
      case 3:
        return BoxStateEnum.boxVoid;
      case 4:
        return BoxStateEnum.boxVoidTransmitted;
      case 5:
        return BoxStateEnum.boxNotReceived;
      case 6:
        return BoxStateEnum.boxReceived;
      default:
        return BoxStateEnum.boxNotReceived;
    }
  }

  MarkdownOperationResultEnum get enumMarkdownOperationResult{
    switch(this){
      case 0:
        return MarkdownOperationResultEnum.noMarkdown;
      case 1:
        return MarkdownOperationResultEnum.weekGotClosed;
      case 2:
        return MarkdownOperationResultEnum.initialMarkdownTaken;
      case 3:
        return MarkdownOperationResultEnum.subsMarkdownTaken;
      case 4:
        return MarkdownOperationResultEnum.noVoidAvailable;
      case 5:
        return MarkdownOperationResultEnum.markdownVoided;
      case 6:
        return MarkdownOperationResultEnum.reprintUpdated;
      case 7:
        return MarkdownOperationResultEnum.noMarkdownLog;
      case 8:
        return MarkdownOperationResultEnum.missedMarkdown;
      default:
        return MarkdownOperationResultEnum.noMarkdown;
    }
  }
}
