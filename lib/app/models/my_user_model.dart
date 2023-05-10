
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../services/settings_service.dart';

class MyUser {
  String name;
  String email;
  String password;
  String phone;
  String birthday;
  String birthplace;
  String sex;
  bool isTraveller = false;
  String typeOfPiece ='';

  MyUser({
    this.name,
     this.email,
    this.password,
     this.phone,
     this.birthday,
    this.birthplace,
     this.sex,
     this.isTraveller,
     this.typeOfPiece,
  });

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
    name: json["name"] ,
    email: json["email"],
    password: json["password"],
    phone: json["phone"],
    birthday: json["birthday"],
    birthplace: json["birthplace"],
    sex: json["sex"],
    isTraveller: json["is_traveller"],
    typeOfPiece: json["type_of_piece"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "phone": phone,
    "birthday": birthday,
    "birthplace": birthplace,
    "sex": sex,
    "is_traveller": isTraveller,
    "type_of_piece": typeOfPiece,
  };

  PhoneNumber getPhoneNumber() {
    if (this.phone != null) {
      this.phone = this.phone.replaceAll(' ', '');
      String dialCode1 = this.phone.substring(1, 2);
      String dialCode2 = this.phone.substring(1, 3);
      String dialCode3 = this.phone.substring(1, 4);
      for (int i = 0; i < countries.length; i++) {
        if (countries[i].dialCode == dialCode1) {
          return new PhoneNumber(countryISOCode: countries[i].code, countryCode: dialCode1, number: this.phone.substring(2));
        } else if (countries[i].dialCode == dialCode2) {
          return new PhoneNumber(countryISOCode: countries[i].code, countryCode: dialCode2, number: this.phone.substring(3));
        } else if (countries[i].dialCode == dialCode3) {
          return new PhoneNumber(countryISOCode: countries[i].code, countryCode: dialCode3, number: this.phone.substring(4));
        }
      }
    }
    return new PhoneNumber(countryISOCode: Get.find<SettingsService>().setting.value.defaultCountryCode, countryCode: '1', number: '');
  }

}
