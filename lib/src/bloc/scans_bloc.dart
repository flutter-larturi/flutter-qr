import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc extends Validator {

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    // Obtener scans de la BD
    obtenerScans();

  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  // Stream de GeoLocation
  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validatorGeo);
  // Stream de Urls
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validatorHttp);

  dispose() {
    _scansController?.close();
  }

  obtenerScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  agregarScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarAllScans() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }

}