import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../services/auth_service.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/rating_controller.dart';

class RatingView extends GetView<RatingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leave a Review".tr,
          style: Get.textTheme.headline5,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: ListView(
        primary: true,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 20),
        children: [
          Column(
            children: [
              Wrap(children: [
                Text("Hi,".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Colors.black))),
                Text(controller.shippingDto['partner_id'][1],
                  style: Get.textTheme.bodyText2.merge(TextStyle(color: Colors.black)),
                )
              ]),
              SizedBox(height: 10),
              Text(
                "How do you feel this services?".tr,
                style: Get.textTheme.bodyText2.merge(TextStyle(color: Colors.black)),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: Get.width,
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                  child: ClipOval(
                    child: FadeInImage(
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      image: NetworkImage('${Domain.serverPort}/image/res.partner/${controller.travellerId}/image_1920?unique=true&file_response=true',
                          headers: Domain.getTokenHeaders()),
                      placeholder: AssetImage(
                          "assets/img/loading.gif"),
                      imageErrorBuilder:
                          (context, error, stackTrace) {
                        return Image.asset(
                            'assets/img/téléchargement (3).png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitWidth);
                      },
                    ),
                  )
                  ),
                  Text(controller.shippingDto['travel_partner_name'],
                    style: Get.textTheme.headline6.merge(TextStyle(color: buttonColor)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Click on the stars to rate this traveller".tr,
                    style: Get.textTheme.caption,
                  ),
                  SizedBox(height: 6),
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return InkWell(
                          onTap: () {
                            controller.rate.value = (index + 1).toInt();
                          },
                          child: index < controller.rate.value
                              ? Icon(Icons.star, size: 40, color: Color(0xFFFFB24D))
                              : Icon(Icons.star_border, size: 40, color: Color(0xFFFFB24D)),
                        );
                      }),
                    );
                  }),
                  SizedBox(height: 30)
                ],
              )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextFieldWidget(
              readOnly: false,
              labelText: "Write your review".tr,
              hintText: "Tell us somethings about this service".tr,
              iconData: Icons.description_outlined,
              onChanged: (text) {
                controller.comment.value = text;
              },
            )
          ),
          SizedBox(height: 20),
          BlockButtonWidget(
              text: Obx(() => !controller.clicked.value ? Text(
                "Submit Review".tr,
                style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
              ) : SizedBox(height: 30,
                  child: SpinKitThreeBounce(color: Colors.white, size: 20))
              ),
              color: Get.theme.colorScheme.secondary,
              onPressed: ()async {

                controller.clicked.value = true;
                controller.shippingDto['booking_type'] == 'By Road'?
                await controller.rateTravellerRoadShipping(controller.shippingDto['id'])
                :await controller.rateTravellerAirShipping(controller.shippingDto['id']);

              }).marginSymmetric(vertical: 10, horizontal: 20)
        ],
      ),
    );
  }
}
