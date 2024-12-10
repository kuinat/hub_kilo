import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../../../providers/odoo_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../add_ravel_form/controller/add_travel_controller.dart';
import '../../root/controllers/root_controller.dart';
import '../../travel_inspect/controllers/travel_inspect_controller.dart';
import '../views/invoice_view.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingsController extends GetxController {

  //final Rx<MyUser> currentUser = Get.find<MyAuthService>().myUser;

  final myExpeditionsPage = 0.obs;
  final offerExpedition = false.obs;
  final offerReception = false.obs;
  final shippingSelected = false.obs;
  var expeditionOffersSelected = [].obs;
  var allShippingOffers = [].obs;
  final currentPage = 0.obs;
  final currentSlide = 0.obs;
  final quantity = 1.0.obs;
  final luggageWidth = 1.0.obs;
  final luggageHeight= 1.0.obs;
  final description = ''.obs;
  final imageUrl = "".obs;
  final errorField = false.obs;
  final bookingStep = 0.obs;
  final elevation = 0.obs;
  final name = "".obs;
  final email = "".obs;
  final phone = "".obs;
  final address = "".obs;
  final selectUser = false.obs;
  final buttonPressed = false.obs;
  final editPhotos = true.obs;
  var showTravelInfo = false.obs;
  var transferBooking = false.obs;
  var bookingIdForTransfer =0.obs;
  var luggageModels = [].obs;
  var luggageSelected = [].obs;
  var users =[].obs;
  var roadShippingLuggage =[].obs;
  var airShippingLuggage =[].obs;
  var editLuggage = false.obs;
  var shippingLoading = false.obs;
  final luggageLoading = true.obs;
  final shippingPrice = 0.0.obs;
  var selectedIndex = 0.obs;
  var luggageIndex = 0.obs;
  var selected = false.obs;
  var receiverId = 0.obs;
  final heroTag = "".obs;
  Rx<DocumentSnapshot> lastDocument = new Rx<DocumentSnapshot>(null);
  final isLoading = true.obs;
  final invoiceLoading = true.obs;
  final isDone = false.obs;
  var imageFiles = [].obs;
  var items = [].obs;
  var itemsMyShippingRequest = [].obs;
  var itemsMyShippingOffer = [].obs;
  var itemsMyReceptionOffer = [].obs;
  var allMyShippingList = [].obs;
  var allShippingItem = [].obs;
  var luggageId = [].obs;
  var itemsBookingsOnMyTravel = [].obs;
  ScrollController scrollController = ScrollController();
  var listShippingRequest = [];
  var listShippingOffer = [];
  var listReceptionOffer = [];
  var copyPressed = false.obs;
  var isClicked = false.obs;
  var roadShippingList = [];
  var airShippingList = [];
  var viewPressed = false.obs;
  var listBeneficiaries =[];
  var listUsers = [].obs;
  //var originShippingRequest = [].obs;
  var originShippingRequest = [].obs;
  var originShippingOffer = [].obs;
  var originReceptionOffer = [].obs;
  var userExist = false.obs;
  var typing = false.obs;
  var viewUsers = [].obs;
  var invoice = [].obs;
  var selectedUser = false.obs;
  var selectedUserIndex = 0.obs;
  final loadProfileImage = false.obs;
  final _picker = ImagePicker();
  File profileImage;
  var shippingDetails = {}.obs;
  var travelDetails = {}.obs;
  var luggageTypes = ["envelope", "briefcase", "suitcase", "other"].obs;
  var luggageType = "".obs;
  var payPressed = false.obs;
  var selectedStatus = "".obs;
  var status = ["ALL", "PENDING", "ACCEPTED", "CANCEL", "PAID", "CONFIRM ", "RECEIVED"];
  var selectedClicked = false.obs;
  var ratings =[].obs;
  var viewRatings = false.obs;
  TextEditingController commentController = TextEditingController();
  var predict1 = false.obs;
  var errorCity1 = false.obs;
  TextEditingController city = TextEditingController();
  var street = "".obs;
  var cityId = 0.obs;
  var countries = [].obs;
  var listCountries = [];
  var owner = true.obs;
  var price = 0.0.obs;
  var receiverDto = {}.obs;
  var luggageDto = {}.obs;
  var paymentLink = "".obs;
  var shippingType = ''.obs;
  var showButton = false.obs;



  var expeditionsOffersLoading = false.obs;

  var myTravelList;
  var valueDropDownExpedition = ''.obs;

  var publishedTravel;


  BookingsController() {
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    Get.lazyPut<TravelInspectController>(
          () => TravelInspectController(),
    );
    Get.lazyPut<AddTravelController>(
          () => AddTravelController(),
    );

  }

  @override
  void onInit() async{
    super.onInit();
    bookingStep.value = 0;
    currentPage.value = 0;
    valueDropDownExpedition.value = status[0];
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );

    await initValues();
  }

  @override
  void onReady()async{
    heroTag.value = Get.arguments.toString();
    await initValues();
    super.onReady();
  }


  initValues()async{

    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    final box = GetStorage();
    listCountries = box.read("allCountries");

    await getUser(Get.find<MyAuthService>().myUser.value.id);

    List models = await getAllLuggageModel();
    listUsers.value = await getAllUsers();
    luggageModels.value = models;
    //users.value = listUsers;
    isLoading.value = false;

    allShippingOffers.value = await getAllExpeditionOffers();

    //await getAllUsers();

    listBeneficiaries = await getAllBeneficiaries(Get.find<MyAuthService>().myUser.value.id);
    users.value = listBeneficiaries;



  }

  refreshBookings()async{
    //currentPage.value = 0;
    status = ["ALL", "PENDING", "ACCEPTED", "CANCEL", "PAID", "CONFIRM ", "RECEIVED"];
    isLoading.value = true;
    await getUser(Get.find<MyAuthService>().myUser.value.id);
    List models = await getAllLuggageModel();
    listUsers.value = await getAllUsers();
    luggageModels.value = models;
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = listBeneficiaries;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['display_name']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      users.value = dummyListData;
      return;
    } else {
      users.value = listBeneficiaries;
    }
  }

  void filterSearchCity(String query) {
    List dummySearchList = [];
    dummySearchList = listCountries;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['display_name']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      countries.value = dummyListData;
      for(var i in countries){
        print(i['display_name']);
      }
      return;
    } else {
      countries.value = listCountries;
    }
  }

  getUser(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)[0];
      print(data);
      roadShippingList = data['shipping_ids'];
      airShippingList = data['air_shipping_ids'];
      myTravelList = data['travelbooking_ids'];

      await getUserPublishedTravel();

      var roadShippings = await getMyRoadShippingRequests(roadShippingList);
      var airShippings = await getMyAirShippingRequests(airShippingList);
      //var receptionOffers = await getMyReceptionOffers();

      allMyShippingList.clear();
      allMyShippingList.addAll(roadShippings);
      allMyShippingList.addAll(airShippings);
      //allMyShippingList.addAll(receptionOffers);
      allShippingItem.value = allMyShippingList;
      //print('listReceptionoffer: ${receptionOffers.length}');

      listShippingOffer.clear();
      listShippingRequest.clear();
      listReceptionOffer.clear();
      for(int i=0; i<allMyShippingList.length; i++){
        if((allMyShippingList[i]['travelbooking_id']!=false )){
          if(allMyShippingList[i]['booking_type']=='By Air' ){
            listShippingRequest.add(allMyShippingList[i]);
          }
          else{
            if(allMyShippingList[i]['bool_parcel_reception']==false){
              listShippingRequest.add(allMyShippingList[i]);
            }
            else{
              listReceptionOffer.add(allMyShippingList[i]);
            }
          }

        }
        else{
          if(allMyShippingList[i]['bool_parcel_reception']==false){
            listShippingOffer.add(allMyShippingList[i]);
          }
          else{
            listReceptionOffer.add(allMyShippingList[i]);
          }

        }
      }
      print('listReceptionoffer: ${listReceptionOffer.length}');

      itemsMyShippingRequest.value = listShippingRequest;
      itemsMyShippingOffer.value = listShippingOffer;
      itemsMyReceptionOffer.value = listReceptionOffer;
      originShippingRequest.value = listShippingRequest;
      originShippingOffer.value = listShippingOffer;
      originReceptionOffer.value = listReceptionOffer;
      isLoading.value = false;
    } else {
      var data = await response.stream.bytesToString();
      print("error finding user from shipping");
    }
  }

  getUserPublishedTravel()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=$myTravelList'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      var result = json.decode(data);
      for(int i = 0; i<result.length; i++){
        if(result[i]['state'] == 'negotiating'){
          publishedTravel = result[i];
          print('published Travel: $publishedTravel');
        }

      }
    }
    else {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      print(data);
    }




  }

  getUserRating(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      getRating(json.decode(data)[0]['given_rating_ids']);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getRating(var ids)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner.rating?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      viewRatings.value = true;
      ratings.value = json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }


  createShippingLuggage(var item)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.luggage?values={'
        '"average_height": ${item["average_height"]},'
        '"average_weight": ${item["average_weight"]},'
        '"average_width": ${item["average_width"]},'
        '"luggage_model_id": ${item["id"]}'
        '}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      luggageId.value = [];
      var data = await response.stream.bytesToString();
      luggageId.add(json.decode(data)[0]);
      print("added id: $luggageId");
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }

  deleteShippingLuggage(var luggageId)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('DELETE', Uri.parse('${Domain.serverPort}/unlink/m1st_hk_roadshipping.luggage?ids=$luggageId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      bookingStep.value = 0;
      print(data);
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
  }

  Future getAllLuggageModel()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/m0sthk.luggage_model'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      luggageLoading.value = false;
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getAllUsers()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=a3ffbeb70a9e310852261c236548fc5735e96419'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/res.users'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getMyRoadShippingRequests(var ids) async {

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };

    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.shipping?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      //isLoading.value = false;
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getMyReceptionOffersIds()async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com/mobile/road/receiver/shipping/get_details'));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "partner_id": Get.find<MyAuthService>().myUser.value.id
      }
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      var list = [];
      isLoading.value = false;
      print(json.decode(data));
      if(json.decode(data)['result'] != 'No Parcel Found!'){
        if(json.decode(data)['result']['response'] != null){
          var result = json.decode(data)['result']['response'];
          for(var shipping in result){
            list.add(shipping['shipping_id']);
          }
        }else{
          list = [];
        }
      }

      return list;
    }
    else {
      print(response.reasonPhrase);
      return [];
    }
  }

  Future getMyReceptionOffers() async {
    var ids = await getMyReceptionOffersIds();

    print('reception ofers ids are: $ids');


    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };

    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.shipping?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      //isLoading.value = false;
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getMyAirShippingRequests(var ids) async {

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };

    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.shipping?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      //isLoading.value = false;
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getAllExpeditionOffers() async{
    expeditionsOffersLoading.value = true;
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/m1st_hk_roadshipping.shipping'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();
      var result =json.decode(data);

      var list = [];
      for(int i = 0; i < result.length; i++){
        if(result[i]['travelbooking_id']== false){
          list.add(result[i]);
        }
      }
      expeditionsOffersLoading.value = false;


      return list;
    }
    else {
      print(response.reasonPhrase);
    }


  }

  Future getRoadTravelInfo(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      travelDetails.value = json.decode(data)[0];
    }
    else {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      print(data);
    }
  }

  Future getAirTravelInfo(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.travelbooking?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      travelDetails.value = json.decode(data)[0];
    }
    else {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      print(data);
    }
  }

  uploadProfileImage(File file, int id) async {
    if (Get.find<MyAuthService>().myUser.value.email==null) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ uploadImage() ]");
    }

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'multipart/form-data',
      'Cookie': 'session_id=a5b5f221b0eca50ae954ad4923fead1063097951'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverPort}/upload/res.partner/$id/image_1920'));
    request.files.add(await http.MultipartFile.fromPath('ufile', file.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {
      await response.stream.bytesToString();
      //var user = await getUser();
      //var uuid =user.image ;

      //return uuid;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  transferShipping(int booking_id)async{
    transferBooking.value = true;
    bookingIdForTransfer.value = booking_id;
    print (bookingIdForTransfer.value.toString());
    // Get.offAndToNamed(Routes.AVAILABLE_TRAVELS);
    await Get.offAndToNamed(Routes.AVAILABLE_TRAVELS);

  }

  payAirShipping(int shipping_id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m2st_hk_airshipping.shipping/pay_shipping/?ids=$shipping_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

  getUserInvoice(int ids)async{
    print(ids);
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/account.move?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      invoice.value = json.decode(data);

      showDialog(
          context: Get.context,
          builder: (_){
            return InvoiceView();
          });

    }
    else {
      var data = await response.stream.bytesToString();
      print(json.decode(data)['message']);
      //Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }


  getRoadShipping(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.shipping?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      payPressed.value = false;
      Get.find<BookingsController>().shippingDetails.value = json.decode(data)[0];
      await getUserInvoice(json.decode(data)[0]['move_id'][0]);
      paymentLink.value = json.decode(data)[0]['payment_link'];

    }
    else {
      print(response.reasonPhrase);
    }
  }

  getAirShipping(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.shipping?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      payPressed.value = false;
      Get.find<BookingsController>().shippingDetails.value = json.decode(data)[0];
      await getUserInvoice(json.decode(data)[0]['move_id'][0]);
      paymentLink.value = json.decode(data)[0]['payment_link'];

    }
    else {
      print(response.reasonPhrase);
    }
  }

  launchURL(var link) async {
    if(link.toString() != "false"){
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text(link.toString()),
        backgroundColor: validateColor.withOpacity(0.4),
        margin: EdgeInsets.only(
            bottom: Get.height - 160,
            left: 10,
            right: 10),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ));

      final Uri url = Uri.parse(link);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }else{
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text("Error occurred...[$link]"),
        margin: EdgeInsets.only(
            bottom: Get.height - 160,
            left: 10,
            right: 10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: specialColor.withOpacity(0.4),
        duration: Duration(seconds: 2),
      ));
    }
  }

  cancelRoadShipping(int shipping_id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m1st_hk_roadshipping.shipping/set_to_rejected/?ids=$shipping_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      final data = await response.stream.bytesToString();
      print(data);
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text("Loading data..."),
        duration: Duration(seconds: 3),
      ));
      await getUser(Get.find<MyAuthService>().myUser.value.id);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Shipping Canceled"));
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);

      listShippingOffer.clear();
      listShippingRequest.clear();
      listReceptionOffer.clear();
      allShippingItem.value = await getMyRoadShippingRequests(roadShippingList);
      listShippingOffer.clear();
      listShippingRequest.clear();
      listReceptionOffer.clear();
      for(int i=0; i<allShippingItem.length; i++){
        if(allShippingItem[i]['travelbooking_id']!=false){
          listShippingRequest.add(allShippingItem[i]);
        }
        else{
          if(allShippingItem[i]['bool_parcel_reception']==false){
            listShippingOffer.add(allShippingItem[i]);
          }
          else
            {
              listReceptionOffer.add(allShippingItem[i]);
            }


        }
      }
      itemsMyShippingRequest.value = listShippingRequest;
      itemsMyShippingOffer.value = listShippingOffer;

    }
    else {
      final data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
      throw new Exception(response.reasonPhrase);
    }
  }

  cancelAirShipping(int shipping_id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m2st_hk_airshipping.shipping/set_to_rejected/?ids=$shipping_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      final data = await response.stream.bytesToString();
      print(data);
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text("Loading data..."),
        duration: Duration(seconds: 3),
      ));
      await getUser(Get.find<MyAuthService>().myUser.value.id);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Shipping Canceled"));
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);

      listShippingOffer.clear();
      listShippingRequest.clear();
      listReceptionOffer.clear();
      allShippingItem.value = await getMyAirShippingRequests(airShippingList);
      listShippingOffer.clear();
      listShippingRequest.clear();
      listReceptionOffer.clear();
      for(int i=0; i<allShippingItem.length; i++){
        if(allShippingItem[i]['travelbooking_id']!=false){
          listShippingRequest.add(allShippingItem[i]);
        }
        else{
          if(allShippingItem[i]['bool_parcel_reception']==false){
            listShippingOffer.add(allShippingItem[i]);
          }
          listReceptionOffer.add(allShippingItem[i]);
        }
      }
      itemsMyShippingRequest.value = listShippingRequest;
      itemsMyShippingOffer.value = listShippingOffer;
      itemsMyReceptionOffer.value = listReceptionOffer;

    }
    else {
      final data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
      throw new Exception(response.reasonPhrase);
    }
  }

  Future <File> pickImage(ImageSource source) async {

    ImagePicker imagePicker = ImagePicker();

    if(source.toString() == ImageSource.camera.toString())
    {
      XFile pickedFile = await imagePicker.pickImage(source: source, imageQuality: 80);
      File imageFile = File(pickedFile.path);
      if(imageFiles.length<3)
      {
        imageFiles.add(imageFile) ;
      }
      else
      {
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).photoUploadLimitations.tr));
        throw new Exception(AppLocalizations.of(Get.context).photoUploadLimitations);
      }
    }
    else{
      var i =0;
      var galleryFiles = await imagePicker.pickMultiImage();
      while(i<galleryFiles.length){
        File imageFile = File(galleryFiles[i].path);
        if(imageFiles.length<3)
        {
          imageFiles.add(imageFile) ;
        }
        else
        {
          Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).photoUploadLimitations.tr));
          throw new Exception(AppLocalizations.of(Get.context).photoUploadLimitations);
        }
        i++;
      }
    }
  }

  sendImages(int a, var imageFil, int id)async{

    //for(var b=0; b<luggageId.length;b++){
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverPort}/upload/m1st_hk_roadshipping.luggage/$id/luggage_image$a'));
    request.files.add(await http.MultipartFile.fromPath('ufile', imageFil.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print("Hello"+data.toString());
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).luggageUpdated.tr));
      Navigator.pop(Get.context);
      imageFiles.clear();
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
    //}
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }

  Future getRoadLuggageInfo(var ids) async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.luggage?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      shippingLoading.value = false;
      roadShippingLuggage.value = json.decode(data);
      luggageDto.value = json.decode(data)[0];
      print(roadShippingLuggage);

      List models = [];
      for(var i in luggageModels){
        for(var a in roadShippingLuggage){
          if(i['id'] == a["luggage_model_id"][0]){
            models.add(i);
          }
        }
      }
      luggageSelected.value = models;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getSpecificAirShippingLuggages(List luggageIds)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.luggage?ids=$luggageIds'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print('specific air shipping : ${json.decode(data)}');
      shippingLoading.value = false;
      airShippingLuggage.value = json.decode(data);
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }


  }


  Future getAllBeneficiaries(int id)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=dc69145b99f377c902d29e0b11e6ea9bb1a6a1ba'
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      var list= result[0]['receiver_partner_ids'];
      var listUser = await getUsersInAddressBook(list);
      print('Partner list'+listUser.toString());
      return listUser;

    }
    else {
      print(response.reasonPhrase);
    }
  }

  sendMessage(var shipping)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };

    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.travelmessage?values={'
        '"name": "${AppLocalizations.of(Get.context).hello} ${shipping['partner_id'][1]}, ${AppLocalizations.of(Get.context).messageFirstPriceProposition}",'
        '"sender_partner_id": ${Get.find<MyAuthService>().myUser.value.id},'
        '"receiver_partner_id": ${shipping['partner_id'][0]},'
        '"shipping_id": ${shipping['id']},'
        '"price": ${price.value}'
        '}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();

      Fluttertoast.showToast(
        msg: AppLocalizations.of(Get.context).messageSent,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: inactive,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(Get.context).redirecting),
        backgroundColor: validateColor,
        duration: Duration(seconds: 2),
      ));

      shippingAccept(shipping);
      print(data);
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
      print(json.decode(data)['message']);
    }
  }

  shippingAccept(var shipping)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={"msg_shipping_accepted": true}&ids=${shipping['id']}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Navigator.pop(Get.context);

      Get.toNamed(Routes.CHAT, arguments: {'shippingCard': shipping});
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
      print(json.decode(data)['message']);
    }
  }

  rejectRoadShipping(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m1st_hk_roadshipping.shipping/mark_traveler_disagree/?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();

      print(data);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "shipping rejected ".tr));
      Navigator.pop(Get.context);
      Get.find<TravelInspectController>().refreshPage();
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }
  }
  rejectAirShipping(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m2st_hk_airshipping.shipping/mark_traveler_disagree/?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();

      print(data);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "shipping rejected ".tr));
      Navigator.pop(Get.context);
      Get.find<TravelInspectController>().refreshPage();
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }
  }

  getUsersInAddressBook(List list)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=fb684dfb6b5282f2f26a5696dae345076e431019'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner?ids=$list'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      return result;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  searchUser(String query){
    if(query.isNotEmpty) {
      typing.value = true;
      List dummyListData = [];
      dummyListData = listUsers.where((element) => element['login']
          .toString().toLowerCase().contains(query.toLowerCase())).toList();
      if(dummyListData.isNotEmpty){
        userExist.value = true;
        viewUsers.value = dummyListData;
        print(userExist);
      }else{
        userExist.value = false;
        email.value = query;
        print(userExist);
      }
      return;
    }else{
      typing.value = false;
    }
  }

  selectCameraOrGalleryProfileImage()async{
    showDialog(
        context: Get.context,
        builder: (_){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
                height: 170,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      onTap: ()async{
                        await profileImagePicker('camera');
                        //Navigator.pop(Get.context);
                        loadProfileImage.value = !loadProfileImage.value;

                      },
                      leading: Icon(FontAwesomeIcons.camera),
                      title: Text(AppLocalizations.of(Get.context).takePicture, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    ),
                    ListTile(
                      onTap: ()async{
                        await profileImagePicker('gallery');
                        //Navigator.pop(Get.context);
                        loadProfileImage.value = !loadProfileImage.value;
                      },
                      leading: Icon(FontAwesomeIcons.image),
                      title: Text(AppLocalizations.of(Get.context).uploadImage, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    )
                  ],
                )
            ),
          );
        });
  }

  profileImagePicker(String source) async {
    if(source=='camera'){
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        profileImage = File(pickedImage.path);
        Navigator.of(Get.context).pop();
        //Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        //loadIdentityFile.value = !loadIdentityFile.value;//Navigator.of(Get.context).pop();
      }
    }
    else{
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        profileImage = File(pickedImage.path);
        Navigator.of(Get.context).pop();
        //await sendImages(id, identificationFile );
        //Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        //loadIdentityFile.value = !loadIdentityFile.value;
        //Navigator.of(Get.context).pop();
      }
    }
  }

  getAttachmentFiles()async{
    print('hello');
    var attachmentIds = await getUserAttachementIds();
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/ir.attachment?ids=$attachmentIds&fields=%5B%22attach_custom_type%22%2C%22name%22%2C%22duration_rest%22%2C%22validity%22%2C%22conformity%22%5D&with_context=%7B%7D&with_company=1'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      List data = json.decode(result);
      var attachmentFiles = data;
      for(var i = 0; i < attachmentFiles.length; i++){
        if(attachmentFiles[i]['conformity'] == true){
          Get.find<AddTravelController>().isIdentityFileConform.value = true;
        }else{
          if(attachmentFiles[i]['duration_rest'] > 0) {
            Get.find<AddTravelController>().isIdentityFileUnderAnalysis.value = true;
            print('trueueueueueueuueueu');
          }
          Get.find<AddTravelController>().isIdentityFileConform.value = false;
        }
      }
      print(data);
    }
    else {
      var result = await response.stream.bytesToString();
      print(result);
    }
  }

  getUserAttachementIds()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner?ids=${Get.find<MyAuthService>().myUser.value.id}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)[0];
      return data['partner_attachment_ids'];

    } else {
      print(response.stream.bytesToString());
      return [];

    }
  }

  joinShippingTravel(var shipping, int id)async{
    print('id is : ${id}');
    print(shipping['id']);

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };

    var request = http.Request('PUT',  Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={'
        '"travelbooking_id":$id}&ids=${shipping['id']}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      //await getShippingCreated(json.decode(data));

      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).shippingJoinedTravel.tr));
      Navigator.of(Get.context).pop();
      Navigator.of(Get.context).pop();
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }
  }



  Future<Uint8List> generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.robotoRegular();
    //final fontBold = await PdfGoogleFonts.robotoBold();
    final image = pw.MemoryImage(
      (await rootBundle.load('assets/img/hubcolis.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return pw.Column(
            children: [

              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [

                    pw.Flexible(
                      //flex: 6,
                        child: pw.SizedBox(
                          child: pw.Image(image),
                          width: 100,
                          height: 100,
                        )

                      //child: pw.SizedBox(width: MediaQuery.of(Get.context).size.width*0.9)
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(right: 50),
                      child: pw.Text(invoice[0]['partner_id'][1], style: pw.TextStyle(font: font, fontSize: 20)), )

                  ]),
              pw.SizedBox(height: 40),
              pw.Row(
                  children:[
                    pw.FittedBox(
                      child: pw.Text('${AppLocalizations.of(Get.context).invoice} ${invoice[0]['name']}', style: pw.TextStyle(font: font, fontSize: 30)),
                    ),

                  ]

              ),
              pw.SizedBox(height: 20),

              pw.Row(children: [
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(AppLocalizations.of(Get.context).invoiceDate, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20,)),
                      pw.Text(invoice[0]['date'], style: pw.TextStyle(font: font,fontSize: 20))
                    ]),
                pw.SizedBox(width: 20),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(AppLocalizations.of(Get.context).dueDate, style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                      pw.Text(invoice[0]['invoice_date_due'], style: pw.TextStyle(font: font,fontSize: 20))
                    ]),
                pw.SizedBox(width: 20),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(AppLocalizations.of(Get.context).invoiceSource, style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                      shippingDetails['booking_type']=='By Road'?pw.Text(invoice[0]['shipping_id'][1], style: pw.TextStyle(font: font,fontSize: 20)):
                      pw.Text(invoice[0]['air_shipping_id'][1], style: pw.TextStyle(font: font,fontSize: 20))
                    ])

              ]),

              pw.SizedBox(height: 50),
              pw.Row(children: [
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(AppLocalizations.of(Get.context).description, style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                      pw.Text(AppLocalizations.of(Get.context).hubkiloFees, style: pw.TextStyle(font: font,fontSize: 20))
                    ]),
                pw.SizedBox(width: 20),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(AppLocalizations.of(Get.context).quantity, style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                      pw.Text('1.00', style: pw.TextStyle(font: font,fontSize: 20))
                    ]),
                pw.SizedBox(width: 20),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(AppLocalizations.of(Get.context).unitPrice, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
                      pw.Text(invoice[0]['amount_untaxed'].toString(), style: pw.TextStyle(font: font,fontSize: 20))
                    ]),
                pw.SizedBox(width: 20),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(AppLocalizations.of(Get.context).taxes, style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                      pw.Text(invoice[0]['amount_tax_signed'].toString(), style: pw.TextStyle(font: font,fontSize: 20))
                    ]),
                pw.SizedBox(width: 20),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(AppLocalizations.of(Get.context).amount, style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                      pw.Text(invoice[0]['amount_untaxed'].toString(), style: pw.TextStyle(font: font,fontSize: 20))
                    ])

              ]),
              pw.SizedBox(height: 40),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.SizedBox(
                  width: 260,
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.SizedBox(width: 2),

                              pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(AppLocalizations.of(Get.context).untaxedAmount, style: pw.TextStyle(font: font, fontWeight:pw.FontWeight.bold, fontSize: 20)),
                                    pw.Text('TVA 20%:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                                  ]

                              ),
                              pw.SizedBox(
                                  width: 60
                              ),
                              pw.Column(
                                  children: [
                                    pw.Text(invoice[0]['amount_untaxed'].toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 25)),
                                    pw.Text(invoice[0]['amount_tax'].toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 25)),


                                  ]

                              ),
                            ]
                        ),
                        pw.Divider(),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Expanded(
                                child: pw.Text(AppLocalizations.of(Get.context).total, style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                              ),
                              pw.Text(invoice[0]['amount_total_in_currency_signed'].toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 25)),
                            ]

                        ),
                      ]
                  ),),
              ),

              pw.SizedBox(height: 60),

              pw.Text('${AppLocalizations.of(Get.context).paymentInstructionText}\n ${AppLocalizations.of(Get.context).invoice} ${invoice[0]['name']}', style: pw.TextStyle(font: font,fontSize: 20),),

              pw.SizedBox(height: 20),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('${AppLocalizations.of(Get.context).paymentTerms} ', style: pw.TextStyle(font: font,fontSize: 20)),
                    shippingDetails['booking_type']=='By Road'?pw.Text(invoice[0]['invoice_payment_term_id'][1], style: pw.TextStyle(font: font,fontSize: 20)):
                    pw.Text('', style: pw.TextStyle(font: font,fontSize: 20)),

                  ]
              ),
              //pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }


}
