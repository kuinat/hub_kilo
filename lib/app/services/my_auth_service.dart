import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/my_user_model.dart';
import '../repositories/user_repository.dart';
import 'settings_service.dart';

class MyAuthService extends GetxService {
  final myUser = MyUser().obs;
  GetStorage _box;

  UserRepository _usersRepo;

  MyAuthService() {
    _usersRepo = new UserRepository();
    _box = new GetStorage();
  }

  Future<MyAuthService> init() async {
    myUser.listen((MyUser _user) {
      if (Get.isRegistered<SettingsService>()) {
        //Get.find<SettingsService>().address.value.userId = _user.id;
      }
      _box.write('current_user', _user.toJson());
    });
    await getCurrentUser();
    return this;
  }

  Future getCurrentUser() async {

    myUser.value = MyUser.fromJson(await _box.read('current_user'));
    // if (myUser.value.auth == null && _box.hasData('current_user')) {
    //   myUser.value = MyUser.fromJson(await _box.read('current_user'));
    //   myUser.value.auth = true;
    // } else {
    //   myUser.value.auth = false;
    // }
  }

  Future removeCurrentUser() async {
    myUser.value = new MyUser();
    await _usersRepo.signOut();
    await _box.remove('current_user');
  }

  //bool get isAuth => myUser.value.auth ?? false;

  //String get apiToken => (myUser.value.auth ?? false) ? myUser.value.apiToken : '';
}
