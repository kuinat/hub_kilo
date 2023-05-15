import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/my_user_model.dart';
import '../models/user_model.dart';
import '../providers/firebase_provider.dart';
import '../providers/laravel_provider.dart';
import '../providers/odoo_provider.dart';
import '../services/auth_service.dart';

class UserRepository {
  LaravelApiClient _laravelApiClient;
  FirebaseProvider _firebaseProvider;
  OdooApiClient _odooApiClient;

  UserRepository() {}


  Future<MyUser> login(MyUser myUser) {
    _odooApiClient = Get.find<OdooApiClient>();
    return _odooApiClient.login(myUser);
  }

  // Future<MyUser> login(MyUser user) {
  //   _laravelApiClient = Get.find<LaravelApiClient>();
  //   return _laravelApiClient.login(user);
  // }
  //
  // Future<MyUser> get(MyUser user) {
  //   _laravelApiClient = Get.find<LaravelApiClient>();
  //   return _laravelApiClient.getUser(user);
  // }

  Future<User> get(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUser(user);
  }

  Future<User> update(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.updateUser(user);
  }

  Future<bool> sendResetLinkEmail(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.sendResetLinkEmail(user);
  }

  Future<User> getCurrentUser() {
    return this.get(Get.find<AuthService>().user.value);
  }

  Future<void> deleteCurrentUser() async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    _firebaseProvider = Get.find<FirebaseProvider>();
    await _laravelApiClient.deleteUser(Get.find<AuthService>().user.value);
    await _firebaseProvider.deleteCurrentUser();
    Get.find<AuthService>().user.value = new User();
    GetStorage().remove('current_user');
  }

  Future<MyUser> register(MyUser myUser) {
    _odooApiClient = Get.find<OdooApiClient>();
    return _odooApiClient.register(myUser);
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signInWithEmailAndPassword(email, password);
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signUpWithEmailAndPassword(email, password);
  }

  Future<void> verifyPhone(String smsCode) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.verifyPhone(smsCode);
  }

  Future<void> sendCodeToPhone() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.sendCodeToPhone();
  }

  Future signOut() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return await _firebaseProvider.signOut();
  }
}
