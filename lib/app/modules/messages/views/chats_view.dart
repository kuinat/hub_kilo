import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/messages_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../color_constants.dart';

// ignore: must_be_immutable

class ChatsView extends GetView<MessagesController> {
  final _myListKey = GlobalKey<AnimatedListState>();


  Widget chatList() {
    return Obx(
          () {
        if (controller.isLoading.value) {
          return CircularLoadingWidget(
            height: Get.height,
            onCompleteText: "Type a message to start chat!".tr,
          );
        } else {
          return ListView.builder(
              key: _myListKey,
              reverse: true,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              itemCount: controller.messages.length,
              shrinkWrap: false,
              primary: true,
              itemBuilder: (context, index) {
                Future.delayed(Duration.zero, (){
                  controller.messages.sort((a, b) => b["date"].compareTo(a["date"]));
                });
                //Chat _chat = controller.chats.elementAt(index);
                //_chat.user = controller.message.value.users.firstWhere((_user) => _user.id == _chat.userId, orElse: () => new User(name: "-", avatar: new Media()));
                return Column(
                  children: [
                    if(Get.find<MyAuthService>().myUser.value.id == controller.messages[index]['sender_id'])
                      getSentMessageTextLayout(context, controller.messages[index]),
                    if(Get.find<MyAuthService>().myUser.value.id == controller.messages[index]['receiver_id'])
                      getReceivedMessageTextLayout(context, controller.messages[index])
                  ],
                );
              }
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<MessagesController>(
          () => MessagesController(),
    );
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    /*controller.message.value = Get.arguments as Message;
    if (controller.message.value.id != null) {
      controller.listenForChats();
    }*/
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                onPressed: () async {
                  /*controller.message.value = new Message([]);
              controller.chats.clear();
              await controller.refreshMessages();*/
                  controller.stopTimer();
                  Get.back();
                }
            ),
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                        image: NetworkImage(
                            controller.bookingCard['travel']['traveler']['user_id'].toString() != 'false' ? '${Domain.serverPort}/web/image/res.partner/${controller.bookingCard['travel']['traveler']['user_id']}/image_1920'
                            : "https://w7.pngwing.com/pngs/81/570/png-transparent-profile-logo-computer-icons-user-user-blue-heroes-logo-thumbnail.png"),
                        fit: BoxFit.cover
                    )
                )
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 90,
        title: Obx(() {
          return Text(controller.bookingCard['travel']['traveler']['user_name'],
            //controller.message.value.name,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: Get.textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          );
        }),
      ),

      body: RefreshIndicator(
        onRefresh: ()async{
          controller.onInit();
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                    color: background
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          FaIcon(FontAwesomeIcons.planeDeparture),
                          SizedBox(height: 10),
                          Text(controller.bookingCard['travel']['departure_town'],
                              //controller.travelCard['departure_date'].toString(),
                              style: Get.textTheme.headline1.merge(TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
                        ],
                      ),
                      FaIcon(FontAwesomeIcons.arrowRight),
                      Column(
                          children: [
                            FaIcon(FontAwesomeIcons.planeArrival),
                            SizedBox(height: 10),
                            Text(controller.bookingCard['travel']['arrival_town'],
                                //controller.travelCard['arrival_date'].toString(),
                                style: Get.textTheme.headline1.merge(TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
                          ]
                      )
                    ]
                )
            ),
            Expanded(
                child: chatList()
            ),
            Container(
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, -4), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.chatTextController,
                      style: Get.textTheme.bodyText1.merge(TextStyle(fontSize: 18)),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        hintText: "Enter your proposition".tr,
                        hintStyle: TextStyle(color: Get.theme.focusColor.withOpacity(0.8)),
                        suffixIcon: IconButton(
                          padding: EdgeInsetsDirectional.only(end: 20, start: 10),
                          onPressed: () {
                            //controller.messages.add(controller.chatTextController.text);
                            controller.sendMessage(
                                controller.bookingCard['travel']['traveler']['user_id']
                            );
                            //controller.addMessage(controller.message.value, controller.chatTextController.text);
                            Timer(Duration(milliseconds: 100), () {
                              controller.chatTextController.clear();
                            });
                          },
                          icon: Icon(
                            Icons.send_outlined,
                            color: Get.theme.colorScheme.secondary,
                            size: 30,
                          ),
                        ),
                        border: UnderlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Widget getSentMessageTextLayout(context, var message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Get.theme.focusColor.withOpacity(0.2),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(width: 15),
                new Flexible(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Text(Get.find<MyAuthService>().myUser.value.name, style: Get.textTheme.bodyText2.merge(TextStyle(fontWeight: FontWeight.w600, fontSize: 18))),
                      new Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: new Text(message['message'].toString(), style: Get.textTheme.bodyText1.merge(TextStyle( fontSize: 18))),
                      ),
                    ],
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  width: 42,
                  height: 42,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(42)),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: '${Domain.serverPort}/web/image/res.partner/${Get.find<MyAuthService>().myUser.value.id}/image_1920',
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              DateFormat('d, MMMM y | HH:mm', Get.locale.toString()).format(DateTime.parse(message['date'])),
              overflow: TextOverflow.fade,
              softWrap: false, style: Get.textTheme.headline1.merge(TextStyle(color: appColor,fontSize: 13))
            ),
          )
        ],
      ),
    );
  }

  Widget getReceivedMessageTextLayout(context, var message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 42,
                    height: 42,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(42)),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: '${Domain.serverPort}/web/image/res.partner/${controller.bookingCard['sender']['sender_id']}/image_1920',
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                  new Flexible(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(message['travel_booking']['travel']['traveler']['user_name'], style: Get.textTheme.bodyText2.merge(TextStyle(fontWeight: FontWeight.w600, color: Get.theme.primaryColor, fontSize: 18))),
                        new Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: new Text(
                            message['message'].toString(),
                            style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.primaryColor, fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  DateFormat('HH:mm | d, MMMM y', Get.locale.toString()).format(DateTime.parse(message['date'])),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: Get.textTheme.headline1.merge(TextStyle(color: appColor,fontSize: 13))
              ),
            )
          ],
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: validateColor,
            ),
            onPressed: (){
              Get.showSnackbar(Ui.SuccessSnackBar(message: "I accept ${message['message']} ".tr));
            },
            child: Text('Accept', style: Get.textTheme.headline2.merge(TextStyle(color: Colors.white, fontSize: 13)))
        )
      ],
    );
  }

}
