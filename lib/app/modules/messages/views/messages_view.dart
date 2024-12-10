import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/messages_controller.dart';
import '../widgets/message_item_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessagesView extends GetView<MessagesController> {
  Widget conversationsList() {
    return Obx(
      () {
        if (controller.messages.isNotEmpty) {
          var _messages = controller.messages;
          return ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              controller: controller.scrollController,
              itemCount: _messages.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 7);
              },
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                if (index == controller.messages.length - 1) {
                  return Obx(() {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Center(
                        child: new Opacity(
                          opacity: controller.isLoading.value ? 1 : 0,
                          child: new CircularProgressIndicator(),
                        ),
                      ),
                    );
                  });
                } else {
                  return MessageItemWidget(
                    message: controller.messages.elementAt(index),
                    onDismissed: (conversation) async {
                      await controller.deleteMessage(controller.messages.elementAt(index));
                    },
                  );
                }
              });
        } else {
          return CircularLoadingWidget(
            height: Get.height,
            onCompleteText: AppLocalizations.of(Get.context).noMessageFoundError.tr,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>MessagesController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).chat.tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Get.theme.hintColor),
          onPressed: () => {Scaffold.of(context).openDrawer()},
        ),
        actions: [NotificationsButtonWidget()],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            controller.messages.clear();
            controller.lastDocument = new Rx<DocumentSnapshot>(null);
            await controller.listenForMessages();
          },
          child: conversationsList()),
    );
  }
}
