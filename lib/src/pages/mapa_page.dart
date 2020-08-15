
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:qrreaderapp/src/providers/db_provider.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final MapController map = new MapController();

  String tipoMapa = 'streets-v11';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context, scan),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan)
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
        urlTemplate:'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: {
        'accessToken':'pk.eyJ1IjoibGFydHVyaSIsImEiOiJja2R3MHcybDgxNDB6MzNtY2t1Z2VmazVnIn0.XWEZ5hNaDg8Pdzg2kNvciQ',
        'id': 'mapbox/' + tipoMapa

        // mapbox://styles/mapbox/streets-v11
        // mapbox://styles/mapbox/outdoors-v11
        // mapbox://styles/mapbox/light-v10
        // mapbox://styles/mapbox/dark-v10
        // mapbox://styles/mapbox/satellite-v9
        // mapbox://styles/mapbox/satellite-streets-v11
    });
  }

  _crearMarcadores(ScanModel scan) {

    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 120.0,
          height: 120.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(Icons.location_on, size: 70.0, color: Theme.of(context).primaryColor,),
          )
        )
      ]
    );

  }

  Widget _crearBotonFlotante(BuildContext context, ScanModel scan) {

    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        if(tipoMapa == 'streets-v11') {
          tipoMapa = 'dark-v10';
        } else if(tipoMapa == 'dark-v10') {
          tipoMapa = 'light-v10';
        } else if(tipoMapa == 'light-v10') {
          tipoMapa = 'outdoors-v11';
        } else if(tipoMapa == 'outdoors-v11') {
          tipoMapa = 'satellite-v9';
        } else {
          tipoMapa = 'streets-v11';
        }

        setState(() {});

        map.move(scan.getLatLng(), 30);
 
        //Regreso al Zoom Deseado después de unos Milisegundos
        Future.delayed(Duration(milliseconds: 50),(){
          map.move(scan.getLatLng(), 15);
        });

      },
    );

  }

}