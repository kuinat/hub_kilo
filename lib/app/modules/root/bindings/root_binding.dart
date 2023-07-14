import 'package:get/get.dart';

import '../../../services/my_auth_service.dart';
import '../../account/controllers/account_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../../userTravels/controllers/user_travels_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
      () => RootController(),
    );
    Get.put(HomeController(), permanent: true);
    Get.put(BookingsController(), permanent: true);
    Get.lazyPut<BookingsController>(
      () => BookingsController(),
    );
    Get.lazyPut<UserTravelsController>(
      () => UserTravelsController(),
    );
    Get.lazyPut<AccountController>(
      () => AccountController(),
    );
    Get.lazyPut<SearchController>(
      () => SearchController(),
    );
  }
}
