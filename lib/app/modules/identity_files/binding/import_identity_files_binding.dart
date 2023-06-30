import 'package:get/get.dart';
import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../controller/import_identity_files_controller.dart';


class ImportIdentityFilesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImportIdentityFilesController>(
          () => ImportIdentityFilesController(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
  }
}
