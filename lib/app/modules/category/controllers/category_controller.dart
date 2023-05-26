import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repositories/e_service_repository.dart';

class CategoryController extends GetxController {
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  var travelList = [].obs;
  var list = [].obs;
  final imageUrl = "".obs;
  var travelType = "".obs;
  ScrollController scrollController = ScrollController();

  @override
  Future<void> onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    travelList.value = arguments['travels'];
    list.addAll(travelList);
    travelType.value = arguments['travelType'];
    print(travelList);
    if(travelList[0]['travel_type'].toLowerCase() == "air"){
      imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60";
    }else if(travelList[0]['travel_type'].toLowerCase() == "Sea"){
      travelList[0].value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=";
    }else{
      imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=";
    }
    await refreshEServices();
    super.onInit();
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = list;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['departure_town']
          .toString().toLowerCase().contains(query.toLowerCase()) || element['arrival_town']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      travelList.value = dummyListData;
      return;
    } else {
      travelList.value = list;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshEServices({bool showMessage}) async {

  }

  /*Future loadEServicesOfCategory(String categoryId, {CategoryFilter filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<EService> _eServices = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _eServices = await _eServiceRepository.getAllWithPagination(categoryId, page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _eServices = await _eServiceRepository.getFeatured(categoryId, page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _eServices = await _eServiceRepository.getPopular(categoryId, page: this.page.value);
          break;
        case CategoryFilter.RATING:
          _eServices = await _eServiceRepository.getMostRated(categoryId, page: this.page.value);
          break;
        case CategoryFilter.AVAILABILITY:
          _eServices = await _eServiceRepository.getAvailable(categoryId, page: this.page.value);
          break;
        default:
          _eServices = await _eServiceRepository.getAllWithPagination(categoryId, page: this.page.value);
      }
      if (_eServices.isNotEmpty) {
        //this.eServices.addAll(_eServices);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }*/
}
