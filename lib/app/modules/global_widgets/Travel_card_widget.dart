import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';

class TravelCardWidget extends StatelessWidget {
  const TravelCardWidget({Key key,
    @required this.user,
    @required this.depTown,
    @required this.color,
    @required this.arrTown,
    @required this.imageUrl,
    @required this.arrDate,
    @required this.depDate,
    this.isUser,
    this.travelState,
    @required this.qty,
    @required this.icon,
    this.disable,
    @required this.price,
    @required this.text}) : super(key: key);

  final Color color;
  final Widget user;
  final Widget text;
  final Widget icon;
  final String depTown;
  final String arrTown;
  final String depDate;
  final String arrDate;
  final bool disable;
  final String travelState;
  final int qty;
  final bool isUser;
  final double price;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width/3;
    return Container(
      height: 300,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: travelState != 'accepted' && isUser ? inactive : interfaceColor.withOpacity(0.4), width: 2)
        // borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
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
                      child: Center(child: FaIcon(FontAwesomeIcons.planeDeparture)),
                    ),
                    Container(width: width,
                      child: Center(child: FaIcon(FontAwesomeIcons.planeArrival)),
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
                      child: Text(depTown, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                    ),
                    FaIcon(FontAwesomeIcons.arrowRight),
                    Container(
                        alignment: Alignment.topCenter,
                        width: width,
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
                    Icon(FontAwesomeIcons.planeCircleCheck, size: 40, color: background),
                    SizedBox(width: 20),
                    Text(this.depDate, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
                  ]
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Quantity /kg:   $qty', style: Get.textTheme.headline5.merge(TextStyle(color: appColor))),
                  Text('$price EUR', style: Get.textTheme.headline3.merge(TextStyle(color: specialColor))),
                ]
              )
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
                                image: NetworkImage(this.imageUrl),
                                fit: BoxFit.cover
                            )
                        )
                    ),
                    SizedBox(width: 10),
                    this.user
                  ]
                ),
                Spacer(),
                if(isUser)
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(travelState, style: Get.textTheme.headline1.merge(TextStyle(color: travelState == 'accepted' ? interfaceColor : Colors.black54, fontSize: 12))),
                    decoration: BoxDecoration(
                        color: travelState == 'accepted' ? interfaceColor.withOpacity(0.3) : inactive.withOpacity(0.3),
                        border: Border.all(
                          color: travelState == 'accepted' ? interfaceColor.withOpacity(0.2) : inactive.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  )
              ]
          ),
        ],
      )
    );
  }
}
