import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';

class ValidationController extends GetxController {

  final isDone = false.obs;
  final currentState = 0.obs;
  final validationType = 0.obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        //await listenForMessages();
      }
    });
    super.onInit();
  }

  Future scan() async {
    try {
      ScanResult qrCode = await BarcodeScanner.scan();
      String qrResult = qrCode.rawContent;
      //setState(() => barcode = qrResult);
      return qrResult;

    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        Get.log('The user did not grant the camera permission!');
      } else {
        Get.log('Unknown error: $e');
      }
    } on FormatException{
      Get.log('null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      Get.log('Unknown error: $e');
    }
  }


  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
