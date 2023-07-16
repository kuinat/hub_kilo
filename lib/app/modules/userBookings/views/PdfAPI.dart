import 'dart:io';
import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class PdfApi {

  static Future<Object> generateBillWithMeter(var invoice) async {
    final pdf = Document();
    PdfColor appColor = PdfColors.black;
    final font = await PdfGoogleFonts.nunitoExtraLight();
    print(invoice['name']);
    pdf.addPage(
        Page(
      pageFormat: PdfPageFormat.a4,
        build: (context) => Column(
          children: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.topRight,
              child: Text(invoice['partner_id'][1], style: TextStyle(font: font, color: appColor,fontSize: 12)),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Invoice "+invoice['name'], style: TextStyle(font: font,color: appColor, fontSize: 15)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: 'Invoice Date:', style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold)),
                          TextSpan(text: "\n"+ invoice['date'], style: TextStyle(font: font,color: appColor, fontSize: 12))
                        ]
                    )
                ),
                SizedBox(width: 20),
                RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: 'Due Date:', style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold)),
                          TextSpan(text: "\n"+ invoice['invoice_date_due'], style: TextStyle(font: font,color: appColor, fontSize: 12))
                        ]
                    )
                ),
                SizedBox(width: 20),
                RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: 'Source:', style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold)),
                          TextSpan(text: "\n"+ invoice['shipping_id'][1], style: TextStyle(font: font,color: appColor, fontSize: 12))
                        ]
                    )
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
              SizedBox(width: 50,
                child: Text("Description", style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold))),
              SizedBox(width: 50,
                child: Text("Quantity", style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold))),
              SizedBox(width: 50,
                child: Text("Unt Price", style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold))),
              SizedBox(width: 50,
                child: Text("Taxes:", style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold))),
              SizedBox(width: 50,
                child: Text("Amount", style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold)))
              ]
            ),
            Row(
                children: [
                  SizedBox(width: 50,
                      child: Text("HUBKILO FEES", style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold))),
                  SizedBox(width: 50,
                      child: Text("1.00", style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold))),
                  SizedBox(width: 50,
                      child: Text(invoice['amount_paid'].toString(), style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold))),
                  SizedBox(width: 50,
                      child: Text(invoice['amount_tax_signed'].toString(), style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold))),
                  SizedBox(width: 50,
                      child: Text(invoice['amount_total'].toString(), style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold)))
                ]
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Divider(color: appColor),
                      Row(
                        children: [
                          Expanded(
                              child: Text("Untaxed Amount", style: TextStyle(font: font,color: appColor, fontSize: 15))),
                          Text(invoice['amount_untaxed'].toString())
                        ],
                      ),
                      Divider(color: appColor),
                      Row(
                        children: [
                          Expanded(
                              child: Text("TVA 20%", style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold))),
                          Text("0.0")
                        ],
                      ),
                      Divider(color: appColor),
                      Row(
                        children: [
                          Expanded(
                              child: Text("Total", style: TextStyle(font: font,color: appColor, fontSize: 15, fontWeight: FontWeight.bold))),
                          Text(invoice['amount_total_in_currency_signed'].toString(), style: TextStyle(font: font,color: appColor))
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
                      TextSpan(text: 'Please use the following communication for your payment: ', style: TextStyle(font: font,color: appColor, fontSize: 12)),
                      TextSpan(text: invoice['name'], style: TextStyle(font: font,color: appColor, fontSize: 13, fontWeight: FontWeight.bold))
                    ]
                )
            ),
            Text("Payment terms: ${invoice['invoice_payment_term_id'][1]}", style: TextStyle(font: font,color: appColor, fontSize: 12, fontWeight: FontWeight.bold))
          ],
        )
    ));
    //return PdfFileCache();
    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    String name,
    Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}

class PdfFileCache extends PdfBaseCache {
  PdfFileCache({
    String base,
  }) : base = base ?? '.';

  final String base;

  @override
  Future<void> add(String key, Uint8List bytes) async {
    await File('$base/$key').writeAsBytes(bytes);
  }

  @override
  Future<Uint8List> get(String key) async {
    return await File('$base/$key').readAsBytes();
  }

  @override
  Future<void> clear() async {}

  @override
  Future<bool> contains(String key) async {
    return File('$base/$key').existsSync();
  }

  @override
  Future<void> remove(String key) async {
    File('$base/$key').deleteSync();
  }
}