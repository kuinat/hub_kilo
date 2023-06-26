
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/custom_page_model.dart';
import '../../../providers/odoo_provider.dart';
import '../../../repositories/custom_page_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../account/controllers/account_controller.dart';
import '../../account/views/account_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home2_view.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../../userBookings/views/bookings_view.dart';
import '../../userTravels/controllers/user_travels_controller.dart';
import '../../userTravels/views/userTravels_view.dart';

class RootController extends GetxController {
  final currentIndex = 0.obs;
  final notificationsCount = 0.obs;
  final customPages = <CustomPage>[].obs;
  NotificationRepository _notificationRepository;
  CustomPageRepository _customPageRepository;

  RootController() {
    _notificationRepository = new NotificationRepository();
    _customPageRepository = new CustomPageRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    await getCustomPages();
  }

  List<Widget> pages = [
    Home2View(),
    BookingsView(),
    MyTravelsView(),
    AccountView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  Future<void> changePageInRoot(int _index) async {
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    //print(Get.find<MyAuthService>().myUser.value.name);
    if (Get.find<MyAuthService>().myUser.value.email == null && _index > 0) {
      await Get.offNamed(Routes.LOGIN);
    } else {
      currentIndex.value = _index;
      await refreshPage(_index);
    }
  }

  Future<void> changePageOutRoot(int _index) async {
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    if (Get.find<MyAuthService>().myUser.value.email == null && _index > 0) {
      await Get.toNamed(Routes.LOGIN);
    }else{
      currentIndex.value = _index;
      await refreshPage(_index);
      await Get.offNamedUntil(Routes.ROOT, (Route route) {
        if (route.settings.name == Routes.ROOT) {
          return true;
        }
        return false;
      }, arguments: _index);
    }
  }

  Future<void> changePage(int _index) async {
    if (Get.currentRoute == Routes.ROOT) {
      await changePageInRoot(_index);
    } else {
      await changePageOutRoot(_index);
    }
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          await Get.find<HomeController>().refreshHome();
          break;
        }
      case 1:
        {
          if(Get.find<MyAuthService>().myUser.value.email != null){
            await Get.find<BookingsController>().refreshBookings();
          }
          break;
        }
      case 2:
        {
          if(Get.find<MyAuthService>().myUser.value.email != null){
            await Get.find<UserTravelsController>().refreshMyTravels();
          }
          break;
        }

      case 3:
        {
          if(Get.find<MyAuthService>().myUser.value.email != null){
            Get.lazyPut(()=>AccountController());
            await Get.find<AccountController>().refresh();
          }
          break;
        }
    }
  }

  void getNotificationsCount() async {
    notificationsCount.value = await _notificationRepository.getCount();
  }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }
}
