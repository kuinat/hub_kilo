import 'package:get/get.dart';

import '../controller/validation_controller.dart';


class ValidationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ValidationController>(
          () => ValidationController(),
    );
  }
}
