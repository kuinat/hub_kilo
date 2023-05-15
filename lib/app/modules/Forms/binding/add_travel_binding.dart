import 'package:get/get.dart';
import '../controller/add_travel_controller.dart';

class AddTravelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTravelController>(
          () => AddTravelController(),
    );
  }
}
