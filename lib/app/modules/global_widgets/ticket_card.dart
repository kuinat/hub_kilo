
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:app/app/modules/global_widgets/pop_up_widget.dart';
import 'package:intl/intl.dart';

import '../../../color_constants.dart';
import '../../../main.dart';
import '../../routes/app_routes.dart';
import '../account/widgets/account_link_widget.dart';
import '../userBookings/controllers/bookings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({Key key,

    @required this.detailsView,
    @required this.chatView,
    @required this.date,
    @required this.priority,
    @required this.code,
    @required this.title,
    @required this.ticketState
  }) : super(key: key);

  final String title;
  final String code;
  final Widget detailsView;
  final Widget chatView;
  final String date;
  final String ticketState;
  final int priority;


  @override
  Widget build(BuildContext context) {
    Get.lazyPut<BookingsController>(
          () => BookingsController(),
    );
    //var selected = Get.find<BookingsController>().currentState.value ;
    return ClipRRect(
      child: Banner(
          location: BannerLocation.topEnd,
          message: ticketState == "1" ? 'Pending' : ticketState == "2" ? 'In Progress' : ticketState == '3' ? 'Solved' : ticketState == '4' ?'On Hold':ticketState == '5' ? 'Cancelled':ticketState == '100' ? 'Closed': 'Done',
          color: ticketState == '1' ? inactive : ticketState == '5' ? Colors.orange :ticketState == '100' ? Colors.orange:
          ticketState == '3' ? validateColor : ticketState == "2" ? pendingStatus : ticketState == "4" ? doneStatus : interfaceColor,
          child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),

              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  //alignment: AlignmentDirectional.topStart,
                  children: [
                    SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(FontAwesomeIcons.ticket, color: Colors.grey,),
                          SizedBox(
                            width: Get.width*0.25,
                            child: Text(title, overflow: TextOverflow.ellipsis,style: Get.textTheme.headline1.
                            merge(TextStyle(color: appColor, fontSize: 12))),
                          ),

                          SizedBox(
                            //width: Get.width*0.3,
                            child: RichText(
                                overflow: TextOverflow.ellipsis ,
                                text: TextSpan(
                                    children: [
                                      TextSpan(text: code, style: TextStyle(color: appColor, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, fontSize: 12)),
                                      TextSpan(text: "\n${DateFormat("dd MMM yyyy").format(DateTime.parse(date))} ", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: Colors.black)))
                                    ]
                                )
                            ),
                          ),
                          SizedBox(width: 20)
                        ]
                    ),
                   Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return index < priority
                              ? Icon(Icons.star, size: 25, color: Color(0xFFFFB24D))
                              : Icon(Icons.star_border, size: 25, color: Color(0xFFFFB24D));
                        }),
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(width: 150,
                                      child: chatView
                                  ),
                                  SizedBox(width: 150,
                                      child: detailsView
                                  ),
                                ],
                              ),


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