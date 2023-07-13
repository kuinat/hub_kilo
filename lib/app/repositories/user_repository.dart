import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/my_user_model.dart';
import '../models/user_model.dart';
import '../providers/firebase_provider.dart';
import '../providers/laravel_provider.dart';
import '../providers/odoo_provider.dart';
import '../services/auth_service.dart';
import '../services/my_auth_service.dart';

class UserRepository {
  LaravelApiClient _laravelApiClient;
  OdooApiClient _odooApiClient;
  FirebaseProvider _firebaseProvider;

  UserRepository() {}

  Future login<int>(MyUser myUser) {
    _odooApiClient = Get.find<OdooApiClient>();
    return _odooApiClient.login(myUser);
  }

  Future<MyUser> get(int id) {
    _odooApiClient = Get.find<OdooApiClient>();
    return _odooApiClient.getUser(id);
  }

   update(MyUser myUser) {
    //print("Nath");
    _odooApiClient = Get.find<OdooApiClient>();
    //print("Nathalie");
    return _odooApiClient.updateUser(myUser);
  }

  Future <bool> register(MyUser myUser) {
    // _laravelApiClient = Get.find<LaravelApiClient>();
    // return _laravelApiClient.register(user);
    _odooApiClient = Get.find<OdooApiClient>();

    return _odooApiClient.register(myUser);
  }

  Future signOut() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return await _firebaseProvider.signOut();
  }
}
