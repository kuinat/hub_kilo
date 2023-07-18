import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../controllers/bookings_controller.dart';

class InvoiceView extends GetView<BookingsController> {

  @override
  Widget build(BuildContext context) {
    var _invoice = {};
    Get.lazyPut(()=>BookingsController());
    _invoice = controller.invoice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          child: Banner(
            message: _invoice['payment_state'],
            color: _invoice['payment_state'] == "not_paid" ? inactive : validateColor,
            location: BannerLocation.topEnd,
          child: Column(
            children: [
              Material(
                  child: Row(
                      children: [
                        IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close, size: 20)),
                        SizedBox(width: 10),
                        if(_invoice['payment_state'] == "not_paid")
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: validateColor
                          ),
                          onPressed: ()async{
                            controller.confirmPayment(_invoice['id']);
                          },
                          child: Text("Pay now"),
                        ),
                        if(_invoice['payment_state'] == "not_paid")
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: interfaceColor
                            ),
                            onPressed: ()async{

                            },
                            label: Text("Download"),
                            icon: Icon(Icons.download, size: 20)
                        ),
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
                      child: Text(_invoice['partner_id'][1], style: Get.textTheme.headline1.
                      merge(TextStyle(color: appColor, fontSize: 12))),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Invoice "+_invoice['name'], style: Get.textTheme.headline1.
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
                                  TextSpan(text: "\n"+ _invoice['date'], style: Get.textTheme.headline1.
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
                                  TextSpan(text: "\n"+ _invoice['invoice_date_due'], style: Get.textTheme.headline1.
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
                                  TextSpan(text: "\n"+ _invoice['shipping_id'][1], style: Get.textTheme.headline1.
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
                                              DataCell(Text(_invoice['amount_paid'].toString(), style: Get.textTheme.headline4.
                                              merge(TextStyle(color: appColor, fontSize: 12)))),
                                              DataCell(Text(_invoice['amount_tax_signed'].toString(), style: Get.textTheme.headline4.
                                              merge(TextStyle(color: appColor, fontSize: 12)))),
                                              DataCell(Text(_invoice['amount_total'].toString(), style: Get.textTheme.headline4.
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
                                  Text(_invoice['amount_untaxed'].toString(), style: Get.textTheme.headline1.
                                  merge(TextStyle(color: appColor, fontSize: 17, fontWeight: FontWeight.bold)))
                                ],
                              ),
                              Divider(color: background),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("TVA 20%", style: Get.textTheme.headline1.
                                      merge(TextStyle(color: appColor, fontSize: 15, fontWeight: FontWeight.bold)))),
                                  Text("0.0", style: Get.textTheme.headline1.
                                  merge(TextStyle(color: appColor, fontSize: 17, fontWeight: FontWeight.bold)))
                                ],
                              ),
                              Divider(color: Colors.black),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Total", style: Get.textTheme.headline1.
                                      merge(TextStyle(color: appColor, fontSize: 15, fontWeight: FontWeight.bold)))),
                                  Text(_invoice['amount_total_in_currency_signed'].toString(), style: Get.textTheme.headline1.
                                  merge(TextStyle(color: appColor, fontSize: 17, fontWeight: FontWeight.bold)))
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
                              TextSpan(text: _invoice['name'], style: Get.textTheme.headline1.
                              merge(TextStyle(color: appColor, fontSize: 13, fontWeight: FontWeight.bold)))
                            ]
                        )
                    ),
                    Text("Payment terms: ${_invoice['invoice_payment_term_id'][1]}", style: Get.textTheme.headline1.
                    merge(TextStyle(color: appColor, fontSize: 12, fontWeight: FontWeight.bold)))
                  ],
                ),
              )
            ],
          )
          ),
        )
      ],
    );
  }
}
