/// Holds the details of the connected printer.
/// Each printer has a different ip address, port and stock type selected

class ZebraPrinter {
  String ipAddress;
  String port;
  String stockType;

  ZebraPrinter({required this.ipAddress, required this.port, required this.stockType});

  Map<String, String> toMap() {
    return {"ip": ipAddress, "port": port, "stockType": stockType};
  }
}
