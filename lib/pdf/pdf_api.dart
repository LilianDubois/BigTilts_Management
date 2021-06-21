// ignore: avoid_web_libraries_in_flutter
import 'dart:io';

import 'package:universal_html/html.dart' as http;

import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PdfApi {
  var bytes;
  var blob;
  static Future<File> generateCenteredText(
      var uid,
      var nomclient,
      var chassit,
      var materiaux,
      var plancher,
      var deco,
      var taille,
      var tapis,
      var subTapis,
      var packMarteting,
      var transport,
      var dateExp,
      var videoProj,
      var typeVideoProj,
      var infos) async {
    final pdf = pw.Document();
    String pack = 'Non';
    String video = 'Non';

    if (packMarteting) pack = 'Oui';
    if (videoProj) video = 'Oui';
    pdf.addPage(pw.MultiPage(
        build: (context) => <pw.Widget>[
              buildCustomHeader(
                  'Fiche des spécifications de la BigTilt N°$uid'),
              pw.SizedBox(height: 30),
              pw.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Element', 'Valeur'],
                <String>['Nom du client', '$nomclient'],
                <String>['Numéro', '$uid'],
                <String>['Type de chassit', '$chassit'],
                <String>['Materiaux modules', '$materiaux'],
                <String>['Plancher', '$plancher'],
                <String>['Decoration des modules', '$deco'],
                <String>['Vidéo projecteur', '$video'],
                <String>['Type de video projecteur', '$typeVideoProj'],
                <String>['Taille', '$taille'],
                <String>['Tapis', '$tapis'],
                <String>['Type de tapis', '$subTapis'],
                <String>['Pack Marketing', '$pack'],
                <String>['Transport', '$transport'],
                <String>['Date d\'expédition', '$dateExp'],
                <String>['Infos complémentaires', '$infos'],
              ]),
            ],
        footer: (context) {
          return pw.Align(
              alignment: pw.Alignment.bottomRight,
              child: pw.Text(
                  'Fiche générée automatiquement depuis l\'application Bigtilts Management'));
        }));
    return saveDocument(name: 'BigTilt-$uid-specs.pdf', pdf: pdf);
  }

  static pw.Widget buildCustomHeader(String tilte) => pw.Header(
        child: pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              tilte,
              style: pw.TextStyle(
                color: PdfColors.orange,
                fontSize: 20,
              ),
              textAlign: pw.TextAlign.center,
            )),
      );

  static Future<File> saveDocument({
    String name,
    pw.Document pdf,
  }) async {
    final bytes = await pdf.save();
    final blob = http.Blob([bytes], 'application/pdf');
    if (kIsWeb) {
      final url = http.Url.createObjectUrlFromBlob(blob);
      http.window.open(url, '_blank');
      http.Url.revokeObjectUrl(url);
    }

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
