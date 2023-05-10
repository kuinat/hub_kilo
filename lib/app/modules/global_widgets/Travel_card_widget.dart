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
    @required this.qty,
    @required this.icon,
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
  final int qty;
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
            colors: [Colors.white, Colors.white, interfaceColor.withOpacity(0.3)]
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: this.color.withOpacity(0.3), blurRadius: 40, offset: Offset(0, 15)),
          BoxShadow(color: this.color.withOpacity(0.2), blurRadius: 13, offset: Offset(0, 3))
        ],
        // borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 70,
                  height: 70,
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
          ),
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
                      height: 40,
                      child: Text(this.depTown, style: TextStyle(color: appColor)),
                    ),
                    Container(
                        alignment: Alignment.topCenter,
                        width: width,
                        height: 40,
                        child: Text(this.arrTown, style: TextStyle(color: appColor))
                    )
                  ]
                )
              ]
          ),
          SizedBox(height: 10),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.calendarDay),
              title: Text(this.depDate, style: TextStyle(color: appColor))
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
