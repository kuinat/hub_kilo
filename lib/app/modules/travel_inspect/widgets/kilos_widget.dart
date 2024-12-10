import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/kilos_model.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;

import 'kilos_dialog.dart';

class KilosWidget extends StatelessWidget {
  String kilosDescription;
  double kilosWeight;
  double kilosWidth;
  double kilosHeight;
  double kilosLength;
  double kilosPrice;
  bool editing = false;
  Function onPressed;
  Function onEditPressed;
  var kilosLuggageId;
  var imageFiles;
  var luggageModelId;

  KilosWidget({Key key,this.kilosDescription, this.kilosWeight, this.onPressed, this.editing, this.kilosLuggageId, this.kilosWidth, this.kilosHeight, this.kilosPrice, this.imageFiles, this.onEditPressed, this.kilosLength, this.luggageModelId}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: inactive, width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
        [
          Container(
              padding: EdgeInsets.all(10),
              margin:EdgeInsets.all(10) ,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: inactive, width: 1, )),
              child:Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: FadeInImage(
                        width: 60,
                        height: 60,
                        image: NetworkImage('https://preprod.hubkilo.com/web/image/m2st_hk_airshipping.luggage.type/$luggageModelId/image',
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
                    Text('Kilos',
                      style: TextStyle(fontSize: 12.0, color: Colors.black),
                    ),

                  ])),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Price / kilo: ', style: TextStyle(color: labelColor),),
                    Text(kilosPrice.toString()+' EURO', style: TextStyle(color: Colors.black)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(onPressed: (){
                      showDialog(
                          context: Get.context,
                          useSafeArea: true,
                          barrierDismissible: true ,
                          builder: (_){
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              margin: EdgeInsets.fromLTRB(40, 40, 40, Get.height*0.3),
                              child: Column(
                                children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(onPressed: (){
                                          Navigator.of(context).pop();
                                        }, icon: Icon(FontAwesomeIcons.remove, color: Colors.red,)),
                                      ).marginOnly(bottom: 20),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Quantity: ', style: TextStyle(color: labelColor)),
                                      Text('1', style: TextStyle(color: Colors.black, fontSize: 12))
                                    ],

                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Description: ', style: TextStyle(color: labelColor)),
                                      Text(kilosDescription, style: TextStyle(color: Colors.black, fontSize: 12))
                                    ],

                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Weight: ', style: TextStyle(color: labelColor)),
                                      Text(kilosWeight.toString(), style: TextStyle(color: Colors.black, fontSize: 12))
                                    ],

                                  ),


                                  Align(
                                    alignment: Alignment.centerLeft,
                                      child: Text('Picture of your luggage',style: TextStyle(color: labelColor) )).marginOnly(top: 20, bottom: 10),
                                  !editing?SizedBox(
                                    height: 200,
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.all(12),
                                        itemBuilder: (context, index){
                                          return Stack(
                                            //mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 10),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    child: Image.file(
                                                      imageFiles[index],
                                                      fit: BoxFit.cover,
                                                      width: Get.width/2,
                                                      height:Get.width/2,
                                                    ),
                                                  )
                                              ),

                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index){
                                          return SizedBox(width: 8);
                                        },
                                        itemCount: imageFiles.length),
                                  )
                                      :SizedBox(
                                      width: double.infinity,
                                      height: Get.width/2,
                                      child:  Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: 12,
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
                                                                image: NetworkImage('${Domain.serverPort}/image/m2st_hk_airshipping.luggage/$kilosLuggageId/luggage_image${index+1}?unique=true&file_response=true',
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
                                                          margin: EdgeInsets.all(10),
                                                          child: ClipRRect(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              child: FadeInImage(
                                                                width: 120,
                                                                height: 100,
                                                                fit: BoxFit.cover,
                                                                image: NetworkImage('${Domain.serverPort}/image/m2st_hk_airshipping.luggage/$kilosLuggageId/luggage_image${index+1}?unique=true&file_response=true',
                                                                    headers: Domain.getTokenHeaders()),
                                                                placeholder: AssetImage(
                                                                    "assets/img/loading.gif"),
                                                                imageErrorBuilder:
                                                                    (context, error, stackTrace) {
                                                                  return Image.asset(
                                                                      'assets/img/240_F_89551596_LdHAZRwz3i4EM4J0NHNHy2hEUYDfXc0j.jpg',
                                                                      width: 120,
                                                                      height: 80,
                                                                      fit: BoxFit.fitWidth);
                                                                },
                                                              )
                                                          )
                                                      )
                                                  );
                                                }),
                                          )
                                        ],
                                      )
                                  )



                                ],
                              ).paddingAll(20),
                            );
                          });
                    }, child: Align(
                      alignment: Alignment.centerLeft,
                        child: Text('View Details', style: TextStyle(decoration: TextDecoration.underline,),))),
                    SizedBox(),
                  ],
                ),
              ],
            ),
          ),

          editing?
            IconButton(onPressed: onEditPressed, icon: Icon(FontAwesomeIcons.edit)):
          IconButton(onPressed: onPressed, icon: Icon(FontAwesomeIcons.trashCan))
        ],),
    );
  }



}
