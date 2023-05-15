import 'package:get/get.dart';

import '../../../services/my_auth_service.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
    // Get.lazyPut<MyAuthService>(
    //       () => MyAuthService(),
    // );
    // Get.lazyPut<My>(
    //       () => MyAuthService(),
    // );

  }
}
