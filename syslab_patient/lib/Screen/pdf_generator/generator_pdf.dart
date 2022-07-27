import 'dart:io';
import 'package:patient/Screen/pdf_generator/pdf_save.dart';
import 'package:patient/model/admin_result.dart';
import 'package:patient/model/patient_result.dart';
import 'package:patient/model/results.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfResultGenerator {
  static Future<File> generate(Results results) async {

    final pdf = Document();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(results),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(results),
      ],
      footer: (context) => buildFooter(results),
    )
    );

    return PdfApi.saveDocument(name: 'my_results.pdf', pdf: pdf);
  }

  static Widget buildHeader(Results results) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildAdminResAddress(results.adminRes),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: "results.info.number",
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildPatientResAddress(results.patientRes),
              // buildResultsInfo(results.info),
            ],
          ),
        ],
      );

  static Widget buildPatientResAddress(PatientRes patientRes) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(patientRes.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(patientRes.address),
        ],
      );

  static Widget buildResultsInfo(ResultsInfo info) {
    // final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Results Number:',
      'Results Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      // Utils.formatDate(info.date),
      // paymentTerms,
      // Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildAdminResAddress(AdminRes adminRes) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(adminRes.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(adminRes.address),
        ],
      );

  static Widget buildTitle(Results results) => Column(
    
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Results',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Divider(),
          SizedBox(height: .8 * PdfPageFormat.cm),
          Text(results.info.description),
        ],
      );

  static Widget buildFooter(Results results) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: results.adminRes.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Email', value: results.adminRes.email),
        ],
      );

  static buildSimpleText({
    String title,
    String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);
    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text("value", style: unite ? style : null),
        ],
      ),
    );
  }
}
