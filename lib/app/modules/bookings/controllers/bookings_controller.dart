import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';

class BookingsController extends GetxController {

  final uploading = false.obs;
  var messages = <Message>[].obs;
  var chats = <Chat>[].obs;
  File imageFile;
  Rx<DocumentSnapshot> lastDocument = new Rx<DocumentSnapshot>(null);
  final isLoading = true.obs;
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
