import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../controllers/bookings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvoiceView extends GetView<BookingsController> {

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BookingsController());
    var _invoice = controller.invoice[0];

    print("Invoice: ${_invoice['shipping_id']}");
    print("Invoice: ${_invoice['air_shipping_id']}");
    print("Invoice: ${controller.shippingDetails['booking_type']}");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          child: Banner(
              message: _invoice['payment_state'],
              color: _invoice['payment_state'] == "not_paid"
                  ? inactive
                  : validateColor,
              location: BannerLocation.topEnd,
              child: Column(
                children: [
                  Material(
                      child: Row(
                          children: [
                            IconButton(onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.close, size: 20)),
                            SizedBox(width: 10),
                            if(_invoice['payment_state'] == "not_paid")
                              ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: validateColor
                                  ),
                                  onPressed: () => controller.launchURL(controller.paymentLink.value),
                                  label: Text(AppLocalizations.of(context).payNow),
                                  icon: Icon(Icons.attach_money, size: 20)
                              ),
                            SizedBox(width: 10),
                            if(_invoice['payment_state'] == "paid")
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: interfaceColor
                                ),
                                onPressed: () async {
                                  Get.toNamed(Routes.INVOICE_PDF);
                                },
                                label: Text(AppLocalizations.of(context).download),
                                icon: Icon(Icons.download, size: 20)
                            ),
                          ]
                      )
                  ),
                  Container(
                    color: Colors.white,
                    height: Get.height / 1.3,
                    width: Get.width,
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Image.asset("assets/img/hubcolis.png",
                                  width: 70,
                                  height: 70,
                                )
                              //child: pw.SizedBox(width: MediaQuery.of(Get.context).size.width*0.9)
                            ),
                            Spacer(),
                            Text(_invoice['partner_id'][1],
                                style: Get.textTheme.headline1.
                                merge(TextStyle(color: appColor, fontSize: 12))),
                          ]
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Ticket: ' + _invoice['name'],
                              style: Get.textTheme.headline1.
                              merge(TextStyle(color: appColor, fontSize: 15))),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(text: AppLocalizations.of(context).invoiceDate +"\n",
                                          style: Get.textTheme.headline1.
                                          merge(TextStyle(color: appColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                      TextSpan(text: _invoice['date'],
                                          style: Get.textTheme.headline1.
                                          merge(TextStyle(
                                              color: appColor, fontSize: 12)))
                                    ]
                                )
                            ),
                            SizedBox(width: 20),
                            RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(text: AppLocalizations.of(context).dueDate+"\n",
                                          style: Get.textTheme.headline1.
                                          merge(TextStyle(color: appColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                      TextSpan(text:
                                          _invoice['invoice_date_due'],
                                          style: Get.textTheme.headline1.
                                          merge(TextStyle(
                                              color: appColor, fontSize: 12)))
                                    ]
                                )
                            ),
                            SizedBox(width: 20),
                            RichText(
                                text: TextSpan(
                                  style: TextStyle(overflow: TextOverflow.ellipsis),
                                    children: [
                                      TextSpan(text: AppLocalizations.of(context).invoiceSource +"\n",
                                          style: Get.textTheme.headline1.
                                          merge(TextStyle(color: appColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                      TextSpan(text:
                                          (controller.shippingDetails['booking_type']=='By Road' || controller.shippingDetails['booking_type'] == null || controller.shippingDetails['booking_type'] == '')?
                                          _invoice['shipping_id'][1]:_invoice['air_shipping_id'][1],
                                          style: Get.textTheme.headline1.
                                          merge(TextStyle(
                                              color: appColor, fontSize: 12, overflow: TextOverflow.ellipsis), ))
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
                                            DataColumn(label: Text(
                                                AppLocalizations.of(context).description,
                                                style: Get.textTheme.headline1.
                                                merge(TextStyle(color: appColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight
                                                        .bold)))),
                                            DataColumn(label: Text(AppLocalizations.of(context).quantity,
                                                style: Get.textTheme.headline1.
                                                merge(TextStyle(color: appColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight
                                                        .bold)))),
                                            DataColumn(label: Text(AppLocalizations.of(context).unitPrice,
                                                style: Get.textTheme.headline1.
                                                merge(TextStyle(color: appColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight
                                                        .bold)))),
                                            DataColumn(label: Text(AppLocalizations.of(context).taxes,
                                                style: Get.textTheme.headline1.
                                                merge(TextStyle(color: appColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight
                                                        .bold)))),
                                            DataColumn(label: Text(AppLocalizations.of(context).amount,
                                                style: Get.textTheme.headline1.
                                                merge(TextStyle(color: appColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight
                                                        .bold)))),
                                            DataColumn(label: Text('Admin fee',
                                                style: Get.textTheme.headline1.
                                                merge(TextStyle(color: appColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight
                                                        .bold))))
                                          ],
                                          rows: List.generate(1,
                                                  (index) =>
                                                  DataRow(
                                                    onSelectChanged: (_) {},
                                                    cells: [
                                                      DataCell(Text(
                                                          AppLocalizations.of(context).hubkiloFees,
                                                          style: Get.textTheme
                                                              .headline4.
                                                          merge(TextStyle(
                                                              color: appColor,
                                                              fontSize: 12)))),
                                                      DataCell(Text("1.00",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: Get.textTheme
                                                              .headline4.
                                                          merge(TextStyle(
                                                              color: appColor,
                                                              fontSize: 12)))),
                                                      DataCell(Text(
                                                          _invoice['amount_untaxed']
                                                              .toString(),
                                                          style: Get.textTheme
                                                              .headline4.
                                                          merge(TextStyle(
                                                              color: appColor,
                                                              fontSize: 12)))),
                                                      DataCell(Text(
                                                          _invoice['amount_tax_signed']
                                                              .toString(),
                                                          style: Get.textTheme
                                                              .headline4.
                                                          merge(TextStyle(
                                                              color: appColor,
                                                              fontSize: 12)))),
                                                      DataCell(Text(
                                                          _invoice['amount_untaxed']
                                                              .toString(),
                                                          style: Get.textTheme
                                                              .headline4.
                                                          merge(TextStyle(
                                                              color: appColor,
                                                              fontSize: 12)))),
                                                      DataCell(Text(
                                                          ((_invoice['amount_untaxed']/1+Domain.adminFee)*Domain.adminFee)
                                                              .toString(),
                                                          style: Get.textTheme
                                                              .headline4.
                                                          merge(TextStyle(
                                                              color: appColor,
                                                              fontSize: 12))))
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
                              width: Get.width / 2,
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Divider(color: Colors.black),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text('Administrative fee',
                                              style: Get.textTheme.headline1.
                                              merge(TextStyle(color: appColor,
                                                  fontSize: 15)))),
                                      Text(
                                          ((_invoice['amount_untaxed']/1+Domain.adminFee)*Domain.adminFee).toStringAsFixed(2).toString(),
                                          style: Get.textTheme.headline1.
                                          merge(TextStyle(color: appColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(AppLocalizations.of(context).untaxedAmount,
                                              style: Get.textTheme.headline1.
                                              merge(TextStyle(color: appColor,
                                                  fontSize: 15)))),
                                      Text(
                                          _invoice['amount_untaxed'].toString(),
                                          style: Get.textTheme.headline1.
                                          merge(TextStyle(color: appColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)))
                                    ],
                                  ),
                                  Divider(color: background),
                                  Row(
                                      children: [
                                        Expanded(
                                            child: Text("TVA 20%",
                                                style: Get.textTheme.headline1.
                                                merge(TextStyle(color: appColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight
                                                        .bold)))),
                                        Text(_invoice['amount_tax'].toString(),
                                            style: Get.textTheme.headline1.
                                            merge(TextStyle(color: appColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold)))
                                      ]
                                  ),
                                  Divider(color: Colors.black),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(AppLocalizations.of(context).total,
                                              style: Get.textTheme.headline1.
                                              merge(TextStyle(color: appColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight
                                                      .bold)))),
                                      Text(
                                          _invoice['amount_total_in_currency_signed']
                                              .toString(),
                                          style: Get.textTheme.headline1.
                                          merge(TextStyle(color: appColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)))
                                    ],
                                  )
                                ],
                              )
                          ),
                        ),
                        RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: AppLocalizations.of(context).paymentInstructionText,
                                      style: Get.textTheme.headline1.
                                      merge(TextStyle(
                                          color: appColor, fontSize: 12))),
                                  TextSpan(text: _invoice['name'],
                                      style: Get.textTheme.headline1.
                                      merge(TextStyle(color: appColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)))
                                ]
                            )
                        ),
                        controller.shippingDetails['booking_type']=='By Road'?
                        Text(
                            _invoice['invoice_payment_term_id'] != false?"${AppLocalizations.of(context).paymentTerms} ${_invoice['invoice_payment_term_id'][1]}": "None",
                            style: Get.textTheme.headline1.
                            merge(TextStyle(color: appColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold))):Text('')
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
