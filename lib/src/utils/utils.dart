import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/providers/db_provider.dart';

import 'package:url_launcher/url_launcher.dart';

abrirScan(BuildContext context, ScanModel scan) async {

  if(scan.tipo == 'http') {
    if (await canLaunch(scan.valor)) {
      await launch(scan.valor);
    } else {
      throw 'Could not launch ${scan.valor}';
    }
  } else if(scan.tipo == 'geo') {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  } else {
    Navigator.pushNamed(context, 'other', arguments: {'rawText': scan.valor});
  }

  
}