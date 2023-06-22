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

  // Future<MyUser> login(MyUser user) {
  //   _laravelApiClient = Get.find<LaravelApiClient>();
  //   return _laravelApiClient.login(user);
  // }
  //
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
  //
  // Future<bool> sendResetLinkEmail(MyUser user) {
  //   _laravelApiClient = Get.find<LaravelApiClient>();
  //   return _laravelApiClient.sendResetLinkEmail(user);
  // }
  //
  // Future<MyUser> getCurrentUser() {
  //   return this.get(Get.find<MyAuthService>().myUser.value);
  // }

  // Future<void> deleteCurrentUser() async {
  //   _laravelApiClient = Get.find<LaravelApiClient>();
  //   _firebaseProvider = Get.find<FirebaseProvider>();
  //   await _laravelApiClient.deleteUser(Get.find<AuthService>().user.value);
  //   await _firebaseProvider.deleteCurrentUser();
  //   Get.find<AuthService>().user.value = new MyUser();
  //   GetStorage().remove('current_user');
  // }

  // Future<User> register(User user) {
  //   _laravelApiClient = Get.find<LaravelApiClient>();
  //   return _laravelApiClient.register(user);
  //
  // }

  Future <bool> register(MyUser myUser) {
    // _laravelApiClient = Get.find<LaravelApiClient>();
    // return _laravelApiClient.register(user);
    _odooApiClient = Get.find<OdooApiClient>();

    return _odooApiClient.register(myUser);
  }

  // Future<bool> signInWithEmailAndPassword(String email, String password) async {
  //   _firebaseProvider = Get.find<FirebaseProvider>();
  //   return _firebaseProvider.signInWithEmailAndPassword(email, password);
  // }
  //
  // Future<bool> signUpWithEmailAndPassword(String email, String password) async {
  //   _firebaseProvider = Get.find<FirebaseProvider>();
  //   return _firebaseProvider.signUpWithEmailAndPassword(email, password);
  // }
  //
  // Future<void> verifyPhone(String smsCode) async {
  //   _firebaseProvider = Get.find<FirebaseProvider>();
  //   return _firebaseProvider.verifyPhone(smsCode);
  // }
  //
  // Future<void> sendCodeToPhone() async {
  //   _firebaseProvider = Get.find<FirebaseProvider>();
  //   return _firebaseProvider.sendCodeToPhone();
  // }

  Future signOut() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return await _firebaseProvider.signOut();
  }
}
