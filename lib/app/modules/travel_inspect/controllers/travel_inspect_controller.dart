import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/option_model.dart';

class TravelInspectController extends GetxController {
  final currentSlide = 0.obs;
  final quantity = 1.obs;
  final heroTag = ''.obs;
  final travelCard = {}.obs;
  final imageUrl = "".obs;
  final bookingStep = 0.obs;
  final elevation = 0.obs;
  final buttonPressed = false.obs;

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    travelCard.value = arguments['travelCard'];
    heroTag.value = arguments['heroTag'] as String;
    if(travelCard['type'] == "air"){
      imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60";
    }else if(travelCard['type'] == "sea"){
      imageUrl.value = "https://images.unsplash.com/photo-1515678821046-f1ba75cb9f9e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fGNhcmdvJTIwc2hpcCUyMG9uJTIwc2VhfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60";
    }else{
      imageUrl.value = "https://images.unsplash.com/photo-1628110341049-37a92fcbcb14?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fGxhbmQlMjB0cmFuc3BvcnR8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60";
    }
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEService();
    super.onReady();
  }

  Future refreshEService({bool showMessage = false}) async {
    if (showMessage) {
      //Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getEService() async {

  }

  Future getReviews() async {

  }

  TextStyle getTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.bodyText2;
  }

  TextStyle getSubTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.caption.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.caption;
  }

  Color getColor(Option option) {
    if (option.checked.value) {
      return Get.theme.colorScheme.secondary.withOpacity(0.1);
    }
    return null;
  }

  void incrementQuantity() {
    quantity.value < 1000 ? quantity.value++ : null;
  }

  void decrementQuantity() {
    quantity.value > 1 ? quantity.value-- : null;
  }
}
