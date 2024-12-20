import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as dio;
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';

import '../../common/ui.dart';
import '../../main.dart';
import '../models/my_user_model.dart';
import '../services/my_auth_service.dart';
import 'api_provider.dart';
import 'dio_client.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OdooApiClient extends GetxService with ApiClient {
  DioClient _httpClient;
  dio.Options _optionsNetwork;
  dio.Options _optionsCache;

  OdooApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl;
    _httpClient = DioClient(this.baseUrl, new dio.Dio());
  }

  Future<OdooApiClient> init() async {
    _optionsNetwork = _httpClient.optionsNetwork;
    _optionsCache = _httpClient.optionsCache;
    return this;
  }

  bool isLoading({String task, List<String> tasks}) {
    return _httpClient.isLoading(task: task, tasks: tasks);
  }

  Future<MyUser>getUser(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)[0];
      var myuser = MyUser(
          email: data['email'].toString(),
          birthday: data['birthdate']==false?'--/--/--':data['birthdate'],
          isTraveller: data['is_traveler'],
          phone: data['phone'].toString(),
          street: data['residence_city_id']==false?'--':data['residence_city_id'][1],
          sex: data['gender'].toString(),
          name: data['name'],
          birthplace: data['birth_city_id']==false?'--':data['birth_city_id'][1],
          id: data['id'],
          userId: data['user_ids'][0],
          image: data['image_1920'].toString(),
          partnerAttachmentIds: data['partner_attachment_ids'],
          deviceTokenIds: data['fcm_token_ids'],
          isProfessional: data['is_company'],
          vat: data['vat'].toString(),
          airTravelIds: data['air_travelbooking_ids'],
          roadTravelIds: data['travelbooking_ids'],
          bankIds: data['bank_ids']

      );
      print('user:  '+myuser.toString());

      return myuser;

    } else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }

  Future <int>login(MyUser myUser) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=dc69145b99f377c902d29e0b11e6ea9bb1a6a1ba'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com/web/session/authenticate'));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "db": "preprod.hubkilo.com",
        "login": myUser.email,
        "password": myUser.password
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)['result'];
      print(data);
      if(data != null){
        var partnerId = data['partner_id'];

        return partnerId;
      }
      else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).loginError));
        return 0;
        //throw new Exception(response.reasonPhrase);
      }
    }
    else {Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).unknownError));
    }

  }


  Future <bool> register(MyUser myUser) async {

    Random random = Random();
    var _randomNumber = random.nextInt(9999);
    print(_randomNumber);

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST',Uri.parse('${Domain.serverPort}/create/res.users?values={ '
        '"name": "${myUser.name}",'
        '"login": "${myUser.email}",'
        '"image_1920": false,'
        '"email": "${myUser.email}",'
        '"password": "${myUser.password}",'
        '"phone": "${myUser.phone}",'
        '"verification_code": "$_randomNumber",'
        '"sel_groups_1_9_10": 10}'
    ));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200)  {
    var result = await response.stream.bytesToString();
    var data = json.decode(result);
    //await updatePartnerEmail(data[0], myUser.email);
    //await updatePartnerGender(data[0], myUser.sex);
    await updateToPortalUser(data[0]);

    return true;
  }
  else {
  print(response.reasonPhrase);
  var data = await response.stream.bytesToString();
  Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
  return false;
  }

}

  Future<bool> sendResetLinkEmail(MyUser user) async {
    Uri _uri = getApiBaseUri("send_reset_link_email");
    Get.log(_uri.toString());
    // to remove other attributes from the user object
    user = new MyUser(email: user.email);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

   updateUser(MyUser myUser) async {
     var headers = {
       'Accept': 'application/json',
       'Authorization': Domain.authorization
     };

     var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.users?ids=${myUser.userId}&values={'
         '"name": "${myUser.name}",'
         '"login": "${myUser.email}",'
         '"email": "${myUser.email}"}'
     ));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      await updatePartner(myUser);
    }
    else {
      print(response.reasonPhrase);
    }

  }

  updatePartner(MyUser myUser) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.partner?ids=${myUser.id}&values={'
        '"phone": "${myUser.phone}",'
        '"birth_city_id": "${myUser.birthplace}",'
        '"residence_city_id": "${myUser.street}",'
        '"gender": "${myUser.sex}",'
        '"birthdate":"${myUser.birthday}"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print(myUser.birthplace);
      print(myUser.street);

    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }

  updateToTraveler(bool value, MyUser myser) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=dc69145b99f377c902d29e0b11e6ea9bb1a6a1ba'
    };

    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.users?ids=${myser.userId}&values={'
        '"is_traveler": "$value"}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

  updateToShipper(bool value, MyUser myUser) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=dc69145b99f377c902d29e0b11e6ea9bb1a6a1ba'
    };

    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.users?ids=${myUser.userId}&values={'
        '"is_shipper": "$value"}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  updateToPortalUser(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=d04af03f698078c752b685cba7f34e4cbb3f208b'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.users?ids=$id&values={'
        '"sel_groups_1_9_10": 9}'
    ));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

    }
    else {
    var data = await response.stream.bytesToString();
    Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }

  Future<String> uploadImage(File file, MyUser myUser) async {

    if (Get.find<MyAuthService>().myUser.value.email==null) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ uploadImage() ]");
    }

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'multipart/form-data',
      'Cookie': 'session_id=a5b5f221b0eca50ae954ad4923fead1063097951'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverPort}/upload/res.partner/${myUser.id}/image_1920'));
    request.files.add(await http.MultipartFile.fromPath('ufile', file.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {
      print("Yrreee: "+await response.stream.bytesToString());
      //var user = await getUser();
      //var uuid =user.image ;

      //return uuid;
    }
    else {
      print(response.reasonPhrase);
    }
  }



  Future<String> uploadRoadPacketImage(imageFiles, bookingId) async {
    if (Get.find<MyAuthService>().myUser.value.email==null) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ uploadImage() ]");
    }
    final box = GetStorage();
    var sessionId = box.read('session_id');

    var headers = {
      'Cookie': sessionId.toString()
    };

    var request = http.MultipartRequest('PUT', Uri.parse(Domain.serverPort+'/road/booking/luggage_image/'+bookingId.toString()));
    request.files.add(await http.MultipartFile.fromPath('luggage_image1', imageFiles[0].path));
    request.files.add(await http.MultipartFile.fromPath('luggage_image2', imageFiles[1].path));
    request.files.add(await http.MultipartFile.fromPath('luggage_image3', imageFiles[2].path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

    }
    else {
      print(response.reasonPhrase);
    }
  }



  Future<String> uploadAirPacketImage(imageFiles, bookingId) async {

    if (Get.find<MyAuthService>().myUser.value.email==null) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ uploadImage() ]");
    }
    final box = GetStorage();
    var sessionId = box.read('session_id');

    var headers = {
      'Cookie': sessionId.toString()
    };

    var request = http.MultipartRequest('PUT', Uri.parse(Domain.serverPort+'/air/booking/luggage_image/'+bookingId.toString()));
    request.files.add(await http.MultipartFile.fromPath('luggage_image1', imageFiles[0].path));
    request.files.add(await http.MultipartFile.fromPath('luggage_image2', imageFiles[1].path));
    request.files.add(await http.MultipartFile.fromPath('luggage_image3', imageFiles[2].path));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

    }
    else {
      print(response.reasonPhrase);
    }
  }


  Future<bool> deleteUploaded(String uuid) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: {'uuid': uuid});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteAllUploaded(List<String> uuids) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: {'uuid': uuids});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }
}
