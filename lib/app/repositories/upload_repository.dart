import 'dart:io';

import 'package:get/get.dart';

import '../providers/laravel_provider.dart';
import '../providers/odoo_provider.dart';

class UploadRepository {
  OdooApiClient _odooApiClient;

  UploadRepository() {
    this._odooApiClient = Get.find<OdooApiClient>();
  }

  Future<String> image(File image) {
    print('Nathalie');
    return _odooApiClient.uploadImage(image);

  }

  Future<bool> delete(String uuid) {
    return _odooApiClient.deleteUploaded(uuid);
  }

  Future<bool> deleteAll(List<String> uuids) {
    return _odooApiClient.deleteAllUploaded(uuids);
  }
}
