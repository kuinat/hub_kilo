import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/kilos_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/travel_inspect_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'computer_dialog.dart';
import 'envelop_dialog.dart';
import 'kilos_dialog.dart';
import 'other_dialog.dart';

class ChooseLuggageTypeDialog extends GetView<TravelInspectController> {
  ChooseLuggageTypeDialog({Key key,}) ;
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TravelInspectController());

    return SizedBox(
      height: Get.height/2,
      child: Obx(() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: (){
              controller.kilosChecked.value = !controller.kilosChecked.value;
              Navigator.of(context).pop();
            }, icon: Icon(FontAwesomeIcons.remove), color: Colors.red,),
          ),
          controller.specificAirTravelLuggage.isEmpty? Text('Luggage type Loading...', style: TextStyle(color:  labelColor)).marginOnly(bottom: 20) :
          Text('Please select a luggage type', style: TextStyle(color:  labelColor)).marginOnly(bottom: 20),


          Obx(() => SizedBox(
            height: 150,
            child: controller.specificAirTravelLuggage.isEmpty?
            Center(child: SpinKitThreeBounce(color: interfaceColor, size: 20)):
            ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                primary: false,
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                itemCount: controller.specificAirTravelLuggage.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                      child:  Obx(() => Container(
                        width: 120,
                        height: 80,

                        child: Container(
                            padding: EdgeInsets.all(10),
                            margin:EdgeInsets.all(10) ,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: controller.luggageChecked.value?interfaceColor:inactive, width: 1, )),
                            child:Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: FadeInImage(
                                      width: 60,
                                      height: 60,
                                      image: NetworkImage('https://preprod.hubkilo.com/web/image/m2st_hk_airshipping.luggage.type/${controller.specificAirTravelLuggage[index]['luggage_type_id'][0]}/image',
                                          headers: Domain.getTokenHeaders()),
                                      placeholder: AssetImage(
                                          "assets/img/loading.gif"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                            child: Container(
                                                width: 60,
                                                height: 60,
                                                color: Colors.white,
                                                child: Center(
                                                    child: Icon(Icons.photo, size: 150)
                                                )
                                            )
                                        );
                                      },
                                    ),
                                  ),
                                  Text(controller.specificAirTravelLuggage[index]['luggage_type_id'][1],
                                    style: TextStyle(fontSize: 12.0, color: Colors.black),
                                  ),

                                ]))

                      )),

                      onTap: ()=>{
                        if(controller.specificAirTravelLuggage[index]['luggage_type_id'][1]=='KILO'){
                          // controller.kilosChecked.value = !controller.kilosChecked.value,
                          // controller.enveloppeChecked.value = false,
                          // controller.computerChecked.value = false,
                          controller.kilosLuggageId.value = controller.specificAirTravelLuggage[index]['id'],
                          controller.kilosPrice.value = controller.specificAirTravelLuggage[index]['price'],
                          controller.luggageModelId.value = controller.specificAirTravelLuggage[index]['luggage_type_id'][0],
                          controller.imageFiles.clear(),
                          showDialog(
                              useSafeArea: true,
                              context: Get.context,
                              builder: (_){
                                return KilosDialog(editing: false,luggage: controller.specificAirTravelLuggage[index],);
                              }),

                        }else{
                          if(controller.specificAirTravelLuggage[index]['luggage_type_id'][1]=='ENVELOP'){
                            // controller.enveloppeChecked.value = !controller.enveloppeChecked.value,
                            // controller.kilosChecked.value = false,
                            // controller.computerChecked.value = false,
                            controller.envelopPrice.value = controller.specificAirTravelLuggage[index]['price'],
                            controller.envelopLuggageId.value = controller.specificAirTravelLuggage[index]['id'],
                            controller.luggageModelId.value = controller.specificAirTravelLuggage[index]['luggage_type_id'][0],
                            controller.imageFiles.clear(),
                            showDialog(
                                useSafeArea: true,
                                context: Get.context,
                                builder: (_){
                                  return EnvelopDialog(editing: false,luggage: controller.specificAirTravelLuggage[index]);
                                }),

                          }
                          else{
                            if(controller.specificAirTravelLuggage[index]['luggage_type_id'][1]=='COMPUTER'){
                              // controller.computerChecked.value = !controller.computerChecked.value,
                              // controller.enveloppeChecked.value = false,
                              // controller.kilosChecked.value = false,
                              controller.computerPrice.value = controller.specificAirTravelLuggage[index]['price'],
                              controller.computerLuggageId.value = controller.specificAirTravelLuggage[index]['id'],
                              controller.luggageModelId.value = controller.specificAirTravelLuggage[index]['luggage_type_id'][0],
                              controller.imageFiles.clear(),
                              showDialog(
                                  useSafeArea: true,
                                  context: Get.context,
                                  builder: (_){
                                    return ComputerDialog(editing: false,luggage: controller.specificAirTravelLuggage[index]);
                                  }),

                            }
                            else{

                              controller.modelLuggagePrice.value = controller.specificAirTravelLuggage[index]['price'],
                              controller.modelLuggageId.value = controller.specificAirTravelLuggage[index]['id'],
                              controller.modelName.value = controller.specificAirTravelLuggage[index]['luggage_type_id'][1].toString().toLowerCase(),
                              controller.luggageModelId.value = controller.specificAirTravelLuggage[index]['luggage_type_id'][0],
                              controller.imageFiles.clear(),

                              showDialog(
                                  useSafeArea: true,
                                  context: Get.context,
                                  builder: (_){
                                    return OtherDialog(editing: false,luggage: controller.specificAirTravelLuggage[index]);
                                  }),


                            }
                          }

                        }




                      }
                    //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                  );
                }),
          ))


        ],
      ).paddingAll(20),)
    );

  }
}
