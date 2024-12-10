import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/translation_service.dart';
import '../controllers/language_controller.dart';
import '../widgets/languages_loader_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageView extends GetView<LanguageController> {
  final bool hideAppBar;

  LanguageView({this.hideAppBar = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.colorScheme.secondary,
        appBar: hideAppBar
            ? null
            : AppBar(
          backgroundColor: Get.theme.colorScheme.secondary,
                title: Text(
                  AppLocalizations.of(Get.context).language.tr,
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                  onPressed: () => Get.back(),
                ),
                elevation: 0,
              ),
        body: Container(
          decoration: BoxDecoration(color: backgroundColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)), ),
          child: ListView(
            primary: true,
            children: [
              Obx(() {
                // if (Get.find<LaravelApiClient>().isLoading(task: 'getTranslations')) {
                //   return LanguagesLoaderWidget();
                // }
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: Ui.getBoxDecoration(),
                  child: Column(
                    children: List.generate(controller.languageList.length, (index) {
                      var _lang = controller.languageList.elementAt(index);
                      return RadioListTile(
                        value: _lang ,
                        groupValue: Get.locale.toString()=='fr'? 'Français':'English',
                        activeColor: Get.theme.colorScheme.secondary,
                        onChanged: (value) async{
                          if(value.toString() == "Français"){
                            Get.updateLocale(const Locale('fr'));
                            var languageBox = await GetStorage();
                            languageBox.write('language', 'fr');
                            //MyApp.of(context).setLocale(Locale.fromSubtags(languageCode: 'de')),

                          }
                          else{
                            Get.updateLocale(const Locale('en'));
                            var languageBox = await GetStorage();
                            languageBox.write('language', 'en');

                          }
                          //controller.updateLocale(value);
                        },

                        title: Text(_lang.tr, style: Get.textTheme.bodyText2),
                      );
                    }).toList(),
                  ),
                );
              })
            ],
          ),
        ));
  }
}
