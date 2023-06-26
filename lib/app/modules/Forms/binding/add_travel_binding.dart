import 'package:get/get.dart';
import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../controller/add_travel_controller.dart';

class AddTravelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTravelController>(
          () => AddTravelController(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
  }
}
