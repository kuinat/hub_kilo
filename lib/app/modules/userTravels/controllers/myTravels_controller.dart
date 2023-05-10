import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTravelsController extends GetxController {

  final isDone = false.obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Appliance Repair Company'));
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Shifting Home'));
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Pet Car Company'));
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        //await listenForMessages();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
