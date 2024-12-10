import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../repositories/booking_repository.dart';
import '../../../services/my_auth_service.dart';
import 'package:http/http.dart' as http;

import '../../userBookings/controllers/bookings_controller.dart';

class RatingController extends GetxController {

  var shippingDto = {}.obs;
  var travellerId = 0.obs;
  var clicked = false.obs;
  var comment = "".obs;
  var rate = 0.obs;
  BookingRepository _bookingRepository;

  RatingController() {
    _bookingRepository = new BookingRepository();
  }

  @override
  void onInit() {
    var arguments = Get.arguments as Map<String, dynamic>;
    shippingDto.value = arguments['shippingDetails'];
    travellerId.value = arguments['travellerId'];

    //review.value.eService = booking.value.eService;
    super.onInit();
  }

  rateTravellerRoadShipping(int shipping_id)async{

    print("$comment, ${Get.find<MyAuthService>().myUser.value.id}");
    Get.lazyPut<BookingsController>(
          () => BookingsController(),
    );
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/res.partner.rating?values=%7B%0A%20%20%22'
        'rater_id%22%3A%20${Get.find<MyAuthService>().myUser.value.id}%2C%0A%20%20%22'
        'rated_id%22%3A%20${travellerId.value}%2C%0A%20%20%22'
        'shipping_id%22%3A%20$shipping_id%2C%0A%20%20%22'
        'rating%22%3A%20%22${rate.value}%22%2C%0A%20%20%22'
        'comment%22%3A%20%22${comment.value}%22%0A%7D&'
        'with_context=%7B%7D&with_company=1'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      clicked.value = false;
      print(data);
      Get.find<BookingsController>().refreshBookings();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Rating made successfully "));
      Navigator.pop(Get.context);
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }

  rateTravellerAirShipping(int shipping_id)async{

    print("$comment, ${Get.find<MyAuthService>().myUser.value.id}");
    Get.lazyPut<BookingsController>(
          () => BookingsController(),
    );
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/res.partner.air.rating?values=%7B%0A%20%20%22'
        'rater_id%22%3A%20${Get.find<MyAuthService>().myUser.value.id}%2C%0A%20%20%22'
        'rated_id%22%3A%20${travellerId.value}%2C%0A%20%20%22'
        'air_shipping_id%22%3A%20$shipping_id%2C%0A%20%20%22'
        'rating%22%3A%20%22${rate.value}%22%2C%0A%20%20%22'
        'comment%22%3A%20%22${comment.value}%22%0A%7D&'
        'with_context=%7B%7D&with_company=1'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      clicked.value = false;
      print(data);
      Get.find<BookingsController>().refreshBookings();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Rating made successfully "));
      Navigator.pop(Get.context);
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }
}
