import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../../../main.dart';

class TravelCardWidget extends StatelessWidget {
  const TravelCardWidget({Key key,
    @required this.user,
    @required this.depTown,
    @required this.homePage,
    @required this.color,
    @required this.arrTown,
    @required this.imageUrl,
    @required this.arrDate,
    @required this.depDate,
    @required this.travelType,
    this.isUser,
    this.code,
    this.travelState,
    this.qty,
    @required this.travelBy,
    @required this.price,
    @required this.text}) : super(key: key);

  final Color color;
  final Widget user;
  final Widget text;
  final String depTown;
  final String arrTown;
  final String depDate;
  final String arrDate;
  final String travelState;
  final String code;
  final double qty;
  final String travelBy;
  final bool isUser;
  final bool homePage;
  final bool travelType;
  final double price;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    double width = homePage ? MediaQuery.of(context).size.width/3.5 : MediaQuery.of(context).size.width/3.2;
    return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: travelState != 'accepted' && isUser ? inactive : interfaceColor.withOpacity(0.4), width: 2
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          height: 250,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: width,
                    child: Center(child: FaIcon(travelBy == "road" ? FontAwesomeIcons.bus : FontAwesomeIcons.planeDeparture)),
                  ),
                  Container(width: width,
                    child: Center(child: FaIcon(travelBy == "road" ? FontAwesomeIcons.bus : FontAwesomeIcons.planeArrival)),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    width: width,
                    height: 30,
                    child: Text(depTown, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                  ),
                  FaIcon(FontAwesomeIcons.arrowRight),
                  Container(
                      alignment: Alignment.topCenter,
                      width: width,
                      height: 30,
                      child: Text(arrTown, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18)))
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(this.depDate, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                Text("Code: $code", style: TextStyle(color: appColor.withOpacity(0.4), fontSize: 15)),
                              ],
                            ),
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
                Row(
                    children: [
                      if(!isUser)
                        Row(
                            children: [
                              Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: NetworkImage(this.imageUrl, headers: Domain.getTokenHeaders()),
                                          fit: BoxFit.cover
                                      )
                                  )
                              ),
                              SizedBox(width: 10),
                              this.user
                            ]
                        ),
                      Spacer(),
                    ]
                )
              ],
          )
        )
    );
  }
}