
import 'package:app/app/modules/signal_incident/views/chats_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/loading_cards.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../global_widgets/ticket_card.dart';
import '../controller/signal_incident_controller.dart';

class IncidentsView extends GetView<SignalIncidentController> {
  var result;

  var assignedEmployee;

  var attachmentIds = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Get.theme.colorScheme.secondary,
        appBar: AppBar(
          backgroundColor: Get.theme.colorScheme.secondary,
          title:  Text(
            'Reported Incidents'.tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: Colors.white)),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color:Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        floatingActionButton: Container(
          height: 44.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] )),
          child: FloatingActionButton.extended(
              heroTag: null,
              backgroundColor: Colors.transparent,
              onPressed: () async =>{

                Get.toNamed(Routes.SIGNAL_INCIDENT),

              },

              label: Text('Report Incident'),
              icon: Icon(Icons.add, color: Palette.background)
          ),
        ),
        body: RefreshIndicator(
            onRefresh: ()async{
              controller.onRefresh();

            },
            child: buildIncidents(context)
        )
    );
  }

  Widget buildIncidents(BuildContext context){
    return Obx(() => Container(
      height: Get.height,
      width: Get.width,
      padding: EdgeInsets.all(10),
      //margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: backgroundColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0)), ),
      child: Column(
        children: [
          controller.loadIncidents.value ?
          Expanded(child: LoadingCardWidget()) :
          controller.allUserTickets.isNotEmpty ?
          Expanded(
              child: ListView.builder(
                  itemCount: controller.allUserTickets.length,
                  itemBuilder: (context, item){
                    Future.delayed(Duration.zero, (){
                      controller.allUserTickets.sort((a, b) => a["create_date"].compareTo(b["create_date"]));
                    });
                    var ticketState = controller.allUserTickets[item]['is_ticket_closed'] != true? controller.allUserTickets[item]['helpdesk_stage_id'].toString(): '100';
                    print(ticketState);
                    return Obx(() => GestureDetector(
                      onTap: () async {
                        print('attachment ids are: ${controller.allUserTickets[item]['id']}');
                        showDialog(context: context, builder: (context) => SpinKitThreeBounce(
                            color: Colors.white, size: 20
                        ));
                        attachmentIds = await controller.getTicketAttachmentIds(controller.allUserTickets[item]['id']);
                        controller.allUserTickets[item]['res_user_id'] != false?
                        assignedEmployee = await controller.getAssignedEmployee(controller.allUserTickets[item]['res_user_id'])
                            :print('');
                        Navigator.of(context).pop();
                        showDialog(context: context,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            insetPadding: EdgeInsets.all(20),
                            child: ClipRect(
                              child: Banner(
                                location: BannerLocation.topEnd,
                                message: ticketState == "1" ? 'Pending' : ticketState == "2" ? 'In Progress' : ticketState == '3' ? 'Solved' : ticketState == '4' ?'On Hold':ticketState == '5' ? 'Cancelled': ticketState == '100' ? 'Closed': 'Done',
                                color: ticketState == '1' ? inactive : ticketState == '5' ? Colors.orange :ticketState == '100' ? Colors.orange:
                                ticketState == '3' ? validateColor : ticketState == "2" ? pendingStatus : ticketState == "4" ? doneStatus : interfaceColor,
                                child: Card(
                                  elevation: 0,
                                  margin: EdgeInsets.all(20),
                                  child: ListView(children: [
                                    Align(
                                        alignment:Alignment.centerRight,
                                        child: IconButton(onPressed: (){
                                          Navigator.of(context).pop();
                                        }, icon: Icon(FontAwesomeIcons.close, color: Colors.red, weight: 0.8 ,))),
                                    Row(children: [
                                      Text('Ticket Code: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                      Text(controller.allUserTickets[item]['number'], style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),)
                                    ],).marginSymmetric(horizontal: 10, vertical: 10),
                                    Row(children: [
                                      Text('Subject: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                      Text(controller.allUserTickets[item]['name'], style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),)
                                    ],).marginSymmetric(horizontal: 10, vertical: 10),
                                    Row(children: [
                                      Text('Priority: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: List.generate(3, (index) {
                                          return index < int.parse(controller.allUserTickets[item]['priority'])
                                              ? Icon(Icons.star, size: 40, color: Color(0xFFFFB24D))
                                              : Icon(Icons.star_border, size: 40, color: Color(0xFFFFB24D));
                                        }),
                                      ),
                                    ],).marginSymmetric(horizontal: 10, vertical: 10),

                                    Row(children: [
                                      Text('Is ticket still opened: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                      controller.allUserTickets[item]['is_ticket_closed'] != true?Icon( FontAwesomeIcons.check, color: validateColor,):Icon( FontAwesomeIcons.close, color: specialColor,)
                                    ],).marginSymmetric(horizontal: 10, vertical: 10),

                                    Row(children: [
                                      Text('Date: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                      Text(controller.allUserTickets[item]['date'], style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),)
                                    ],).marginSymmetric(horizontal: 10, vertical: 10),
                                    Row(children: [
                                      Text('Description: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                      Expanded(
                                        child: Text(controller.allUserTickets[item]['description'] != ''?controller.allUserTickets[item]['description'].toString().substring(3,controller.allUserTickets[item]['description'].toString().length-4 )
                                            : 'no description', style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),),
                                      )
                                    ],).marginSymmetric(horizontal: 10, vertical: 10),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('Assigned to: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                            controller.allUserTickets[item]['res_user_id'] == false?
                                            Text('Not Assigned', style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),)
                                                :SizedBox()
                                          ]
                                        ),

                                        controller.allUserTickets[item]['res_user_id'] != false?Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ClipOval(
                                                  child: FadeInImage(
                                                      width: 40,
                                                      height: 40,
                                                      fit: BoxFit.cover,
                                                      image: assignedEmployee != null? NetworkImage('${Domain.serverPort}/image/res.users/${assignedEmployee['id']}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders())
                                                          :NetworkImage('', headers: Domain.getTokenHeaders()),
                                                      placeholder: AssetImage(
                                                          "assets/img/loading.gif"),
                                                      imageErrorBuilder:
                                                          (context, error, stackTrace) {
                                                        return Image.asset(
                                                            "assets/img/téléchargement (1).png",
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.fitWidth);
                                                      }
                                                  )
                                              ),
                                              SizedBox(width: 20),
                                              SizedBox(
                                                  height: 40,
                                                  width: Get.width/2.5,
                                                  child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                            child: Text(assignedEmployee != null?assignedEmployee['partner_id'][1]:'', style: Get.textTheme.headline4.merge(TextStyle(fontSize: 13, color: buttonColor)), overflow: TextOverflow.ellipsis,)
                                                        )
                                                      ]
                                                  )
                                              )
                                            ]
                                        ):SizedBox(),
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    ).marginSymmetric(horizontal: 10, vertical: 10),

                                    SizedBox(
                                      height: 140,
                                      width: double.infinity,
                                      child: Column(children: [
                                        Expanded(
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:attachmentIds.length ,
                                              itemBuilder: (context, index){
                                                return InkWell(
                                                    onTap: ()=> showDialog(context: context, builder: (_){
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
                                                              image: NetworkImage('https://preprod.hubkilo.com/ticket/attachment/${attachmentIds[index]}',
                                                                  headers: Domain.getTokenHeaders()),
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
                                                                            child: Icon(Icons.photo, size: 150)
                                                                        )
                                                                    )
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    }),
                                                    child: Card(
                                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                            child: FadeInImage(
                                                              width: 120,
                                                              height: 100,
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage('https://preprod.hubkilo.com/ticket/attachment/${attachmentIds[index]}',
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
                                                    )
                                                );
                                              }),
                                        )
                                      ],),

                                    ),



                                    SizedBox(height: Get.height/15 ,),

                                    Obx(() => BlockButtonWidget(
                                      onPressed: () {
                                        showDialog(context: context,
                                          builder: (context) => AlertDialog(
                                            title: Icon(FontAwesomeIcons.warning, color: Colors.amber,),
                                            content: Text('Are u sure you want to close this case?', style: Get.textTheme.bodyText2.merge(TextStyle(color: Colors.black, fontSize: 12)),),
                                            actions: [
                                              TextButton(
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('cancel', style: TextStyle(color: inactive),)),
                                              TextButton(
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                    controller.closeTicket(controller.allUserTickets[item]['id']);

                                                  },
                                                  child: Text('ok', style: TextStyle(color: interfaceColor),))
                                            ],
                                          ),);
                                      },
                                      color: Get.theme.colorScheme.secondary,
                                      text: !controller.loading.value? Text(
                                        'Close incident',
                                        style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                                      ): SizedBox(height: 30,
                                          child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                                    ).paddingSymmetric(vertical: 10, horizontal: 20),),

                                  ]),
                                ),
                              ),
                            ),
                          ).marginOnly(bottom: Get.height/16),
                        );
                      },
                      child: TicketCard(
                        priority: int.parse(controller.allUserTickets[item]['priority']) ,
                        code: controller.allUserTickets[item]['number'],
                        title:controller.allUserTickets[item]['name'] ,
                        ticketState: controller.allUserTickets[item]['is_ticket_closed'] != true?controller.allUserTickets[item]['helpdesk_stage_id'].toString(): '100',
                        date:controller.allUserTickets[item]['date'] ,
                        detailsView:  TextButton(
                          onPressed: ()async=> {

                          showDialog(context: context, builder: (context) => SpinKitThreeBounce(
                          color: Colors.white, size: 20
                          )),
                            attachmentIds = await controller.getTicketAttachmentIds(controller.allUserTickets[item]['id']),
                            controller.allUserTickets[item]['res_user_id'] != false?
                            assignedEmployee = await controller.getAssignedEmployee(controller.allUserTickets[item]['res_user_id'])
                                :print(''),
                          Navigator.of(context).pop(),
                            print(controller.allUserTickets[item]['id']),
                            showDialog(context: context,
                              builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                insetPadding: EdgeInsets.all(20),
                                child: ClipRect(
                                  child: Banner(
                                    location: BannerLocation.topEnd,
                                    message: ticketState == "1" ? 'Pending' : ticketState == "2" ? 'In Progress' : ticketState == '3' ? 'Solved' : ticketState == '4' ?'On Hold':ticketState == '5' ? 'Cancelled': ticketState == '100' ? 'Closed': 'Done',
                                    color: ticketState == '1' ? inactive : ticketState == '5' ? Colors.orange :ticketState == '100' ? Colors.orange:
                                    ticketState == '3' ? validateColor : ticketState == "2" ? pendingStatus : ticketState == "4" ? doneStatus : interfaceColor,
                                    child: Card(
                                      elevation: 0,
                                      margin: EdgeInsets.all(20),
                                      child: ListView(children: [
                                        Align(
                                            alignment:Alignment.centerRight,
                                            child: IconButton(onPressed: (){
                                              Navigator.of(context).pop();
                                            }, icon: Icon(FontAwesomeIcons.close, color: Colors.red, weight: 0.8 ,))),
                                        Row(children: [
                                          Text('Ticket Code: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                          Text(controller.allUserTickets[item]['number'], style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),)
                                        ],).marginSymmetric(horizontal: 10, vertical: 10),
                                        Row(children: [
                                          Text('Subject: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                          Text(controller.allUserTickets[item]['name'], style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),)
                                        ],).marginSymmetric(horizontal: 10, vertical: 10),
                                        Row(children: [
                                          Text('Priority: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: List.generate(3, (index) {
                                              return index < int.parse(controller.allUserTickets[item]['priority'])
                                                  ? Icon(Icons.star, size: 40, color: Color(0xFFFFB24D))
                                                  : Icon(Icons.star_border, size: 40, color: Color(0xFFFFB24D));
                                            }),
                                          ),
                                        ],).marginSymmetric(horizontal: 10, vertical: 10),

                                        Row(children: [
                                          Text('Is ticket still opened: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                          controller.allUserTickets[item]['is_ticket_closed'] != true?Icon( FontAwesomeIcons.check, color: validateColor,):Icon( FontAwesomeIcons.close, color: specialColor,)
                                        ],).marginSymmetric(horizontal: 10, vertical: 10),

                                        Row(children: [
                                          Text('Date: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                          Text(controller.allUserTickets[item]['date'], style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),)
                                        ],).marginSymmetric(horizontal: 10, vertical: 10),
                                        Row(children: [
                                          Text('Description: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                          Expanded(
                                            child: Text(controller.allUserTickets[item]['description'] != ''?controller.allUserTickets[item]['description'].toString().substring(3,controller.allUserTickets[item]['description'].toString().length-4 )
                                                : 'no description', style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),),
                                          )
                                        ],).marginSymmetric(horizontal: 10, vertical: 10),
                                        Column(
                                          children: [
                                            Row(
                                                children: [
                                                  Text('Assigned to: ', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                                                  controller.allUserTickets[item]['res_user_id'] == false?
                                                  Text('Not Assigned', style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),)
                                                      :SizedBox()
                                                ]
                                            ),
                                            controller.allUserTickets[item]['res_user_id'] != false?Row(
                                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  ClipOval(
                                                      child: FadeInImage(
                                                          width: 40,
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                          image: assignedEmployee != null? NetworkImage('${Domain.serverPort}/image/res.users/${assignedEmployee['id']}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders())
                                                              :NetworkImage('', headers: Domain.getTokenHeaders()),
                                                          placeholder: AssetImage(
                                                              "assets/img/loading.gif"),
                                                          imageErrorBuilder:
                                                              (context, error, stackTrace) {
                                                            return Image.asset(
                                                                "assets/img/téléchargement (1).png",
                                                                width: 50,
                                                                height: 50,
                                                                fit: BoxFit.fitWidth);
                                                          }
                                                      )
                                                  ),
                                                  SizedBox(width: 20),
                                                  SizedBox(
                                                      height: 40,
                                                      width: Get.width/2.5,
                                                      child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                                child: Text(assignedEmployee != null?assignedEmployee['partner_id'][1]:'', style: Get.textTheme.headline4.merge(TextStyle(fontSize: 13, color: buttonColor)), overflow: TextOverflow.ellipsis,)
                                                            )
                                                          ]
                                                      )
                                                  )
                                                ]
                                            ):SizedBox(),
                                        ],
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        ).marginSymmetric(horizontal: 10, vertical: 10),
                                        SizedBox(
                                          height: 140,
                                          width: double.infinity,
                                          child: Column(children: [
                                            Expanded(
                                              child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount:attachmentIds.length ,
                                                  itemBuilder: (context, index){
                                                    return InkWell(
                                                        onTap: ()=> showDialog(context: context, builder: (_){
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
                                                                  image: NetworkImage('https://preprod.hubkilo.com/ticket/attachment/${attachmentIds[index]}',
                                                                      headers: Domain.getTokenHeaders()),
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
                                                                                child: Icon(Icons.photo, size: 150)
                                                                            )
                                                                        )
                                                                    );
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                        child: Card(
                                                            margin: EdgeInsets.symmetric(horizontal: 10),
                                                            child: ClipRRect(
                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                child: FadeInImage(
                                                                  width: 120,
                                                                  height: 100,
                                                                  fit: BoxFit.cover,
                                                                  image: NetworkImage('https://preprod.hubkilo.com/ticket/attachment/${attachmentIds[index]}',
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
                                                        )
                                                    );
                                                  }),
                                            )
                                          ],),

                                        ),

                                        SizedBox(height: Get.height/15 ,),

                                        Obx(() => BlockButtonWidget(
                                          onPressed: () {
                                            showDialog(context: context,
                                              builder: (context) => AlertDialog(
                                                title: Icon(FontAwesomeIcons.warning, color: Colors.amber,),
                                                content: Text('Are u sure you want to close this case?', style: Get.textTheme.bodyText2.merge(TextStyle(color: Colors.black, fontSize: 12)),),
                                                actions: [
                                                  TextButton(
                                                      onPressed: (){
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('cancel', style: TextStyle(color: inactive),)),
                                                  TextButton(
                                                      onPressed: (){
                                                        Navigator.of(context).pop();
                                                        controller.closeTicket(controller.allUserTickets[item]['id']);
                                                      },
                                                      child: Text('ok', style: TextStyle(color: interfaceColor),))
                                                ],
                                              ),);

                                          },
                                          color: Get.theme.colorScheme.secondary,
                                          text: !controller.loading.value? Text(
                                            'Close incident',
                                            style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                                          ): SizedBox(height: 30,
                                              child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                                        ).paddingSymmetric(vertical: 10, horizontal: 20),),

                                      ]),
                                    ),
                                  ),
                                ),
                              ).marginOnly(bottom: Get.height/16),
                            )
                          },
                          child: Text(AppLocalizations.of(context).moreInfo, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: interfaceColor))),
                        ),
                        chatView: TextButton.icon(
                          onPressed: ()async=> {
                            showDialog(context: context, builder: (context) => SpinKitThreeBounce(
                                color: Colors.white, size: 20
                            )),
                            await controller.messages.clear(),
                            controller.messagesSent.clear(),
                            controller.ticketFiles.clear(),
                            controller.ticketId.value= controller.allUserTickets[item]['id'],
                            result = await controller.getMessages(controller.allUserTickets[item]['id']),
                            for(var i = 0; i<result.length; i++){
                              if(!controller.messages.contains(result[i])){
                                //messages.add(result[i]);
                                controller.messages.value.insert(0, result[i]),
                              }
                            },
                            Navigator.of(context).pop(),

                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> ChatsView(controller.allUserTickets[item]['id'], controller.allUserTickets[item]['number']))),
                          },
                          icon: Icon(FontAwesomeIcons.comment, color: interfaceColor),
                         label: Text('Message ', style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: interfaceColor))),
                        ),
                      ),
                    ));
                  }

              ).marginOnly(bottom: 50)
          ) :
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height/3),
                FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                Text('No reported Incidents', style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3)))),
              ],
            ),
          ),
        ],
      ),
    ));
  }

}
