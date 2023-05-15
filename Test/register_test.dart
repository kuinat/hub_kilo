import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;


void main() {
  group('Register a user', () {
    var isResgistered = '';
    var email = "green@gmail.com";
    var name = "userTest";
    var password = "password";
    var phone = "+237620456987";
    var birthday = "20/02/04";
    var birthplace = "Nairobi";
    var sex = "Male";
    bool isTraveller = false ;


    test('email should contain @', ()
    {
      expect(email.contains('@'), true);
    });
    test('name should contains at least 3 letters', ()
    {
      expect(name.length>=3, true);
    });
    test('birthplace should contains at least 3 letters', ()
    {
      expect(birthplace.length>=3, true);
    });
    test('password should contains at least 3 letters', ()
    {
      expect(password.length>=3, true);
    });

    test('Register User', () async {
      //print('birthday : '+myUser.birthday);
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': 'session_id=876df4f26c8f83c635dd22902544d31f0eff091c'
      };
      var request = http.Request('POST', Uri.parse('http://192.168.16.110:8069/create/new/partner'));
      request.body = json.encode(
          {
            "jsonrpc": "2.0",
            "params": {
              "name": name,
              "email": email,
              "phone": phone,
              "birthday": birthday,
              "birthplace": birthplace,
              "sex": sex,
              "is_traveler": false,
              "password": password,

            }
          }
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();
         isResgistered = json.decode(result).toString();

      }
      else {
        print(response.reasonPhrase);
      }
      expect(isResgistered.contains('result'), true);



      


    });

  });



}