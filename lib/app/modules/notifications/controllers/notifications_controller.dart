import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/notification_model.dart';
import '../../../repositories/notification_repository.dart';
import '../../../services/my_auth_service.dart';
import '../../root/controllers/root_controller.dart';
import 'package:http/http.dart' as http;

class NotificationsController extends GetxController {
  final notifications = [].obs;
  final travelId = 0.obs;
  final chatInfo = {}.obs;
  NotificationRepository _notificationRepository;

  NotificationsController() {
    _notificationRepository = new NotificationRepository();
  }

  @override
  void onInit() async {
    await refreshNotifications();
    super.onInit();
  }

  Future refreshNotifications({bool showMessage}) async {
    //await getBackgroundMessage();
    print(Get.find<MyAuthService>().myUser.value.id.toString());
    var backendList = await getNotifications(Get.find<MyAuthService>().myUser.value.id);
    notifications.clear();
    for (var i = 0; i < backendList.length; i++) {
      var list = backendList[backendList.length-i-1];
      final remoteModel = NotificationModel(
        title: list['message_title']?.toString(),
        id: list['id'].toString(),
        isSeen: Get.find<MyAuthService>().myUser.value.id==list['sender_partner_id']?list['is_seen_sender']:list['is_seen_receiver'],
        disable: Get.find<MyAuthService>().myUser.value.id==list['sender_partner_id']?list['disable_sender']:list['disable_receiver'],
        message: list['message_body'].toString(),
         timestamp: DateTime.parse(
             list['date']));

        notifications.add(remoteModel);
    }
    Get.find<RootController>().getNotificationsCount();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of notifications refreshed successfully".tr));
    }
  }

  Future getNotifications(int id) async {
    List mixedList = await getRoadNotifications(id);
    List list = await getAirNotifications(id);
    mixedList.addAll(list);
    print(mixedList[0]["date"]);
    mixedList.sort((a, b) => a["date"].compareTo(b["date"]));

    return mixedList;

  }

  Future getRoadNotifications(int id) async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'application/json',
      'Cookie': 'session_id=085c0cea6eee505de4ba514f6f047c75c4fec916'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com/notification_log/$id'));
    request.body = json.encode({
      "jsonrpc": "2.0"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)['result'];
      print(data);
      return data;
    }
    else {
      print(await response.stream.bytesToString());
      //Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
      throw new Exception(response.reasonPhrase);

    }

  }


  Future getAirNotifications(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'application/json',
      'Cookie': 'session_id=085c0cea6eee505de4ba514f6f047c75c4fec916'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com/air/notification_log/$id'));
    request.body = json.encode({
      "jsonrpc": "2.0"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)['result'];
      print(data);
      return data;
    }
    else {
      print(await response.stream.bytesToString());
      //Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));

      throw new Exception(response.reasonPhrase);
    }

  }



  Future removeRoadNotification(NotificationModel notification) async {
    int id = Get.find<MyAuthService>().myUser.value.id;
    print(notification.id.toString());

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'application/json',
      'Cookie': 'session_id=e536037690fd3282cd435ebef92904895831bd01'
    };
    var request = http.Request('PUT', Uri.parse('https://preprod.hubkilo.com/notification_log/disable/${int.parse(notification.id)}/$id'));
    request.body = json.encode({
      "jsonrpc": "2.0"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      await refreshNotifications();
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future removeAirNotification(NotificationModel notification) async {
    int id = Get.find<MyAuthService>().myUser.value.id;
    print(notification.id.toString());

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'application/json',
      'Cookie': 'session_id=e536037690fd3282cd435ebef92904895831bd01'
    };
    var request = http.Request('PUT', Uri.parse('https://preprod.hubkilo.com/air/notification_log/disable/${int.parse(notification.id)}/$id'));
    request.body = json.encode({
      "jsonrpc": "2.0"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      await refreshNotifications();
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future markAsReadRoadNotification(NotificationModel notification) async {
    int id = Get.find<MyAuthService>().myUser.value.id;
    if(notification.isSeen==false){

      var headers = {
        'Accept': 'application/json',
        'Authorization': Domain.authorization,
        'Content-Type': 'application/json',
        'Cookie': 'session_id=085c0cea6eee505de4ba514f6f047c75c4fec916'
      };
      var request = http.Request('PUT', Uri.parse('https://preprod.hubkilo.com/notification_log/mark_seen/${int.parse(notification.id)}/$id'));
      request.body = json.encode({
        "jsonrpc": "2.0"
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200){
        print(await response.stream.bytesToString());
        await refreshNotifications();
      }
      else {
        print(response.reasonPhrase);
      }

    }


  }

  Future markAsReadAirNotification(NotificationModel notification) async {
    int id = Get.find<MyAuthService>().myUser.value.id;
    if(notification.isSeen==false){

      var headers = {
        'Accept': 'application/json',
        'Authorization': Domain.authorization,
        'Content-Type': 'application/json',
        'Cookie': 'session_id=085c0cea6eee505de4ba514f6f047c75c4fec916'
      };
      var request = http.Request('PUT', Uri.parse('https://preprod.hubkilo.com/air/notification_log/mark_seen/${int.parse(notification.id)}/$id'));
      request.body = json.encode({
        "jsonrpc": "2.0"
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200){
        print(await response.stream.bytesToString());
        await refreshNotifications();
      }
      else {
        print(response.reasonPhrase);
      }

    }


  }


  Future getRoadTravelInfo(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7c27b4e93f894c9b8b48cad4e00bb4892b5afd83'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return json.decode(data)[0];
    }
    else {
      var data = await response.stream.bytesToString();
      //isLoading.value = false;
      //print(data);
    }
  }

  Future getAirTravelInfo(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7c27b4e93f894c9b8b48cad4e00bb4892b5afd83'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.travelbooking?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return json.decode(data)[0];
    }
    else {
      var data = await response.stream.bytesToString();
      //isLoading.value = false;
      //print(data);
    }
  }

  getSingleRoadShipping(int id) async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.shipping?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print(result);
      return json.decode(result)[0];
    }
    else {
      print(response.reasonPhrase);
    }

  }

  getSingleAirShipping(int id) async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.shipping?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print(result);
      return json.decode(result)[0];
    }
    else {
      print(response.reasonPhrase);
    }

  }

}