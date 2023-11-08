import '../../../model/printer_setup.dart';

class PrintLabelModel {
  String label;
  PrinterSetUp printer;

  PrintLabelModel({required this.label, required this.printer});

  Map<String, dynamic> toJson() => {
    "printerId" : printer.printerId,
    "label" : label
  };
}