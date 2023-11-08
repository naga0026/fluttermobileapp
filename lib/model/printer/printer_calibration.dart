

class PrinterCalibrationModel {
  String printerIp;
  String command;

  PrinterCalibrationModel({required this.printerIp, required this.command});

  Map<String, dynamic> toJson() => {
    "printerIp" : printerIp,
    "command" : "'$command'"
  };
}