import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';

import 'package:barcode_scan/barcode_scan.dart';

import 'package:qrreaderapp/src/pages/mapas_page.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {},
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottonNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: _scanQR,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR() async {

    //https://www.leandroarturi.com.ar/
    //geo:40.6680082686587,-73.94002333125003

    String futureString = 'https://www.leandroarturi.com.ar/';

    // dynamic futureString ='';
    // try {
    //   futureString = await BarcodeScanner.scan();
    // } catch(e) {
    //   futureString=e.toString();
    // }

    if (futureString != null) {
      final scan = new ScanModel(valor: futureString);
      DBProvider.db.nuevoScan(scan);
    }

  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0: return MapasPage();
      case 1: return DireccionesPage();
      default: return MapasPage();
    }
  }

  Widget _crearBottonNavigationBar() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),
      ]
    );

  }
}