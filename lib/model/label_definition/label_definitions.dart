import 'package:base_project/model/label_definition/printer_label_definition.dart';

class LabelDefinitions {
  List<PrinterLabelDefinition>? maintenance;
  List<PrinterLabelDefinition>? recall;
  List<PrinterLabelDefinition>? transfers;
  List<PrinterLabelDefinition>? sgm;
  List<PrinterLabelDefinition>? markdown;
  List<PrinterLabelDefinition>? ticketMaker;

  LabelDefinitions(
      { this.maintenance,
       this.recall,
       this.transfers,
       this.sgm,
       this.markdown,
       this.ticketMaker});
}
