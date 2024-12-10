
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/loading_cards.dart';
import '../controllers/account_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingsView extends GetView<AccountController> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //Get.theme.colorScheme.secondary,
        appBar: AppBar(
          backgroundColor: background,
          title:  Text(
            AppLocalizations.of(context).myRatings.tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: appColor)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: appColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: RefreshIndicator(
            onRefresh: ()async{
              controller.onRefresh();
            },
            child: buildRatingsList(context)
        )
    );
  }

  Widget buildRatingsList(BuildContext context){
    return Obx(() => Container(
      height: Get.height,
      width: Get.width,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Column(
        children: [
          controller.loading.value ?
          Expanded(child: LoadingCardWidget()) :
          Expanded(
            child: ListView.builder(
                itemCount: controller.ratings.length+1,
                itemBuilder: (_, index){
                  if(index != controller.ratings.length){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: background,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipOval(
                                  child: FadeInImage(
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    image: NetworkImage('${Domain.serverPort}/image/res.partner/${controller.ratings[index]['rater_id'][0]}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                                    placeholder: AssetImage(
                                        "assets/img/loading.gif"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/img/téléchargement (3).png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fitWidth);
                                    },
                                  )
                              ),
                              Flexible(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(left: 10),
                                        width: Get.width,
                                        margin: EdgeInsets.only(top: 5.0),
                                        child: Row(
                                            children: [
                                              Expanded(child: Text(controller.ratings[index]['rater_id'][1],
                                                style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 12)),
                                              )),
                                              for(var i=0; i < int.parse(controller.ratings[index]['rating']); i++)...[
                                                Text('⭐️')
                                              ]
                                            ]
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text("\n" + controller.ratings[index]['comment'].toString(),
                                          style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 10)),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                              DateFormat('dd, MMM yyyy').format(DateTime.parse(controller.ratings[index]['rating_date'])),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Get.textTheme.headline1.merge(TextStyle(color: appColor,fontSize: 12))
                          ),
                        ),
                      ],
                    );
                  }else{
                    return SizedBox(height: Get.height/3);
                  }
                }),
          )
        ],
      ),
    ));
  }

}
