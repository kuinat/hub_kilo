
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:app/app/modules/global_widgets/pop_up_widget.dart';
import 'package:intl/intl.dart';

import '../../../color_constants.dart';
import '../../../main.dart';
import '../../routes/app_routes.dart';
import '../../services/my_auth_service.dart';
import '../account/widgets/account_link_widget.dart';
import '../userBookings/controllers/bookings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardWidget extends StatelessWidget {
   CardWidget({Key key,

    this.selected,
    this.imageUrl,
    this.editable,
    this.transferable,
    this.accept,
    this.transfer,
    this.packetImageUrl,
    this.negotiation,
    this.markReceived,
    this.travellerDisagree,
    this.user,
    this.homePage,
    @required this.owner,
    @required this.detailsView,
    @required this.shippingDate,
    @required this.code,
    @required this.price,
    @required this.travelType,
    @required this.text,
    @required this.bookingState,


  }) : super(key: key);

  final Widget negotiation;
  final String text;
  final bool owner;
  final String code;
  final Widget detailsView;
  final String shippingDate;
  final bool selected;
  final bool transferable;
  final bool editable;
  final bool travellerDisagree;
  final String bookingState;
  final String travelType;
  final double price;
  final String packetImageUrl;
  final Function accept;
  final Function transfer;
  final Function markReceived;
  final String imageUrl;
  final String user;
  var homePage;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<BookingsController>(
          () => BookingsController(),
    );
    //var selected = Get.find<BookingsController>().currentState.value ;
    return ClipRRect(
      child: Banner(
        location: BannerLocation.topEnd,
        message: !travellerDisagree ? bookingState == "received" ? AppLocalizations.of(context).delivered : bookingState == "confirm" ? AppLocalizations.of(context).received : bookingState == 'rejected' ? AppLocalizations.of(context).cancelled : bookingState : AppLocalizations.of(context).rejected,
        color: !travellerDisagree ? bookingState == 'accepted' ? pendingStatus : bookingState == 'rejected' ? specialColor :
        bookingState == 'received' ? interfaceColor : bookingState == "paid" ? validateColor : bookingState == "confirm" ? doneStatus : inactive : specialColor,
        child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: selected == null? BorderSide.none:selected? BorderSide(color: interfaceColor):BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),

            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                      child: Text(code, style: TextStyle(color: appColor, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, fontSize: 12))
                  ).paddingOnly(top: 10),
                  ListTile(
                    leading: travelType!=''?travelType=='road' || travelType=='By Road'?
                    Icon(FontAwesomeIcons.bus, size: 30, color: background)
                        :Icon(FontAwesomeIcons.planeUp, size: 30, color: background)
                        :Icon(FontAwesomeIcons.bus, size: 30, color: background),
                    title: Text(text, overflow: TextOverflow.ellipsis,style: Get.textTheme.headline1.
                    merge(TextStyle(color: appColor, fontSize: 12))),
                    subtitle: Text("${DateFormat("dd MMM yyyy").format(DateTime.parse(shippingDate))} ",
                        style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: Colors.black))) ,

                  ),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            !owner? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                bookingState != 'received' ?
                                negotiation : SizedBox(),
                              ],
                            ):SizedBox(),
                            Row(
                              children: [
                                if(bookingState == 'pending' && !owner )...[
                                  InkWell(
                                    onTap: () => showDialog(
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
                                              image: NetworkImage(this.imageUrl, headers: Domain.getTokenHeaders()),
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
                                    }),
                                    child: ClipOval(
                                        child: FadeInImage(
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          image: NetworkImage(this.imageUrl, headers: Domain.getTokenHeaders()),
                                          placeholder: AssetImage(
                                              "assets/img/loading.gif"),
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                                "assets/img/téléchargement (1).png",
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.fitWidth);
                                          },
                                        )
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    //width: 80,
                                    child: Text(this.user,
                                        overflow: TextOverflow.ellipsis,
                                        style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: Colors.black)))
                                  )
                                ]else ...[
                                  if(homePage == null || homePage == true)...[
                                    InkWell(
                                      onTap: () => showDialog(
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
                                                image: NetworkImage('${Domain.serverPort}/image/res.partner/${Get.find<MyAuthService>().myUser.value.id}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
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
                                      }),
                                      child: ClipOval(
                                          child: FadeInImage(
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                            image: NetworkImage('${Domain.serverPort}/image/res.partner/${Get.find<MyAuthService>().myUser.value.id}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                                            placeholder: AssetImage(
                                                "assets/img/loading.gif"),
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                  "assets/img/téléchargement (1).png",
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.fitWidth);
                                            },
                                          )
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                        //width: 115,
                                        child: Text(Get.find<MyAuthService>().myUser.value.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: Colors.black)))
                                    )

                                  ]

                                ],
                                owner?bookingState != 'received' ?
                                negotiation : SizedBox():SizedBox(),
                                Spacer(),
                                detailsView
                              ],
                            ),
                            if(!owner)...[
                              if(bookingState == "paid")
                                ElevatedButton(
                                    onPressed: markReceived,
                                    style: ElevatedButton.styleFrom(backgroundColor: interfaceColor),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(AppLocalizations.of(context).setToReceived),
                                    )
                                ),
                              if(bookingState == "confirm")
                                ElevatedButton(
                                    onPressed: ()=> Get.offNamed(Routes.VALIDATE_TRANSACTION),
                                    style: ElevatedButton.styleFrom(backgroundColor: inactive),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(AppLocalizations.of(context).deliverParcel),
                                    )
                                )
                            ]
                          ])
                  ),
                ],
              ),
            )
        )
      ),
    );
  }
}