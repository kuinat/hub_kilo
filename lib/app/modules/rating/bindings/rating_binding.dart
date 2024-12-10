import 'package:get/get.dart';

import '../../../services/my_auth_service.dart';
import '../controllers/rating_controller.dart';

class RatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RatingController>(
      () => RatingController(),
    );
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
  }
}
