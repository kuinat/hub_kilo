import 'package:get/get.dart';

import '../controllers/available_travels_controller.dart';


class AvailableTravelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AvailableTravelsController>(
          () => AvailableTravelsController(),
    );
  }
}
