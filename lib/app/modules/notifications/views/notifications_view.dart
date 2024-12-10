import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../providers/laravel_provider.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/booking_notification_item_widget.dart';
import '../widgets/new_price_notification_item_widget.dart';
import '../widgets/travel_notification_item_widget.dart';
import '../widgets/notification_item_widget.dart';

class NotificationsView extends GetView<NotificationsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Get.theme.colorScheme.secondary ,
      appBar: AppBar(
        title: Text(
          "Notifications".tr,
          style: Get.textTheme.headline6.merge(TextStyle(color: Colors.white)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () async=> {
            Get.back(),

          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          await controller.refreshNotifications(showMessage: true);
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: Container(
          decoration: BoxDecoration(color: backgroundColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)), ),
          child: ListView(
            primary: true,
            children: <Widget>[
              notificationsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget notificationsList() {
    return Obx(() {
      if (!controller.notifications.isNotEmpty) {
        return CircularLoadingWidget(
          height: 300,
          onCompleteText: "Notification List is Empty".tr,
        );
      } else {
        var _notifications = controller.notifications;
        return ListView.separated(
            itemCount: _notifications.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 7);
            },
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              var _notification = controller.notifications.elementAt(index);
              if (_notification.id != null&& (_notification.title.contains('Travel Create')||_notification.title.contains('Travel has been Accepted / Running')
                  ||_notification.title.contains('Travel has been Completed')||_notification.title.contains('Travel has been cancelled')||_notification.title.contains('Travel has been published')||
                  _notification.title.contains('Air Travel Create')||_notification.title.contains('Air Travel has been Accepted / Running')||_notification.title.contains('Air Travel has been Completed')||
                  _notification.title.contains('Air Travel has been cancelled') || _notification.title.contains('Air Travel has been published'))) {
                return TravelNotificationItemWidget(notification: _notification);
              } else if (_notification.id != null&& (_notification.title.contains('A new Shipping has been created')
                  ||_notification.title.contains('Shipping has been Paid') ||_notification.title.contains('Packages has been delivered')
                  ||_notification.title.contains('Shipping Cancelled')||_notification.title.contains('Shipping has been rated')
                  ||_notification.title.contains('Shipping rejected')||_notification.title.contains('Packages has been received')
                  ||_notification.title.contains('A new Air Shipping has been created') ||_notification.title.contains('Air Shipping has been Paid')
                  ||_notification.title.contains('Air Shipping Packages has been delivered') ||_notification.title.contains('Air Shipping Cancelled')
                  ||_notification.title.contains('Air Shipping has been rated') ||_notification.title.contains('Air Shipping rejected')
                  ||_notification.title.contains('Air Shipping Packages has been received'))) {
                return BookingNotificationItemWidget(notification: _notification);
              } else if (_notification.id != null&& (_notification.title.contains('New proposed price')||_notification.title.contains('Price validated by Shipper')||_notification.title.contains('Price validated by Traveler'))) {
                return NewPriceNotificationItemWidget(notification: _notification);
              } else
              {
                return NotificationItemWidget(
                  notification: _notification,
                  onDismissed: (notification) {
                    notification.message.toLowerCase().contains('road')?
                    controller.removeRoadNotification(notification):
                    controller.removeAirNotification(notification);
                  },
                  onTap: (notification) async {
                    notification.message.toLowerCase().contains('road')?
                    await controller.markAsReadRoadNotification(notification)
                    :await controller.markAsReadAirNotification(notification);
                  },
                );
              }
            });
      }
    });
  }
}