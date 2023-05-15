import 'package:get/get.dart';

import '../controllers/travel_inspect_controller.dart';

class TravelInspectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TravelInspectController>(
      () => TravelInspectController(),
    );
  }
}
