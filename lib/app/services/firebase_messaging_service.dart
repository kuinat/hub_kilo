import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';

import '../../color_constants.dart';
import '../../common/ui.dart';
import '../../main.dart';
import '../models/booking_model.dart';
import '../models/message_model.dart';
import '../models/notification_model.dart';
import '../modules/messages/controllers/messages_controller.dart';
import '../modules/notifications/controllers/notifications_controller.dart';
import '../modules/root/controllers/root_controller.dart';
import '../routes/app_routes.dart';
import 'auth_service.dart';
import 'my_auth_service.dart';

class FireBaseMessagingService extends GetxService {
  Future<FireBaseMessagingService> init() async {
    //`FirebaseMessaging.instance.requestPermission(sound: true, badge: true, alert: true);
    await requestPermission();
    await setDeviceToken();
    await fcmOnLaunchListeners();
    await fcmOnResumeListeners();
    await fcmOnMessageListeners();
    return this;
  }
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("User permission granted");
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("user granted a provisional permission ");
      }
    } else {
      if (kDebugMode) {
        print("user did not granted permission");
      }

      showDialog(
          context: Get.context,
          builder: (_){
            return AlertDialog(
              content: Container(
                height: 170,
                padding: EdgeInsets.all(10),
                child: Text('Allow your device to receive notifications from Hubkilo in the device settings', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15, color: buttonColor))),
              ),
            );
          });
    }
  }

  Future fcmOnMessageListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      if (Get.isRegistered<RootController>()) {
        //Get.find<RootController>().getNotificationsCount();
      }
      if (message.data['id'] == "App\\Notifications\\NewMessage") {
        _newMessageNotification(message);
      } else {
        _bookingNotification(message);
      }
      var count = 0;
      NotificationsController _notificationController = new NotificationsController();
      var list = await _notificationController.getNotifications(Get.find<MyAuthService>().myUser.value.id);
      for(int i =0; i<list.length; i++ ){
        if(Get.find<MyAuthService>().myUser.value.id==list[i]['sender_partner_id'])
        {
          if(!list[i]['is_seen_sender']){
            count = count +1;
          }
        }
        else{
          if(!list[i]['is_seen_receiver']){
            count = count +1;
          }
        }
      }
      Get.find<RootController>().notificationsCount.value = count ;
    });
  }

  Future fcmOnLaunchListeners() async {
    RemoteMessage message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _notificationsBackground(message);
    }
  }

  Future fcmOnResumeListeners() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      var count = 0;
      NotificationsController _notificationController = new NotificationsController();
      var list = await _notificationController.getNotifications(Get.find<MyAuthService>().myUser.value.id);
      for(int i =0; i<list.length; i++ ){
        if(Get.find<MyAuthService>().myUser.value.id==list[i]['sender_partner_id'])
        {
          if(!list[i]['is_seen_sender']){
            count = count +1;
          }
        }
        else{
          if(!list[i]['is_seen_receiver']){
            count = count +1;
          }
        }
      }
      Get.find<RootController>().notificationsCount.value = count ;

      _notificationsBackground(message);
    });
  }

  void _notificationsBackground(RemoteMessage message) {
    if (message.data['id'] == "App\\Notifications\\NewMessage") {
      _newMessageNotificationBackground(message);
    } else {
      _newBookingNotificationBackground(message);
    }
  }

  void _newBookingNotificationBackground(message) {
    if (Get.isRegistered<RootController>()) {
      Get.toNamed(Routes.BOOKING, arguments: new Booking(id: message.data['bookingId']));
    }
  }

  void _newMessageNotificationBackground(RemoteMessage message) {
    if (message.data['messageId'] != null) {
      Get.toNamed(Routes.CHAT, arguments: new Message([], id: message.data['messageId']));
    }
  }

  Future<void> setDeviceToken() async {
    //Get.find<AuthService>().user.value.deviceToken =
    getToken();
  }

  getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {

      var mtoken = token;
      if (kDebugMode) {
        print("my token is $mtoken");
      }
      Domain.deviceToken = token;
    });

  }

  void _bookingNotification(RemoteMessage message) {
    if (Get.currentRoute == Routes.ROOT) {
      //Get.find<BookingsController>().refreshBookings();
    }
    /*if (Get.currentRoute == Routes.BOOKING) {
      Get.find<BookingsController>().refreshBooking();
    }*/
    RemoteNotification notification = message.notification;
    Get.showSnackbar(Ui.notificationSnackBar(
      title: notification.title,
      message: notification.body,
      mainButton: Image.asset(
        'assets/img/hubcolis.png',
        fit: BoxFit.cover,
        width: 30,
        height: 30,
      ),
      onTap: (getBar) async {
        if (message.data['bookingId'] != null) {
          await Get.back();
          Get.toNamed(Routes.BOOKING, arguments: new Booking(id: message.data['bookingId']));
        }
      },
    ));
  }

  void _newMessageNotification(RemoteMessage message) {
    RemoteNotification notification = message.notification;
    if (Get.find<MessagesController>().initialized) {
      Get.find<MessagesController>().refreshMessages();
    }
    if (Get.currentRoute != Routes.CHAT) {
      Get.showSnackbar(Ui.notificationSnackBar(
        title: notification.title,
        message: notification.body,
        mainButton: Image.asset(
          'assets/img/hubcolis.png',
          fit: BoxFit.cover,
          width: 30,
          height: 30,
        ),
        onTap: (getBar) async {
          if (message.data['messageId'] != null) {
            await Get.back();
            Get.toNamed(Routes.CHAT, arguments: new Message([], id: message.data['messageId']));
          }
        },
      ));
    }
  }
}