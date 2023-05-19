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
    double width = MediaQuery.of(context).size.width/5.2;
    return Container(
      height: 420,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white, !disable ? interfaceColor.withOpacity(0.3) : inactive]
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
        border: Border.all(color: !disable ? interfaceColor.withOpacity(0.4) : inactive)
        // borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          !isUser ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Container(
                width: 100,
                child: this.user,
              )
            ],
          ) : !disable ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                  backgroundColor: Colors.white,
                  child: icon
              ),
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
            ],
          ) :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                  backgroundColor: Colors.white,
                  child: icon
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: 80,
                alignment: Alignment.center,
                child: Text("Due", style: Get.textTheme.headline1.merge(TextStyle(color: specialColor, fontSize: 12))),
                decoration: BoxDecoration(
                    color: specialColor.withOpacity(0.3),
                    border: Border.all(
                      color: specialColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ],
          ),
          SizedBox(height: 10),
          if(!isUser)
          CircleAvatar(
              backgroundColor: Colors.white,
              child: icon
          ),
          Divider(thickness: 1, color: interfaceColor.withOpacity(0.4)),
          Spacer(),
          Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: width,
                      height: 20,
                      child: Text('From', style: TextStyle(color: specialColor, fontWeight: FontWeight.bold)),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.center,
                      width: width,
                      height: 20,
                      child: Text('To', style: TextStyle(color: specialColor, fontWeight: FontWeight.bold)),
                    ),
                  ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      width: width,
                      height: 50,
                      child: Text(this.depTown, style: TextStyle(color: appColor)),
                    ),
                    Container(
                        alignment: Alignment.topCenter,
                        width: width,
                        height: 50,
                        child: Text(this.arrTown, style: TextStyle(color: appColor))
                    )
                  ]
                )
              ]
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.calendarDay,size: 20),
                SizedBox(width: 10),
                Text(this.depDate, style: TextStyle(color: appColor, fontSize: 15))
              ],
            ),
          ),
          ListTile(
            title: Text('price /kg:   $price EUR'),
            subtitle: Text('\nQuantity /kg:   $qty', style: TextStyle(color: appColor)),
          ),
        ],
      )
    );
  }
}
