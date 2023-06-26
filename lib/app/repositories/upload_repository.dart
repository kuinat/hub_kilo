import 'dart:io';

import 'package:get/get.dart';

import '../models/my_user_model.dart';
import '../providers/laravel_provider.dart';
import '../providers/odoo_provider.dart';

class UploadRepository {
  OdooApiClient _odooApiClient;

  UploadRepository() {
    this._odooApiClient = Get.find<OdooApiClient>();
  }

  Future image(File image, MyUser myser) {
    print('Nathalie');
    return _odooApiClient.uploadImage(image, myser);

  }

  Future<String> airImagePacket(List imageFiles, bookingId) {

    return _odooApiClient.uploadAirPacketImage(imageFiles, bookingId);

  }

  Future<String> roadImagePacket(List imageFiles, bookingId) {
    print('Nathalie');
    return _odooApiClient.uploadRoadPacketImage(imageFiles, bookingId);

  }

  Future<bool> delete(String uuid) {
    return _odooApiClient.deleteUploaded(uuid);
  }

  Future<bool> deleteAll(List<String> uuids) {
    return _odooApiClient.deleteAllUploaded(uuids);
  }
}
