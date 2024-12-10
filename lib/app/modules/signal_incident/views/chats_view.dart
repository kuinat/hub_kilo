import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../main.dart';
import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controller/signal_incident_controller.dart';
import '../../../../color_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable

class ChatsView extends GetView<SignalIncidentController> {
  final _myListKey = GlobalKey<AnimatedListState>();
  final int ticketId;
  final String code;

  ChatsView(this.ticketId, this.code);


  Widget chatList() {
    return Obx(
          () {
        if (controller.isLoading.value) {
          return CircularLoadingWidget(
            height: Get.height,
            onCompleteText: AppLocalizations.of(Get.context).messageStartChat.tr,
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
                List receivedMessages = [];
                Future.delayed(Duration.zero, (){
                  controller.messages.sort((a, b) => b["date"].compareTo(a["date"]));
                });
                if(Get.find<MyAuthService>().myUser.value.id != controller.messages[index]['author_id']){
                  receivedMessages.add(controller.messages[index]);
                }

                return Column(
                  children: [
                    if(Get.find<MyAuthService>().myUser.value.id == controller.messages[index]['author_id'])...[
                      getSentMessageTextLayout(context, controller.messages[index], index),
                      if(index == 0)...[
                        for(var a in controller.messagesSent)...[
                            getSentMessage(context, a)
                        ],
                      ],
                    ]else...[
                      getReceivedMessageTextLayout(context, controller.messages[index], index),
                    ],
                    ]
                );
              }
          );
        }
      },
    );
  }
  Widget imageContainer() {
    return Obx(
          () {
            return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index){
                  return Stack(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.file(
                              controller.ticketFiles[index],
                              fit: BoxFit.cover,
                              width: Get.width,
                              height:Get.height/1.4,
                            ),
                          )
                      ),
                      Positioned(
                        top:0,
                        right:0,
                        child: Align
                          (
                          //alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: (){
                                controller.ticketFiles.removeAt(index);
                                controller.enableImageSend.value = false;
                              },
                              icon: Icon(Icons.delete, color: inactive, size: 25, )
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index){
                  return SizedBox(width: 8);
                },
                itemCount: controller.ticketFiles.length);

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<SignalIncidentController>(
          () => SignalIncidentController(),
    );
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );

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
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            Obx(() => ClipOval(
                child: FadeInImage(
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    image: NetworkImage('${Domain.serverPort}/image/res.partner/${controller.receiver_id.value}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                    placeholder: AssetImage(
                        "assets/img/loading.gif"),
                    imageErrorBuilder:
                        (context, error, stackTrace) {
                      return Image.asset(
                          'assets/img/téléchargement (3).png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.fitWidth);
                    }
                )
            )),
          ],
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 110,
        title: Text(code ,
            //controller.message.value.name,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15, color: appColor)),
          )
      ),

      body: RefreshIndicator(
        onRefresh: ()async{
          print(Get.width);
          controller.refreshMessages();
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
           Obx(() =>  Expanded(
               child:!controller.enableImageSend.value? chatList(): imageContainer()
           ),),
            Container(
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, -4), blurRadius: 10)],
              ),
              child:  Obx(() => Row(
                children: [
                  SizedBox(
                      width: Get.width-Get.width/80,
                      height: 80,
                      child: TextFormField(
                        controller: controller.chatTextController,
                        style: Get.textTheme.bodyText1.merge(TextStyle(fontSize: 18)),
                        //expands: true,
                        //keyboardType: TextInputType.number,
                        maxLines: 5,
                        onChanged: (value)=> controller.checkValue(value),

                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          hintText: 'Comment here'.tr,
                          hintStyle: TextStyle(color: Get.theme.focusColor.withOpacity(0.8)),
                          suffix: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  IconButton(
                                      onPressed: () async {
                                    //controller.ticketFiles.clear();
                                        controller.ticketFiles.clear();
                                    await controller.pickImage(ImageSource.gallery);

                                    //Navigator.pop(Get.context);
                                    controller.enableImageSend.value = true;
                                  }, icon: Icon(Icons.attach_file)),

                                  IconButton(
                                    padding: EdgeInsetsDirectional.only(end: 10, start: 10),
                                    onPressed: () async{
                                      if(controller.enableImageSend.value){

                                        print(controller.enableImageSend.value);
                                        String message = '';
                                        message = controller.chatTextController.text;
                                        await controller.messagesSent.add([controller.ticketFiles[controller.ticketFiles.length-1], message]);
                                        print(controller.messagesSent);
                                        var messageId = await controller.sendMessage(ticketId, Get.find<MyAuthService>().myUser.value.id, message);
                                        await controller.uploadTicketMessageImage(ticketId, controller.ticketFiles[controller.ticketFiles.length-1],messageId );
                                        Timer(Duration(milliseconds: 100), () {
                                          controller.chatTextController.clear();
                                          controller.enableImageSend.value = false;
                                          controller.enableSend.value = false;
                                        });


                                      }
                                      else{

                                        String message = '';
                                        message = controller.chatTextController.text;
                                        if(message.isNotEmpty){
                                          controller.messagesSent.add(message);
                                          controller.sendMessage(ticketId, Get.find<MyAuthService>().myUser.value.id, message);
                                          Timer(Duration(milliseconds: 100), () {
                                            controller.chatTextController.clear();
                                            controller.enableSend.value = false;
                                          });
                                        }
                                      }



                                    },
                                    icon: Icon(
                                      Icons.send_outlined,
                                      color: controller.enableSend.value ? Get.theme.colorScheme.secondary : inactive,
                                      size: 30,
                                    ),
                                  )
                                ],
                              )
                          ),
                          border: UnderlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ))
                ],
              )),
            )
          ],
        )
      ),
    );
  }

  Widget getSentMessageTextLayout(context, var message, int index) {
    print(message['attachment_ids']);
    return Container(
      constraints: BoxConstraints(
        maxWidth: Get.width
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.loose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Get.theme.focusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    //constraints: BoxConstraints(
                    //  maxWidth: Get.width - 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(text: message['body'].length<4?'':message['body'].substring(3,message['body'].toString().length-4)+ "\n", style: Get.textTheme.bodyText1.merge(TextStyle( fontSize: 14, color: Colors.black))),
                                  ]
                              )
                          )
                        ),
                        message['attachment_ids'].toString() != '[]'?
                        GestureDetector(
                          onTap: (){
                            showDialog(
                                context: context, builder: (_){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Material(
                                      child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close, size: 20))
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: FadeInImage(
                                      width: Get.width,
                                      height: Get.height/2,
                                      fit: BoxFit.cover,
                                      image: NetworkImage('https://preprod.hubkilo.com/ticket/attachment/${message['attachment_ids'][0]}?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                                      placeholder: AssetImage(
                                          "assets/img/loading.gif"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                            child: Container(
                                                width: Get.width/1.5,
                                                height: Get.height/3,
                                                color: Colors.white,
                                                child: Center(
                                                    child: Icon(Icons.person, size: 150)
                                                )
                                            )
                                        );
                                      },
                                    ),
                                  )
                                ],
                              );
                            });
                          },
                          child: Card(
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: FadeInImage(
                                    width: 120,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    image: NetworkImage('https://preprod.hubkilo.com/ticket/attachment/${message['attachment_ids'][0]}?unique=true&file_response=true',
                                        headers: Domain.getTokenHeaders()),
                                    placeholder: AssetImage(
                                        "assets/img/loading.gif"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/img/240_F_89551596_LdHAZRwz3i4EM4J0NHNHy2hEUYDfXc0j.jpg',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fitWidth);
                                    },
                                  )
                              )
                          ),
                        )
                            :SizedBox()
                      ]
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text( DateFormat('d, MMM y | HH:mm').format(DateTime.parse(message['date'])),
                        overflow: TextOverflow.fade,
                        softWrap: false, style: Get.textTheme.headline1.merge(TextStyle(color: appColor,fontSize: 8))
                    ),
                  )
                ],
              )
          ),
          ClipOval(
              child: FadeInImage(
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                image: NetworkImage('${Domain.serverPort}/image/res.partner/${Get.find<MyAuthService>().myUser.value.id}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                placeholder: AssetImage(
                    "assets/img/loading.gif"),
                imageErrorBuilder:
                    (context, error, stackTrace) {
                  return Image.asset(
                      'assets/img/téléchargement (3).png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.fitWidth);
                },
              )
          )
        ],
      ),
    );
  }

  Widget getSentMessage(context, var message) {

    return message is List ?
    Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              showDialog(
                  context: context, builder: (_){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                        child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close, size: 20))
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        message[0],
                        width: Get.width,
                        height: Get.height/2,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                );
              });
            },
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(text: message[1]+ "\n", style: Get.textTheme.bodyText1.merge(TextStyle( fontSize: 14, color: Colors.black))),
                                ]
                            )
                        )
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        message[0],
                        //controller.ticketFiles[index],
                        fit: BoxFit.cover,
                        width: 120,
                        height:100,
                      ),
                    )
                  ],
                )
            ),
          ),
        ]
    ):
    Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              fit: FlexFit.loose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Get.theme.focusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(text: message+ "\n", style: Get.textTheme.bodyText1.merge(TextStyle( fontSize: 14, color: Colors.black))),
                                    ]
                                )
                            )
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text( DateFormat('d, MMM y | HH:mm').format(DateTime.now()),
                        overflow: TextOverflow.fade,
                        softWrap: false, style: Get.textTheme.headline1.merge(TextStyle(color: appColor,fontSize: 8))
                    ),
                  )
                ],
              )
          ),
        ]
    )
        ;

  }

  Widget getReceivedMessageTextLayout(context, var message, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
            child: FadeInImage(
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              image: Get.find<MyAuthService>().myUser.value.id != message['author_id'] ?
              NetworkImage('${Domain.serverPort}/image/res.partner/${message['author_id']}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders())
                  : NetworkImage('${Domain.serverPort}/image/res.partner/$message/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
              placeholder: AssetImage(
                  "assets/img/loading.gif"),
              imageErrorBuilder:
                  (context, error, stackTrace) {
                return Image.asset(
                    'assets/img/téléchargement (3).png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.fitWidth);
              },
            )
        ),
        Flexible(
          fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Get.theme.colorScheme.secondary,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(text: message['body']!= ''?message['body'].toString().substring(3,message['body'].toString().length-4)+ "\n": '', style: Get.textTheme.bodyText1.merge(TextStyle( fontSize: 14, color: Colors.white))),
                                    ]
                                )
                            )
                        ),
                        message['attachment_ids'].toString() != '[]'?
                        GestureDetector(
                          onTap: (){
                            showDialog(
                                context: context, builder: (_){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Material(
                                      child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close, size: 20))
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: FadeInImage(
                                      width: Get.width,
                                      height: Get.height/2,
                                      fit: BoxFit.cover,
                                      image: NetworkImage('https://preprod.hubkilo.com/ticket/attachment/${message['attachment_ids'][0]}?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                                      placeholder: AssetImage(
                                          "assets/img/loading.gif"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                            child: Container(
                                                width: Get.width/1.5,
                                                height: Get.height/3,
                                                color: Colors.white,
                                                child: Center(
                                                    child: Icon(Icons.person, size: 150)
                                                )
                                            )
                                        );
                                      },
                                    ),
                                  )
                                ],
                              );
                            });
                          },
                          child: Card(
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: FadeInImage(
                                    width: 120,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    image: NetworkImage('https://preprod.hubkilo.com/ticket/attachment/${message['attachment_ids'][0]}?unique=true&file_response=true',
                                        headers: Domain.getTokenHeaders()),
                                    placeholder: AssetImage(
                                        "assets/img/loading.gif"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/img/240_F_89551596_LdHAZRwz3i4EM4J0NHNHy2hEUYDfXc0j.jpg',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fitWidth);
                                    },
                                  )
                              )
                          ),
                        )
                            :SizedBox()
                      ]
                    )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      DateFormat('HH:mm | d, MMM y').format(DateTime.parse(message['date'])),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Get.textTheme.headline1.merge(TextStyle(color: appColor,fontSize: 8))
                  ),
                ),
              ],
            )
        ),
      ],
    );
  }
}
