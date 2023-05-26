import 'package:get/get.dart';

import '../controllers/messages_controller.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessagesController>(
          () => MessagesController(),
    );
  }
}
