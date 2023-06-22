import 'package:get/get.dart';

import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../controllers/travel_inspect_controller.dart';

class TravelInspectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TravelInspectController>(
      () => TravelInspectController(),
    );
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
  }
}
