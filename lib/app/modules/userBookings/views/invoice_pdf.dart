import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import '../controllers/bookings_controller.dart';

class InvoicePdf extends GetView<BookingsController> {

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BookingsController());

    return PdfPreview(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
      build: (format) => controller.generatePdf(format,' title'),
    );
  }
}