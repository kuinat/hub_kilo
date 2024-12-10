
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../services/settings_service.dart';

class EnvelopModel {
  var envelopQuantity;
  var envelopPrice;
  var envelopWidth;
  var envelopHeight;
  var envelopLength;
  var envelopWeight;
  var envelopFormat;
  var envelopDescription;
  var luggageType;
  var imageFiles = [];
  var luggageId;
  var luggageModelId;


  EnvelopModel({
    this.envelopQuantity,
    this.envelopPrice,
    this.envelopHeight,
    this.envelopWeight,
    this.envelopDescription,
    this.envelopWidth,
    this.luggageType,
    this.imageFiles,
    this.luggageId,
    this.envelopLength,
    this.envelopFormat,
    this.luggageModelId


  });


  

}
