import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/booking_model.dart';
import '../../../models/notification_model.dart' as model;
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../root/controllers/root_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../controllers/notifications_controller.dart';
import 'notification_item_widget.dart';

class BookingNotificationItemWidget extends GetView<NotificationsController> {
  BookingNotificationItemWidget({Key key, this.notification}) : super(key: key);
  final model.NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return NotificationItemWidget(
      notification: notification,
      onDismissed: (notification) {
        notification.message.toLowerCase().contains('road')?
        controller.removeRoadNotification(notification):
        controller.removeAirNotification(notification);
      },
      icon: Icon(
        Icons.assignment_outlined,
        color: Get.theme.scaffoldBackgroundColor,
        size: 34,
      ),
      onTap: (notification) async {
        print(notification.message);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Loading data..."),
          duration: Duration(seconds: 3),
        ));

        notification.message.toLowerCase().contains('road')?
        await controller.markAsReadRoadNotification(notification)
            :await controller.markAsReadAirNotification(notification);

        var id;
        if (notification.id != null &&
            (notification.title.contains('A new Shipping has been created') || notification.title.contains('A new Air Shipping has been created'))) {
          id = notification.message.substring(
              notification.message.lastIndexOf(':') + 2,
              notification.message.length - 1);
        }

        if (notification.id != null &&
            (notification.title.contains('Shipping has been Paid') ||notification.title.contains('Air Shipping has been Paid') )) {
          id = notification.message.toString().substring(
              notification.message.lastIndexOf(':') + 2,
              notification.message.length - 1);
        }
        if (notification.id != null &&
            (notification.title.contains('Shipping Cancelled') || notification.title.contains('Air Shipping Cancelled'))) {
          id = notification.message.substring(
              notification.message.lastIndexOf(':') + 2,
              notification.message.length - 1);
        }
        if (notification.id != null &&
            (notification.title.contains('Packages has been delivered') || notification.title.contains('Air Shipping Packages has been delivered') )) {
          id = notification.message.substring(
              notification.message.lastIndexOf(':') + 2,
              notification.message.length - 1);
        }
        if (notification.id != null &&
            (notification.title.contains('Shipping has been rated') || notification.title.contains('Air Shipping has been rated'))) {
          id = notification.message.substring(
              notification.message.lastIndexOf(':') + 2,
              notification.message.length - 1);
        }
        if (notification.id != null &&
            (notification.title.contains('Shipping rejected') || notification.title.contains('Air Shipping rejected'))) {
          id = notification.message.substring(
              notification.message.lastIndexOf(':') + 2,
              notification.message.length - 1);
        }
        if (notification.id != null &&
            (notification.title.contains('Packages has been received') || notification.title.contains('Air Shipping Packages has been received'))) {
          id = notification.message.substring(
              notification.message.lastIndexOf(':') + 2,
              notification.message.length - 1);
        }

        Get.find<BookingsController>().shippingDetails.value = notification.message.toLowerCase().contains('road')? await controller.getSingleRoadShipping(int.parse(id)):await controller.getSingleAirShipping(int.parse(id));

