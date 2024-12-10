import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../../../common/ui.dart';
import '../../../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'block_button_widget.dart';

class TravelCardWidget extends StatelessWidget {
  const TravelCardWidget({Key key,
    this.user,
    this.isUser,
    this.travelState,
    this.action,
    this.qty,
    this.rating,
    this.hasEnvelope,
    this.hasKilos,
    this.hasComputers,
    this.otherLuggageTypes,
    @required this.depTown,
    @required this.homePage,
    @required this.color,
    @required this.arrTown,
    @required this.imageUrl,
    @required this.depDate,
    @required this.travelBy,
    @required this.price,
    @required this.text}) : super(key: key);

  final Color color;
  final String user;
  final String rating;
  final Widget text;
  final String depTown;
  final String arrTown;
  final String depDate;
  final String travelState;
  final double qty;
  final String travelBy;
  final bool isUser;
  final bool homePage;
  final double price;
  final String imageUrl;
  final Function action;
  final hasEnvelope;
  final hasKilos;
  final hasComputers;
  final otherLuggageTypes;

  @override
  Widget build(BuildContext context) {
    double width = homePage ? MediaQuery.of(context).size.width/3.8 : MediaQuery.of(context).size.width/3.6;
    String departureCity = depTown.split('(').first;
    String a = depTown.split('(').last;
    String departureCountry = a.split(')').first;

    String arrivalCity = arrTown.split('(').first;
    String b = arrTown.split('(').last;
    String arrivalCountry = b.split(')').first;

    return Card(
        shape: RoundedRectangleBorder(
          side:  !isUser ? BorderSide(
              color: inactive, width: 0
            //travelState != 'accepted' && isUser ? inactive : interfaceColor.withOpacity(0.4), width: 2
          ) : BorderSide(
              color: travelState != 'accepted' && isUser ? inactive : interfaceColor.withOpacity(0.4), width: 0
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
            height: travelState == 'pending' ? travelBy=='road'? 220 : 160 : 185,
            padding: EdgeInsets.all(10),
            child: Column(
             // mainAxisAlignment: ,
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
                            if(travelBy == "air")
                              Icon(FontAwesomeIcons.planeCircleCheck, size: 30, color: background),
                            if(travelBy == "road")
                              Icon(FontAwesomeIcons.bus, size: 30, color: background),
                            if(travelBy == "sea")
                              Icon(FontAwesomeIcons.ship, size: 30, color: background) ,
                            SizedBox(width: 10),
                            Container(
                                alignment: Alignment.topLeft,
                                //margin: EdgeInsets.only(right: 10),
                                width: width,
                                height: 40,
                                child: RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(text: departureCity, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 12, color: interfaceColor))),
                                          TextSpan(text: "\n$departureCountry".toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
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
                                          TextSpan(text: arrivalCity, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 12, color: interfaceColor))),
                                          TextSpan(text: "\n$arrivalCountry".toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if(isUser)...[
                                if(travelBy != 'road')...[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if(hasEnvelope != null && hasEnvelope)
                                          Container(
                                            decoration: Ui.getBoxDecoration(
                                              radius: 14,
                                              color: Colors.transparent,
                                              border: Border.all(width: 5, color: Colors.transparent),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              child: Image.asset(
                                                'assets/img/envelope.png',
                                                fit: BoxFit.cover,
                                                width: 35,
                                                height: 35,
                                              ),
                                            ),
                                          ),
                                        SizedBox(width: 10,),
                                        if(hasKilos != null && hasKilos)
                                          Container(
                                            decoration: Ui.getBoxDecoration(
                                              radius: 14,
                                              color: Colors.transparent,
                                              border: Border.all(width: 5, color: Colors.transparent),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              child: Image.asset(
                                                'assets/img/package-maximum-weight.png',
                                                fit: BoxFit.cover,
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                          ),
                                        SizedBox(width: 10,),
                                        if(hasComputers != null && hasComputers)
                                          Container(
                                            decoration: Ui.getBoxDecoration(
                                              radius: 14,
                                              color: Colors.transparent,
                                              border: Border.all(width: 5, color: Colors.transparent),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              child: Image.asset(
                                                'assets/img/laptop.png',
                                                fit: BoxFit.cover,
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )

                                ],
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                      width: Get.width/1.2,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Text(this.depDate, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: appColor))
                                              )
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            child: Text(travelState == "negotiating" ? AppLocalizations.of(context).statePublished : travelState.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(color: travelState == 'accepted' ? interfaceColor : travelState == 'negotiating' ? validateColor : travelState == "pending" ? inactive : travelState == "completed" ? doneStatus : specialColor, fontSize: 12))),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: travelState == 'accepted' ? interfaceColor : travelState == 'negotiating' ? validateColor : travelState == "pending" ? inactive : travelState == "completed" ? doneStatus : specialColor,
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(7))),
                                          )
                                        ],
                                      )
                                  ),
                                )
                              ]

                            ]
                        )
                      ]
                  ),
                  Spacer(),
                  if(isUser && travelState == 'pending'&& travelBy == 'road')
                    ElevatedButton.icon(
                        onPressed: action,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: validateColor
                        ),
                        icon: Icon(Icons.publish_rounded),
                        label: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              AppLocalizations.of(context).publish,
                              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                            )
                        )
                    ).paddingSymmetric(vertical: 10, horizontal: 20),



                  if(!isUser)...[
                    if(travelBy != 'road')...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(hasEnvelope != null && hasEnvelope)
                            Container(
                              decoration: Ui.getBoxDecoration(
                                radius: 14,
                                color: Colors.transparent,
                                border: Border.all(width: 5, color: Colors.transparent),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Image.asset(
                                  'assets/img/envelope.png',
                                  fit: BoxFit.cover,
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ),
                          SizedBox(width: 10,),
                          if(hasKilos != null && hasKilos)
                            Container(
                              decoration: Ui.getBoxDecoration(
                                radius: 14,
                                color: Colors.transparent,
                                border: Border.all(width: 5, color: Colors.transparent),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Image.asset(
                                  'assets/img/package-maximum-weight.png',
                                  fit: BoxFit.cover,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          SizedBox(width: 10,),
                          if(hasComputers != null && hasComputers)
                            Container(
                              decoration: Ui.getBoxDecoration(
                                radius: 14,
                                color: Colors.transparent,
                                border: Border.all(width: 5, color: Colors.transparent),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Image.asset(
                                  'assets/img/laptop.png',
                                  fit: BoxFit.cover,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),

                          if(otherLuggageTypes != null && otherLuggageTypes.isNotEmpty)
                            for(var item in otherLuggageTypes)...[
                              Container(
                                decoration: Ui.getBoxDecoration(
                                  radius: 14,
                                  color: Colors.transparent,
                                  border: Border.all(width: 5, color: Colors.transparent),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: FadeInImage(
                                    width: 30,
                                    height: 30,
                                    image: NetworkImage('https://preprod.hubkilo.com/web/image/m2st_hk_airshipping.luggage.type/${item['luggage_type_id'][0]}/image',
                                        headers: Domain.getTokenHeaders()),
                                    placeholder: AssetImage(
                                        "assets/img/loading.gif"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Center(
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              color: Colors.white,
                                              child: Center(
                                                  child: Icon(Icons.photo, size: 150)
                                              )
                                          )
                                      );
                                    },
                                  ),
                                ),
                              )
                            ]



                        ],
                      )

                    ],
                    SizedBox(
                        width: homePage ? Get.width/1.3 : Get.width/1.2,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
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
                              SizedBox(width: 10),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(this.user, style: TextStyle(fontSize: 12, color: appColor, overflow: TextOverflow.ellipsis)),
                                        Text("⭐️ ${this.rating}", style: TextStyle(fontSize: 13, color: appColor))
                                      ]
                                  )
                              ),
                              Text(this.depDate, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: appColor)))
                            ]
                        )
                    )
                  ]

                ]
            )
        )
    );
  }
}