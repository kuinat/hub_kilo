import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/my_auth_service.dart';
import '../root/controllers/root_controller.dart';

class NotificationsButtonWidget extends GetView<RootController> {
  const NotificationsButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  Widget build(BuildContext context) {
    return MaterialButton(
      hoverElevation: 0,
      highlightElevation: 0,
      elevation: 0,
      onPressed: () async {
        print(Get.find<MyAuthService>().myUser.value.email.toString());
        if (Get.find<MyAuthService>().myUser.value.email != null ) {
          await Get.toNamed(Routes.NOTIFICATIONS);
        } else {
          await Get.toNamed(Routes.LOGIN);
        }
      },
      child: Obx(() => Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 28,
          ),
          if(controller.notificationsCount.value != 0)
            Container(
              child: Center(
                child: Text(
                  controller.notificationsCount.value.toString(),
                  textAlign: TextAlign.center,
                  style: Get.textTheme.caption.merge(
                    TextStyle(color: Get.theme.primaryColor, fontSize: 11, height: 1.4),
                  ),
                ),
              ),
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(color: labelColor ?? specialColor, borderRadius: BorderRadius.all(Radius.circular(10))),
              constraints: BoxConstraints(minWidth: 16, maxWidth: 16, minHeight: 16, maxHeight: 16),
            ),
        ],
      )
      ),
      color: Colors.transparent,
    );
  }
}
