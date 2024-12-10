import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/card_widget.dart';
import '../../global_widgets/loading_cards.dart';
import '../../global_widgets/pop_up_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/all_expedition_offer_controller.dart';
import '../../home/controllers/home_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controllers/all_reception_offer_controller.dart';

class ReceptionsOffersView extends GetView<AllReceptionsOffersController> {
  @override
  Widget build(BuildContext context) {

    Get.put(AllReceptionsOffersController());

    Get.lazyPut<HomeController>(
          () => HomeController(),
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        floatingActionButton: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                if(controller.currentPage.value != 1){
                  controller.currentPage.value --;
                  controller.refreshPage(controller.currentPage.value);
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.arrow_back_ios, color: controller.currentPage.value != 1 ? Colors.black : inactive)
                ),
              ),
            ),
            Card(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text('${controller.currentPage.value} / ${controller.totalPages.value}', textAlign: TextAlign.center, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: appColor)))
                )
            ),
            InkWell(
              onTap: () {
                if(controller.currentPage.value != controller.totalPages.value){
                  controller.currentPage.value ++;
                  controller.refreshPage(controller.currentPage.value);
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.arrow_forward_ios_sharp, color: controller.currentPage.value != controller.totalPages.value? Colors.black : inactive)
                ),
              ),
            )
          ],
        )),
        bottomSheet: Obx(() =>

            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 90,
                child: Center(
                    child: BlockButtonWidget(
                      onPressed: () async =>{
                        controller.buttonPressed.value = true,
                        //controller.editShipping(controller.shipping)
                        for(var shipping in controller.receptionOffersSelected){
                          await controller.joinShippingTravel(shipping),
                        },
                        Navigator.of(context).pop(),

                      },
                      color: Get.theme.colorScheme.secondary,
                      text: !controller.buttonPressed.value ? SizedBox(
                        //width: Get.width/1.5,
                          child: Text(
                            '${AppLocalizations.of(context).joinExpedition}(s)'.tr,
                            style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                          )
                      ) : SizedBox(height: 20,
                          child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                    ).paddingSymmetric(vertical: 10, horizontal: 20)
                )
            )
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              controller.refreshPage(1);
            },
            child: CustomScrollView(
                controller: controller.scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                      backgroundColor: buttonColor,
                      expandedHeight: 140,
                      elevation: 0.5,
                      primary: true,
                      pinned: true,
                      floating: false,
                      iconTheme: IconThemeData(color: Get.theme.primaryColor),
                      title: Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        width: 120,
                        child: Text(AppLocalizations.of(context).road, style: Get.textTheme.headline2.merge(TextStyle(color: Colors.white))),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            border: Border.all(
                              color:Colors.white.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                      ),
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      leading: new IconButton(
                        icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      actions: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: Obx(() => Center(
                                child: Text(
                                    controller.allReceptionOffers.length.toString(),
                                    style: Get.textTheme.headline5.merge(TextStyle(color: interfaceColor))),
                              )),
                            )
                        )
                      ],
                      bottom: PreferredSize(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: Get.width/1.8,
                                      child: TextFormField(
                                        //controller: controller.textEditingController,
                                          style: Get.textTheme.bodyText2,
                                          onChanged: (value)=> controller.filterSearchResults(value),
                                          autofocus: false,
                                          cursorColor: Get.theme.focusColor,
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(width: 1, color: buttonColor),
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                              hintText: AppLocalizations.of(context).searchHere,
                                              filled: true,
                                              fillColor: Colors.white,
                                              suffixIcon: Icon(Icons.search),
                                              hintStyle: Get.textTheme.caption,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                                          )
                                      )
                                  ),
                                  SizedBox(width: 10)
                                ],
                              )
                          ),
                          preferredSize: Size.fromHeight(50.0)),
                      flexibleSpace: Row(
                          children: [
                            Container(
                                width: Get.width,
                                child: FlexibleSpaceBar(
                                  background: Container(
                                    width: double.infinity,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(controller.imageUrl.value), fit: BoxFit.cover)
                                    ),
                                  ),
                                )
                            )
                          ]
                      )
                  ),
                  SliverToBoxAdapter(
                      child: Wrap(
                          children: [
                            Obx(() =>
                            controller.receptionsOffersLoading.value?
                            LoadingCardWidget() :
                            controller.allReceptionOffers.isNotEmpty ?
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: controller.allReceptionOffers.length+1 ,
                                    shrinkWrap: true,
                                    primary: false,

                                    itemBuilder: (context, index) {

                                      if (index == controller.allReceptionOffers.length) {
                                        return SizedBox(height: 120);
                                      } else {

                                        Future.delayed(Duration.zero, (){
                                          controller.allReceptionOffers.sort((a, b) => b["create_date"].compareTo(a["create_date"]));
                                        });
                                        return InkWell(
                                            onTap: ()async=>{
                                              controller.receptionOffersSelected.clear(),
                                              controller.shippingSelected.value = true,
                                              controller.receptionOffersSelected.add(controller.allReceptionOffers[index]),
                                              print('added lenght is: '+controller.receptionOffersSelected.length.toString()),

                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: controller.receptionOffersSelected.contains(controller.allReceptionOffers[index]) ? Border.all(color: interfaceColor,width: 2) : null,
                                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                              ),
                                              child: CardWidget(
                                                //selected: controller.shippingSelected.value,
                                                  owner: true,
                                                  user: controller.allReceptionOffers[index]['bool_parcel_reception'] ?
                                                  controller.allReceptionOffers[index]['parcel_reception_receiver_partner_id'][1] : controller.allReceptionOffers[index]['partner_id'][1],
                                                  imageUrl: controller.allReceptionOffers[index]['bool_parcel_reception'] ?
                                                  '${Domain.serverPort}/image/res.partner/${controller.allReceptionOffers[index]['parcel_reception_receiver_partner_id'][0]}/image_1920?unique=true&file_response=true' :
                                                  '${Domain.serverPort}/image/res.partner/${controller.allReceptionOffers[index]['partner_id'][0]}/image_1920?unique=true&file_response=true',
                                                  travellerDisagree: controller.allReceptionOffers[index]['disagree'],
                                                  shippingDate: controller.allReceptionOffers[index]['create_date'],
                                                  code: controller.allReceptionOffers[index]['name'],
                                                  travelType: controller.allReceptionOffers[index]['booking_type'],
                                                  transferable: controller.allReceptionOffers[index]['state'].toLowerCase()=='rejected' || controller.allReceptionOffers[index]['state'].toLowerCase()=='pending' ? true:false,
                                                  bookingState: controller.allReceptionOffers[index]['state'],
                                                  price: controller.allReceptionOffers[index]['shipping_price'],
                                                  text: "${controller.allReceptionOffers[index]['shipping_departure_city_id'][1].split(" ").first} > ${controller.allReceptionOffers[index]['shipping_arrival_city_id'][1].split(" ").first}",
                                                  detailsView: TextButton(
                                                    onPressed: ()async=> {

                                                    },
                                                    child: Text(AppLocalizations.of(context).moreInfo, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: interfaceColor))),
                                                  ),
                                                  negotiation:  SizedBox()

                                              ),
                                            )
                                        );}
                                    })):
                            Center(
                              child: Column(
                                  children: [
                                    SizedBox(height: MediaQuery.of(context).size.height /4),
                                    FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                                    Text(AppLocalizations.of(context).noShippingFound, style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                                  ]
                              ),
                            ),
                            )
                          ]))])));
  }


  Container buildSearchBar(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1.5;
    return Container(
      height: 40,
      width: width,
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        //controller: controller.textEditingController,
        style: Get.textTheme.bodyText2,
        onChanged: (value)=> controller.filterSearchResults(value),
        autofocus: false,
        cursorColor: Get.theme.focusColor,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: buttonColor),
              borderRadius: BorderRadius.circular(20.0),
            ),
            hintText: AppLocalizations.of(context).create,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.search),
            hintStyle: Get.textTheme.caption,
            contentPadding: EdgeInsets.all(10)
        ),
      ),
    );
  }
}


