import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../controllers/messages_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../color_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable

class ChatsView extends GetView<MessagesController> {
  final _myListKey = GlobalKey<AnimatedListState>();


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
                  controller.messages.sort((a, b) => b["__last_update"].compareTo(a["__last_update"]));
                });
                if(Get.find<MyAuthService>().myUser.value.id != controller.messages[index]['sender_partner_id'][0]){
                  receivedMessages.add(controller.messages[index]);
                }
                if(controller.messages[index]['name'] == AppLocalizations.of(context).priceConfirmed || controller.messages[index]['name'] == AppLocalizations.of(context).priceConfirmed){
                  controller.getIndex.value = index;
                }
                //Chat _chat = controller.chats.elementAt(index);
                //_chat.user = controller.message.value.users.firstWhere((_user) => _user.id == _chat.userId, orElse: () => new User(name: "-", avatar: new Media()));
                return  Column(
                    children: [
                      if(Get.find<MyAuthService>().myUser.value.id == controller.messages[index]['sender_partner_id'][0])...[
                        getSentMessageTextLayout(context, controller.messages[index], index),
                        if(index == 0)...[
                          for(var a in controller.messagesSent)...[
                            getSentMessage(context, a)
                          ]
                        ],
                      ]else...[
                        getReceivedMessageTextLayout(context, controller.messages[index], index)
                      ],
                      if(Get.find<MyAuthService>().myUser.value.id != controller.travel['partner_id'][0])...[
                        if(receivedMessages.isNotEmpty )
                          Obx(() =>
                          !controller.validate.value?
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: validateColor,
                                  ),
                                  onPressed: ()=> controller.shipperValidate(controller.messages[index]['id'], controller.messages[index]['price']),
                                  child: Text(AppLocalizations.of(Get.context).acceptPrice, style: Get.textTheme.headline2.merge(TextStyle(color: Colors.white, fontSize: 13)))
                              )
                          ):SizedBox()
                          )
                          
                      ]
                      ,

                    ]
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

                  controller.dispose();
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
        title: Obx(() {
          return Text( controller.receiver_Name.value,
            //controller.message.value.name,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15, color: appColor)),
          );
        }),
      ),

      body: RefreshIndicator(
        onRefresh: ()async{
          print(Get.width);
          controller.refreshMessages();
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
                child: Obx(() => Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Container(
                            alignment: Alignment.topCenter,
                            width: Get.width > 300 ? 140 : Get.width,
                            child: RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(text: controller.departureTown.value, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                      TextSpan(text: "\n${controller.departureCountry.value.toUpperCase()}", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                                    ]
                                ))
                        )),
                        FaIcon(FontAwesomeIcons.arrowRight),
                        Obx(() => Container(
                            alignment: Alignment.topCenter,
                            width: Get.width > 300 ? 140 : Get.width,
                            child: RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(text: controller.arrivalTown.value, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                      TextSpan(text: "\n${controller.arrivalCountry.value.toUpperCase()}", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                                    ]
                                )
                            )
                        )),
                      ],
                    ),
                    if(controller.messages.isNotEmpty && controller.validateMessage['price'] != null)
                      Card(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              if(Get.find<MyAuthService>().myUser.value.id == controller.travel['partner_id'][0])...[
                                if(controller.validateMessage['state'] != "validate")...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(controller.validateMessage['price'].toString()+ " €", style: Get.textTheme.headline2.merge(TextStyle(color: appColor))),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: validateColor,
                                          ),
                                          onPressed: ()async {

                                            controller.messageId.value = controller.validateMessage['id'];
                                            controller.confirmTransporting();
                                          },
                                          child: Text(AppLocalizations.of(Get.context).confirmPrice, style: Get.textTheme.headline2.merge(TextStyle(color: Colors.white, fontSize: 13)))
                                      )
                                    ]
                                  )

                                ]else...[
                                  Center(
                                      child: Text(controller.validateMessage['price'].toString()+ " €", style: Get.textTheme.headline2.merge(TextStyle(color: appColor))
                                      )
                                  )
                                ]
                              ]else...[
                                if(controller.validateMessage['state'] == "validate")...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(controller.validateMessage['price'].toString()+ " €", style: Get.textTheme.headline2.merge(TextStyle(color: appColor))),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: interfaceColor,
                                          ),
                                          onPressed: ()=> {
                                            ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
                                              content: Text(AppLocalizations.of(Get.context).loadingData),
                                              duration: Duration(seconds: 3),
                                            )),
                                            Get.find<BookingsController>().getRoadShipping(controller.card['id'])},
                                          child: Text(AppLocalizations.of(Get.context).viewInvoice, style: Get.textTheme.headline2.merge(TextStyle(color: Colors.white, fontSize: 13)))
                                      )
                                    ]
                                  )
                                ]else...[
                                  Center(
                                      child: Text(controller.validateMessage['price'].toString()+ " €", style: Get.textTheme.headline2.merge(TextStyle(color: appColor))
                                      )
                                  )
                                ]
                              ]
                            ]
                          )
                        )
                      )
                  ]
                ))
            ),
            Expanded(
                child: chatList()
            ),
            Container(
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, -4), blurRadius: 10)],
              ),
              child:  Obx(() => Row(
                children: [
                  controller.validateMessage['state'] != "validate" ?
                  SizedBox(
                      width: Get.width,
                      child: TextFormField(
                        controller: controller.priceController,
                        style: Get.textTheme.bodyText1.merge(TextStyle(fontSize: 18)),
                        //keyboardType: TextInputType.number,
                        onChanged: (value)=> controller.checkValue(value),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          hintText: AppLocalizations.of(Get.context).enterPrice.tr,
                          hintStyle: TextStyle(color: Get.theme.focusColor.withOpacity(0.8)),
                          suffix: SizedBox(
                              width: 220,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: (){
                                      showDialog(
                                          context: context,
                                          builder: (context){
                                            return AlertDialog(
                                              title: SizedBox(
                                                width: MediaQuery.of(context).size.width /1.6,
                                                child: TextFormField(
                                                  controller: controller.chatTextController,
                                                  style: Get.textTheme.bodyText1.merge(TextStyle(fontSize: 18)),
                                                  //keyboardType: TextInputType.number,
                                                  maxLines: 7,
                                                  minLines: 1,
                                                  //onChanged: (value)=> controller.checkValue(value),
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.all(20),
                                                    fillColor: background,
                                                    filled: true,
                                                    hintText: AppLocalizations.of(Get.context).addComment.tr,
                                                    hintStyle: TextStyle(color: Get.theme.focusColor.withOpacity(0.8)),
                                                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                BlockButtonWidget(
                                                    onPressed: (){
                                                      var n = controller.messages.length;
                                                      if(!controller.enableSend.value){
                                                        controller.priceController.text = controller.messages[n - 1]['price'];
                                                      }

                                                      List message = [];
                                                      message.add("${controller.chatTextController.text}*${controller.priceController.text}");
                                                      controller.messagesSent.value = message;
                                                      controller.sendMessage(Get.find<MyAuthService>().myUser.value.id);

                                                      Timer(Duration(seconds: 1), () {
                                                        controller.chatTextController.clear();
                                                        controller.priceController.clear();
                                                        controller.enableSend.value = false;
                                                        Navigator.pop(Get.context);
                                                      });

                                                    },
                                                    color: Get.theme.colorScheme.secondary,
                                                    text: Text(
                                                      AppLocalizations.of(Get.context).sendMessage,
                                                      style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                                                    )
                                                ).paddingSymmetric(vertical: 10, horizontal: 20),
                                              ],
                                            );
                                          }
                                      );

                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: inactive
                                        ),
                                        child: Text(AppLocalizations.of(Get.context).addComment, style: TextStyle(color: Colors.white))
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsetsDirectional.only(end: 10, start: 10),
                                    onPressed: () {

                                      controller.chatTextController.text = AppLocalizations.of(Get.context).iPropose;

                                      if(controller.enableSend.value){
                                        controller.sendMessage(Get.find<MyAuthService>().myUser.value.id);
                                        Timer(Duration(milliseconds: 100), () {
                                          controller.chatTextController.clear();
                                          controller.priceController.clear();
                                          controller.enableSend.value = false;
                                        });
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
                      : SizedBox(
                      width: Get.width,
                      child: TextFormField(
                        controller: controller.chatTextController,
                        style: Get.textTheme.bodyText1.merge(TextStyle(fontSize: 18)),
                        //keyboardType: TextInputType.number,
                        onChanged: (value)=> controller.checkValue(value),

                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          hintText: AppLocalizations.of(Get.context).addMessage,
                          hintStyle: TextStyle(color: Get.theme.focusColor.withOpacity(0.8)),
                          suffixIcon: IconButton(
                            padding: EdgeInsetsDirectional.only(end: 10, start: 10),
                            onPressed: () {

                              if(controller.validateMessage['price'] != null){
                                controller.priceController.text = "1";
                              }

                              if(controller.enableSend.value){
                                controller.sendMessage(Get.find<MyAuthService>().myUser.value.id);
                                Timer(Duration(milliseconds: 100), () {
                                  controller.chatTextController.clear();
                                  controller.priceController.clear();
                                  controller.enableSend.value = false;
                                });
                              }

                            },
                            icon: Icon(
                              Icons.send_outlined,
                              color: controller.enableSend.value ? Get.theme.colorScheme.secondary : inactive,
                              size: 30,
                            ),
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
    return Container(
      constraints: BoxConstraints(
        maxWidth: Get.width
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller.validateMessage['state'] == "validate" ?
          controller.getIndex.value < index ?
              IconButton(
                  onPressed: () {

                    showDialog(
                        context: context,
                        builder: (_){
                          return buildBillSimulator(context, message['price']);
                        }
                    );
                  },
                  icon: Icon(FontAwesomeIcons.fileInvoiceDollar, size: 20)
              ) : SizedBox() :
          IconButton(
              onPressed: () {

                showDialog(
                    context: context,
                    builder: (_){
                      return buildBillSimulator(context, message['price']);
                    }
                );
              },
              icon: Icon(FontAwesomeIcons.fileInvoiceDollar, size: 20)
          ),
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
                                    TextSpan(text: message['name']+ "\n", style: Get.textTheme.bodyText1.merge(TextStyle( fontSize: 14, color: Colors.black))),
                                   controller.validateMessage['state'] == "validate" ?
                                   controller.getIndex.value < index ?
                                    TextSpan(text: "* ${message['price']} EUR *",
                                        style: Get.textTheme.bodyText2.merge(TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15)
                                        )) : TextSpan() :
                                   TextSpan(text: "* ${message['price']} EUR *",
                                       style: Get.textTheme.bodyText2.merge(TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15)
                                       ))
                                  ]
                              )
                          )
                        )
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

  Widget buildBillSimulator(BuildContext context, var price){

    Get.lazyPut<AuthController>(
          () => AuthController(),
    );

    var data = Get.find<AuthController>().taxDto;

    double tva = price * data['amount']/100;
    double paid = price + tva;
    double service = (paid * controller.commission.value)/100;
    double total = paid - service;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Center(
        child: Text(AppLocalizations.of(Get.context).billSimulator, style: Get.textTheme.headline5.merge(TextStyle(color: buttonColor, letterSpacing: 2))),
      ),
      actions: [
        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: ()=> Navigator.pop(context),
            child: Text(AppLocalizations.of(Get.context).close, style: TextStyle(color: interfaceColor, fontSize: 14)),
          ),
        )
      ],
      content: SizedBox(
        height: Get.find<MyAuthService>().myUser.value.id != controller.card['partner_id'][0] ? Get.height/2.8 : Get.height/3.5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(Get.context).proposedPrice, style: TextStyle(color: buttonColor, fontSize: 14)),
                trailing: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: price.toString(), style: TextStyle(color: buttonColor, fontSize: 14, fontWeight: FontWeight.bold)),
                        TextSpan(text: "  EUR", style: TextStyle(color: buttonColor, fontSize: 14)),
                      ]
                  ),
                ),
              ),
              ListTile(
                title: Text(data['description'], style: TextStyle(color: buttonColor, fontSize: 14)),
                trailing: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: tva.toStringAsFixed(1), style: TextStyle(color: buttonColor, fontSize: 14, fontWeight: FontWeight.bold)),
                        TextSpan(text: "  EUR", style: TextStyle(color: buttonColor, fontSize: 14)),
                      ]
                  ),
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(Get.context).totalPaid, style: TextStyle(color: buttonColor, fontSize: 14)),
                trailing: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: paid.toStringAsFixed(1), style: TextStyle(color: buttonColor, fontSize: 14, fontWeight: FontWeight.bold)),
                        TextSpan(text: "  EUR", style: TextStyle(color: buttonColor, fontSize: 14)),
                      ]
                  ),
                ),
              ),
              if(Get.find<MyAuthService>().myUser.value.id != controller.card['partner_id'][0])...[
                ListTile(
                  title: Text(AppLocalizations.of(Get.context).serviceFee, style: TextStyle(color: buttonColor, fontSize: 14)),
                  trailing: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: service.toStringAsFixed(1), style: TextStyle(color: buttonColor, fontSize: 14, fontWeight: FontWeight.bold)),
                          TextSpan(text: "  EUR", style: TextStyle(color: buttonColor, fontSize: 14)),
                        ]
                    )
                  )
                ),
                ListTile(
                  title: Text(AppLocalizations.of(Get.context).netReceived, style: TextStyle(color: buttonColor, fontSize: 14)),
                  trailing: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: total.toStringAsFixed(1), style: TextStyle(color: interfaceColor, fontSize: 16, fontWeight: FontWeight.bold)),
                          TextSpan(text: "  EUR", style: TextStyle(color: buttonColor, fontSize: 14)),
                        ]
                    ),
                  ),
                ),
              ]
            ],
          )
        ),
      ),
    );
  }

  Widget getSentMessage(context, var message) {
    return Row(
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
                                    TextSpan(text: message.split("*").first+ "\n", style: Get.textTheme.bodyText1.merge(TextStyle( fontSize: 14, color: Colors.black))),
                                    controller.validateMessage['state'] != "validate" ?
                                    TextSpan(text: "* ${message.split("*").last} EUR *",
                                        style: Get.textTheme.bodyText2.merge(TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15)
                                        )) : TextSpan()
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
        ]
    );
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
              image: Get.find<MyAuthService>().myUser.value.id != controller.card['partner_id'][0] ?
              NetworkImage('${Domain.serverPort}/image/res.partner/${controller.card['partner_id'][0]}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders())
                  : NetworkImage('${Domain.serverPort}/image/res.partner/${controller.receiver_id.value}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
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
                                      TextSpan(text: message['name']+ "\n", style: Get.textTheme.bodyText1.merge(TextStyle( fontSize: 14, color: Colors.white))),
                                      controller.validateMessage['state'] == "validate" ?
                                      controller.getIndex.value < index ?
                                      TextSpan(text: "* ${message['price']} EUR *",
                                          style: Get.textTheme.bodyText2.merge(TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 15)
                                          )) : TextSpan() :
                                      TextSpan(text: "* ${message['price']} EUR *",
                                          style: Get.textTheme.bodyText2.merge(TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 15)
                                          ))
                                    ]
                                )
                            )
                        )
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
        controller.validateMessage['state'] == "validate" ?
        controller.getIndex.value < index ?
        IconButton(
            onPressed: () {

              showDialog(
                  context: context,
                  builder: (_){
                    return buildBillSimulator(context, message['price']);
                  }
              );
            },
            icon: Icon(FontAwesomeIcons.fileLines, size: 20)
        ) : SizedBox() :
        IconButton(
            onPressed: () {

              showDialog(
                  context: context,
                  builder: (_){
                    return buildBillSimulator(context, message['price']);
                  }
              );
            },
            icon: Icon(FontAwesomeIcons.fileLines, size: 20)
        ),
      ],
    );
  }
}
