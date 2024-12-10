import 'package:get/get.dart';
import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../controller/signal_incident_controller.dart';


class SignalIncidentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignalIncidentController>(
          () => SignalIncidentController(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
  }
}
