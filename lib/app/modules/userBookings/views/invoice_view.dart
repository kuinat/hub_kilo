import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../global_widgets/bannerWidget.dart';
import '../../global_widgets/loading_cards.dart';
import '../controllers/bookings_controller.dart';
import 'PdfAPI.dart';

class InvoiceView extends GetView<BookingsController> {

  @override
  Widget build(BuildContext context) {

    Get.lazyPut(()=>BookingsController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Invoice".tr,
          style: Get.textTheme.headline6.merge(TextStyle(color: interfaceColor)),
        ),
        centerTitle: true,
        backgroundColor: background,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () async {

          },
          child: Obx(
                () {
                  if(controller.invoiceLoading.value){
                    Expanded(child: LoadingCardWidget());
                  }{
                    if (controller.invoiceList.isNotEmpty) {
                      var _invoice = controller.invoiceList;
                      return ListView.builder(
                          itemCount: _invoice.length,
                          itemBuilder: (context, index){
                            return ClipRRect(
                              child: Card(
                                color: Colors.white,
                                margin: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Banner(
                                    message: _invoice[index]['payment_state'],
                                    location: BannerLocation.topEnd,
                                    //textStyle: Get.textTheme.headline1.merge(TextStyle(color: Colors.white)),
                                    color: _invoice[index]['payment_state'] == 'paid' ? validateColor : inactive,
                                    child:Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text("Reference: ", style: Get.textTheme.headline4.merge(TextStyle(color: appColor))),
                                              Text(_invoice[index]['name'], style: Get.textTheme.headline4.merge(TextStyle(color: appColor, fontWeight: FontWeight.bold)),),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text('Date:', style: Get.textTheme.headline1.
                                                merge(TextStyle(color: appColor, fontSize: 12))),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: 12),
                                                width: 1,
                                                height: 24,
                                                color: Get.theme.focusColor.withOpacity(0.3),
                                              ),
                                              SizedBox(
                                                width: 130,
                                                child: Text(
                                                  _invoice[index]['date'], style: Get.textTheme.headline1.
                                                merge(TextStyle(color: appColor, fontSize: 12)),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text('Invoice origin:', style: Get.textTheme.headline1.
                                                merge(TextStyle(color: appColor, fontSize: 12))),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: 12),
                                                width: 1,
                                                height: 24,
                                                color: Get.theme.focusColor.withOpacity(0.3),
                                              ),
                                              SizedBox(
                                                width: 130,
                                                child: Text(
                                                  _invoice[index]['invoice_origin'], style: Get.textTheme.headline1.
                                                merge(TextStyle(color: appColor, fontSize: 12)),
                                                ),
                                              )
                                            ],
                                          ),
                                          ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: pendingStatus,
                                              ),
                                              onPressed: ()=>{
                                                showDialog(
                                                    context: context,
                                                    builder: (_){
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Material(
                                                              child: Row(
                                                                  children: [
                                                                    ElevatedButton.icon(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: interfaceColor
                                                                        ),
                                                                        onPressed: ()async{
                                                                          final pdfFile =
                                                                          await PdfApi.generateBillWithMeter(_invoice[index]);

                                                                          PdfApi.openFile(pdfFile);
                                                                        },
                                                                        label: Text("Download"),
                                                                        icon: Icon(Icons.download, size: 20)
                                                                    ),
                                                                    Spacer(),
                                                                    IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close, size: 20))
                                                                  ]
                                                              )
                                                          ),
                                                          Container(
                                                            color: Colors.white,
                                                            height: Get.height/1.5,
                                                            width: Get.width,
                                                            padding: EdgeInsets.all(10),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(height: 10),
                                                                Align(
                                                                  alignment: Alignment.topRight,
                                                                  child: Text(_invoice[index]['partner_id'][1], style: Get.textTheme.headline1.
                                                                  merge(TextStyle(color: appColor, fontSize: 12))),
                                                                ),
                                                                SizedBox(height: 10),
                                                                Align(
                                                                  alignment: Alignment.topLeft,
                                                                  child: Text("Invoice "+_invoice[index]['name'], style: Get.textTheme.headline1.
                                                                  merge(TextStyle(color: appColor, fontSize: 15))),
                                                                ),
                                                                SizedBox(height: 20),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    RichText(
                                                                        text: TextSpan(
                                                                            children: [
                                                                              TextSpan(text: 'Invoice Date:', style: Get.textTheme.headline1.
                                                                              merge(TextStyle(color: appColor, fontSize: 12, fontWeight: FontWeight.bold))),
                                                                              TextSpan(text: "\n"+ _invoice[index]['date'], style: Get.textTheme.headline1.
                                                                              merge(TextStyle(color: appColor, fontSize: 12)))
                                                                            ]
                                                                        )
                                                                    ),
                                                                    SizedBox(width: 20),
                                                                    RichText(
                                                                        text: TextSpan(
                                                                            children: [
                                                                              TextSpan(text: 'Due Date:', style: Get.textTheme.headline1.
                                                                              merge(TextStyle(color: appColor, fontSize: 12, fontWeight: FontWeight.bold))),
                                                                              TextSpan(text: "\n"+ _invoice[index]['invoice_date_due'], style: Get.textTheme.headline1.
                                                                              merge(TextStyle(color: appColor, fontSize: 12)))
                                                                            ]
                                                                        )
                                                                    ),
                                                                    SizedBox(width: 20),
                                                                    RichText(
                                                                        text: TextSpan(
                                                                            children: [
                                                                              TextSpan(text: 'Source:', style: Get.textTheme.headline1.
                                                                              merge(TextStyle(color: appColor, fontSize: 12, fontWeight: FontWeight.bold))),
                                                                              TextSpan(text: "\n"+ _invoice[index]['shipping_id'][1], style: Get.textTheme.headline1.
                                                                              merge(TextStyle(color: appColor, fontSize: 12)))
                                                                            ]
                                                                        )
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Divider(),
                                                                SizedBox(height: 10),
                                                                Material(
                                                                    child: Container(
                                                                        height: 100,
                                                                        width: double.infinity,
                                                                        child: Column(
                                                                          children: [
                                                                            Expanded(
                                                                                child: DataTable2(
                                                                                  columnSpacing: defaultPadding,
                                                                                  minWidth: 300,
                                                                                  dataRowHeight: 50,
                                                                                  showCheckboxColumn: false,
                                                                                  columns: [
                                                                                    DataColumn(label: Text("Description", style: Get.textTheme.headline1.
                                                                                    merge(TextStyle(color: appColor, fontSize: 12, fontWeight: FontWeight.bold)))),
                                                                                    DataColumn(label: Text("Quantity", style: Get.textTheme.headline1.
                                                                                    merge(TextStyle(color: appColor, fontSize: 12, fontWeight: FontWeight.bold)))),
                                                                                    DataColumn(label: Text("Unt Price", style: Get.textTheme.headline1.
                                                                                    merge(TextStyle(color: appColor, fontSize: 12, fontWeight: FontWeight.bold)))),
                                                                                    DataColumn(label: Text("Taxes:", style: Get.textTheme.headline1.
                                                                                    merge(TextStyle(color: appColor, fontSize: 12, fontWeight: FontWeight.bold)))),
                                                                                    DataColumn(label: Text("Amount", style: Get.textTheme.headline1.
                                                                                    merge(TextStyle(color: appColor, fontSize: 12, fontWeight: FontWeight.bold))))
                                                                                  ],
                                                                                  rows: List.generate(1,
                                                                                          (index) => DataRow(
                                                                                        onSelectChanged: (_){},
                                                                                        cells: [
                                                                                          DataCell(Text("HUBKILO FEES", style: Get.textTheme.headline4.
                                                                                          merge(TextStyle(color: appColor, fontSize: 12)))),
                                                                                          DataCell(Text("1.00",overflow: TextOverflow.ellipsis, style: Get.textTheme.headline4.
                                                                                          merge(TextStyle(color: appColor, fontSize: 12)))),
                                                                                          DataCell(Text(_invoice[index]['amount_paid'].toString(), style: Get.textTheme.headline4.
                                                                                          merge(TextStyle(color: appColor, fontSize: 12)))),
                                                                                          DataCell(Text(_invoice[index]['amount_tax_signed'].toString(), style: Get.textTheme.headline4.
                                                                                          merge(TextStyle(color: appColor, fontSize: 12)))),
                                                                                          DataCell(Text(_invoice[index]['amount_total'].toString(), style: Get.textTheme.headline4.
                                                                                          merge(TextStyle(color: appColor, fontSize: 12))))
                                                                                        ],
                                                                                      )
                                                                                  ),
                                                                                )
                                                                            )
                                                                          ],
                                                                        )
                                                                    )
                                                                ),
                                                                Align(
                                                                  alignment: Alignment.bottomRight,
                                                                  child: SizedBox(
                                                                      width: Get.width/2,
                                                                      child: Column(
                                                                        children: [
                                                                          SizedBox(height: 10),
                                                                          Divider(color: Colors.black),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: Text("Untaxed Amount", style: Get.textTheme.headline1.
                                                                                  merge(TextStyle(color: appColor, fontSize: 15)))),
                                                                              Text(_invoice[index]['amount_untaxed'].toString())
                                                                            ],
                                                                          ),
                                                                          Divider(color: background),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: Text("TVA 20%", style: Get.textTheme.headline1.
                                                                                  merge(TextStyle(color: appColor, fontSize: 15, fontWeight: FontWeight.bold)))),
                                                                              Text("0.0")
                                                                            ],
                                                                          ),
                                                                          Divider(color: Colors.black),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: Text("Total", style: Get.textTheme.headline1.
                                                                                  merge(TextStyle(color: appColor, fontSize: 15, fontWeight: FontWeight.bold)))),
                                                                              Text(_invoice[index]['amount_total_in_currency_signed'].toString())
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                          TextSpan(text: 'Please use the following communication for your payment: ', style: Get.textTheme.headline1.
                                                                          merge(TextStyle(color: appColor, fontSize: 12))),
                                                                          TextSpan(text: _invoice[index]['name'], style: Get.textTheme.headline1.
                                                                          merge(TextStyle(color: appColor, fontSize: 13, fontWeight: FontWeight.bold)))
                                                                        ]
                                                                    )
                                                                ),
                                                                Text("Payment terms: ${_invoice[index]['invoice_payment_term_id'][1]}", style: Get.textTheme.headline1.
                                                                merge(TextStyle(color: appColor, fontSize: 12, fontWeight: FontWeight.bold)))
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    })
                                              },
                                              icon: Icon(Icons.remove_red_eye),
                                              label: Text('Preview')
                                          )
                                        ],
                                      ),
                                    )

                                ),
                              )
                            );
                          }
                      );
                    } else {
                      return SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height/4),
                            FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                            Text('No Shipping found', style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3)))),
                          ],
                        ),
                      );
                    }
                  }
            },
          )),
    );
  }
}
