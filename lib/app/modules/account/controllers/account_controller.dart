import 'package:get/get.dart';

import '../../../services/my_auth_service.dart';
import '../../root/controllers/root_controller.dart';

class AccountController extends GetxController {
  @override
  void onInit() {

    Get.find<RootController>().getNotificationsCount();
    super.onInit();

  }
}
