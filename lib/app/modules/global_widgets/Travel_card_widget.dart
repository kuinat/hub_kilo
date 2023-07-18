import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../../../main.dart';
import 'block_button_widget.dart';

class TravelCardWidget extends StatelessWidget {
  const TravelCardWidget({Key key,
    this.user,
    @required this.depTown,
    @required this.homePage,
    @required this.color,
    @required this.arrTown,
    @required this.imageUrl,
    @required this.depDate,
    @required this.travelType,
    this.isUser,
    this.travelState,
    this.action,
    this.qty,
    this.rating,
    @required this.travelBy,
    @required this.price,
    @required this.text}) : super(key: key);

  final Color color;
  final String user;
  final double rating;
  final Widget text;
  final String depTown;
  final String arrTown;
  final String depDate;
  final String travelState;
  final double qty;
  final String travelBy;
  final bool isUser;
  final bool homePage;
  final bool travelType;
  final double price;
  final String imageUrl;
  final Function action;

  @override
  Widget build(BuildContext context) {
    double width = homePage ? MediaQuery.of(context).size.width/3.5 : MediaQuery.of(context).size.width/3.2;
    String departureCity = depTown.split('(').first;
    String a = depTown.split('(').last;
    String departureCountry = a.split(')').first;

    String arrivalCity = arrTown.split('(').first;
    String b = arrTown.split('(').last;
    String arrivalCountry = b.split(')').first;

    return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          side:  !isUser ? BorderSide(
              color: inactive, width: 2
              //travelState != 'accepted' && isUser ? inactive : interfaceColor.withOpacity(0.4), width: 2
          ) : BorderSide(
              color: travelState != 'accepted' && isUser ? inactive : interfaceColor.withOpacity(0.4), width: 2
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          height: 200,
          padding: EdgeInsets.all(10),
          child: Column(
              children: [
          Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            color: Get.theme.primaryColor,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    //margin: EdgeInsets.only(right: 10),
                    width: width,
                    height: 40,
                    child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: departureCity, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                            TextSpan(text: "\n$departureCountry", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                          ]
                        ))
                  ),
                  FaIcon(FontAwesomeIcons.arrowRight),
                  Container(
                      alignment: Alignment.topCenter,
                      //margin: EdgeInsets.symmetric(horizontal: 10),
                      width: width,
                      height: 40,
                      child: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(text: arrivalCity, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                                TextSpan(text: "\n$arrivalCountry", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                              ]
                          ))
                      //Text(arrTown, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18)))
                  ),
                ],
              ),
            ],
          ),
        ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children: [
                            if(travelBy == "air")
                              Icon(FontAwesomeIcons.planeCircleCheck, size: 40, color: background),
                            if(travelBy == "road")
                              Icon(FontAwesomeIcons.bus, size: 40, color: background),
                            if(travelBy == "sea")
                              Icon(FontAwesomeIcons.ship, size: 40, color: background) ,
                            SizedBox(width: 20),
                            Text(this.depDate, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: appColor))),
                          ]
                      ),
              Spacer(),
              travelType ?
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.shoppingBag, size: 25, color: appColor),
                          Text(' /kg:   $qty', style: Get.textTheme.headline5.merge(TextStyle(color: appColor))),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text('$price EUR', style: Get.textTheme.headline3.merge(TextStyle(color: specialColor))),
                      SizedBox(height: 10),
                      if(isUser)
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(travelState, style: Get.textTheme.headline1.merge(TextStyle(color: travelState == 'accepted' ? interfaceColor : travelState == 'negotiating' ?
                        pendingStatus : travelState == 'completed' ? doneStatus : Colors.black54, fontSize: 12))),
                        decoration: BoxDecoration(
                            color: travelState == 'accepted' ? interfaceColor.withOpacity(0.3) : travelState == 'negotiating' ?
                            pendingStatus.withOpacity(0.3) : travelState == 'completed' ? doneStatus.withOpacity(0.3) : inactive.withOpacity(0.3),
                            border: Border.all(
                              color: travelState == 'accepted' ? interfaceColor.withOpacity(0.2) : travelState == 'negotiating' ?
                              pendingStatus.withOpacity(0.2) : travelState == 'completed' ? doneStatus.withOpacity(0.2) : inactive.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                      )
                    ]
                ) : isUser ?
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(travelState, style: Get.textTheme.headline1.merge(TextStyle(color: travelState == 'accepted' ? interfaceColor : travelState == 'negotiating' ? pendingStatus : Colors.black54, fontSize: 12))),
                decoration: BoxDecoration(
                    color: travelState == 'accepted' ? interfaceColor.withOpacity(0.3) : travelState == 'negotiating' ? pendingStatus.withOpacity(0.3) :  inactive.withOpacity(0.3),
                    border: Border.all(
                      color: travelState == 'accepted' ? interfaceColor.withOpacity(0.2) : travelState == 'negotiating' ? pendingStatus.withOpacity(0.2) :  inactive.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ) : SizedBox()
            ]
        ),
                Spacer(),
                if(isUser && travelState == 'pending')
                  ElevatedButton.icon(
                    onPressed: action,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: validateColor
                      ),
                    icon: Icon(Icons.publish_rounded),
                    label: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Publier".tr,
                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                        )
                    )
                  ).paddingSymmetric(vertical: 10, horizontal: 20),
                Row(
                    children: [
                      if(!isUser)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipOval(
                                  child: FadeInImage(
                                    width: 50,
                                    height: 50,
                                    image: NetworkImage(this.imageUrl, headers: Domain.getTokenHeaders()),
                                    placeholder: AssetImage(
                                        "assets/img/loading.gif"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          "assets/img/téléchargement (1).png",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fitWidth);
                                    },
                                  )
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                width: 200,
                                height: 50,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: Text(this.user, style: TextStyle(fontSize: 18, color: appColor, overflow: TextOverflow.ellipsis))),
                                    Text("⭐️ ${this.rating}", style: TextStyle(fontSize: 15, color: appColor))
                                  ]
                                )
                              )
                            ]
                        )
                    ]
                )
              ]
          )
        )
    );
  }
}