        if (Get.find<MyAuthService>().myUser.value.id ==
            Get.find<BookingsController>().shippingDetails['partner_id'][0]) {
          print('id id :' + id.toString());

          if (Get.find<BookingsController>().shippingDetails != null) {
            if(Get.find<BookingsController>()
                .shippingDetails
                .value['travelbooking_id'].toString()!='false'){
              var travelId = Get.find<BookingsController>()
                  .shippingDetails
                  .value['travelbooking_id'][0];

              Get.find<BookingsController>().travelDetails.value =
              notification.message.toLowerCase().contains('road')?
              await controller.getRoadTravelInfo(travelId):
              await controller.getAirTravelInfo(travelId);
              Get.find<BookingsController>().owner.value = true;
              if (Get.find<BookingsController>()
                  .travelDetails['booking_type']
                  .toLowerCase() ==
                  "air") {
                Get.find<BookingsController>().imageUrl.value =
                "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60";
                //"assets/img/istockphoto-1421193265-612x612.jpg";
              } else if (Get.find<BookingsController>()
                  .travelDetails['booking_type']
                  .toLowerCase() ==
                  "sea") {
                Get.find<BookingsController>().imageUrl.value =
                "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=";
              } else {
                Get.find<BookingsController>().imageUrl.value =
                "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=";
              }


              Get.toNamed(Routes.SHIPPING_DETAILS);
            }
            else{
              if(Get.find<BookingsController>()
                  .shippingDetails
                  .value['bool_parcel_reception'].toString()=='false'){

                Get.find<BookingsController>().owner.value = true;
                if (Get.find<BookingsController>()
                    .travelDetails['booking_type'] ==''|| Get.find<BookingsController>()
                    .travelDetails['booking_type'] == "air") {
                  Get.find<BookingsController>().imageUrl.value =
                  "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60";
                  //"assets/img/istockphoto-1421193265-612x612.jpg";
                } else if (Get.find<BookingsController>()
                    .travelDetails['booking_type'] == "sea") {
                  Get.find<BookingsController>().imageUrl.value =
                  "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=";
                } else {
                  Get.find<BookingsController>().imageUrl.value =
                  "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=";
                }


                Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'shippingOffer'});


              }
              else{


                Get.find<BookingsController>().owner.value = true;
                if (Get.find<BookingsController>()
                    .travelDetails['booking_type'] ==''|| Get.find<BookingsController>()
                    .travelDetails['booking_type'] == "air") {
                  Get.find<BookingsController>().imageUrl.value =
                  "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60";
                  //"assets/img/istockphoto-1421193265-612x612.jpg";
                } else if (Get.find<BookingsController>()
                    .travelDetails['booking_type'] == "sea") {
                  Get.find<BookingsController>().imageUrl.value =
                  "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=";
                } else {
                  Get.find<BookingsController>().imageUrl.value =
                  "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=";
                }


                Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'receptionOffer'});



              }



            }

          }
        } else {
          var id;
          if (notification.id != null &&
              (notification.title.contains('A new Shipping has been created') || notification.title.contains('A new Air Shipping has been created'))) {
            id = notification.message.substring(
                notification.message.lastIndexOf(':') + 2,
                notification.message.length - 1);
          }
          if (notification.id != null &&
              (notification.title.contains('Shipping has been Paid') ||notification.title.contains('Air Shipping has been Paid'))) {
            id = notification.message.substring(
                notification.message.lastIndexOf(':') + 2,
                notification.message.length - 1);
          }
          if (notification.id != null &&
              (notification.title.contains('Shipping rejected') || notification.title.contains('Air Shipping rejected'))) {
            id = notification.message.substring(
                notification.message.lastIndexOf(':') + 2,
                notification.message.length - 1);
          }
          if (notification.id != null &&
              (notification.title.contains('Packages has been delivered') || notification.title.contains('Air Shipping Packages has been delivered'))) {
            id = notification.message.substring(
                notification.message.lastIndexOf(':') + 2,
                notification.message.length - 1);
          }

          if (notification.id != null &&
              (notification.title.contains('Packages has been received') || notification.title.contains('Air Shipping Packages has been received'))) {
            id = notification.message.substring(
                notification.message.lastIndexOf(':') + 2,
                notification.message.length - 1);
          }

          print('id is: ' + id.toString());

          Get.find<BookingsController>().shippingDetails.value =
          notification.message.toLowerCase().contains('road')?
              await controller.getSingleRoadShipping(int.parse(id))
          :await controller.getSingleAirShipping(int.parse(id));

    if(Get.find<BookingsController>()
        .shippingDetails
        .value['travelbooking_id'].toString()!='false'){
      var travelId = Get.find<BookingsController>()
          .shippingDetails
          .value['travelbooking_id'][0];
      Get.find<BookingsController>().travelDetails.value =
      notification.message.toLowerCase().contains('road')?
      await controller.getRoadTravelInfo(travelId)
          :await controller.getAirTravelInfo(travelId);
      Get.find<BookingsController>().owner.value = false;
      Get.toNamed(Routes.SHIPPING_DETAILS);

    }
    else{
      Get.find<BookingsController>().owner.value = false;
      Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'shippingOffer'});
    }




        }

      },
    );
  }
}
