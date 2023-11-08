import 'dart:async';
import 'dart:convert';

import 'package:base_project/utility/constants/app/platform_channel_constants.dart';
import 'package:flutter/services.dart';

import '../base/base_service.dart';

/// Scanner activities are handled in this class
/// Provides functions to enable/disable scans, listen to scan events and other related functions
class ZebraScanService extends BaseService {

  //region Variables
  // final lastScannedBarcode = ''.obs;
  StreamController<String> scannedBarcodeStreamController = StreamController.broadcast();

  EventChannel scanChannel = PlatformChannelConstants.sboEventChannel;
  MethodChannel methodChannel = PlatformChannelConstants.sboPrintMethodChannel;

  static const String dwProfile = 'SBO_Store_App';

  //endregion

  //region Initializer
  @override
  onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    _createProfile();
    disableDataWedge();
    scanChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }
  //endregion

  //region Initial SetUp
  Future<void> _createProfile() async {
    try{
      await methodChannel.invokeMethod('createDataWedgeProfile', dwProfile);
    } catch (error) {
      logger.e("Error in creating a data wedge profile: ${error.toString()}");
    }
  }

  void _onEvent(event) {
    Map barcodeScan = jsonDecode(event);
    scannedBarcodeStreamController.sink.add(barcodeScan['scanData']);
    var barcodeString = "Barcode: ${barcodeScan['scanData']}";
    var barcodeSymbology = "Symbology: ${barcodeScan['symbology']}";
    var scanTime = "At: ${barcodeScan['dateTime']}";
    logger.i('scanned data => $barcodeString, $barcodeSymbology, $scanTime');
  }

  void _onError(Object object, StackTrace stackTrace) {
    logger.e("Error object $object, ${stackTrace.toString()}");
    logger.e('Error while receiving the scan result.');

  }
  //endregion

  //region Handle Scan
  void startScan() {
    sendDataWedgeCommand(
        PlatformChannelConstants.dataWedgeSoftScanTrigger, "START_SCANNING");
  }

  Future<void> stopScan() async {
    sendDataWedgeCommand(
        PlatformChannelConstants.dataWedgeSoftScanTrigger, "STOP_SCANNING");
  }

  Future<void> enableDataWedge() async {
    // lastScannedBarcode.value = '';
    try {
      await methodChannel.invokeMethod(
          'enableDataWedge');
      logger.d('Enabled scanning');
    } on PlatformException {
      //  Error invoking Android method
      logger.e('Platform exception while enabling the data wedge');
    } catch (error){
      logger.e('Error sending command to dataWedge: ${error.toString()}');
    }
  }

  Future<void> disableDataWedge() async {
    //lastScannedBarcode.value = '';
    try {
      await methodChannel.invokeMethod(
          'disableDataWedge');
      logger.d('Disabled scanning');
    } on PlatformException {
      //  Error invoking Android method
      logger.wtf('Platform exception while try to disable the data wedge');
    } catch (error){
      logger.e('Error sending command to dataWedge: ${error.toString()}');
    }
  }
  //endregion

  //region Other Helpers
  Future sendDataWedgeCommand(String command, String parameter) async {
    try {
      String argumentAsJson = "{\"command\":$command,\"parameter\":$parameter}";
      await methodChannel.invokeMethod(
          'sendDataWedgeCommandStringParameter', argumentAsJson);
    } on PlatformException {
      //  Error invoking Android method
      logger.wtf("platform Exception while sending the data");
    } catch (error){
      logger.e("Error sending command to data wedge: ${error.toString()}");
    }
  }

  void emptyScanResult() {
    scannedBarcodeStreamController.sink.add('');
  }
//endregion

}