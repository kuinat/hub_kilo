import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';

class AccountController extends GetxController {
  @override
  void onInit() async{
    await getUser();

    super.onInit();

  }

  onRefresh() async{
    await getUser();
  }

  Future getUser() async {

    final box = GetStorage();
    var sessionId = box.read('session_id');
    var headers = {
      //'Authorization': 'f4306f3775e61e951742869b5a627c49273d069c',
      'Cookie': sessionId.toString()
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/api/res_partner'));
    request.body = '''{\n     "jsonrpc": "2.0"\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)['partner'];
      print('user1  '+data.toString());

    } else {
      print(response.reasonPhrase);
    }
  }
}
