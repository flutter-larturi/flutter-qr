import "package:latlong/latlong.dart";

class ScanModel {
    
    int id;
    String tipo;
    String valor;

    ScanModel({
        this.id,
        this.tipo,
        this.valor,
    }){
      if (valor.contains('http')) {
        this.tipo = 'http';
      } else if (valor.contains('geo:')) {
        this.tipo = 'geo';
      } else {
        this.tipo = 'other';
      }
    }

    factory ScanModel.fromJson(Map<String, dynamic> json) => new ScanModel(
        id    : json["id"],
        tipo  : json["tipo"],
        valor : json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id"   : id,
        "tipo" : tipo,
        "valor": valor,
    };

    LatLng getLatLng() {

      double lat = 0;
      double lng = 0;
      final latlong = valor.substring(4).split(',');

      lat = double.parse(latlong[0]);
      lng = double.parse(latlong[1]);
      
      
      return LatLng(lat, lng);

    }

}
