import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if(_database != null) return _database;

    _database = await initDB();

    return _database;

  }

  // Crear la base y las tablas
  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE SCANS ('
          'id INTEGER PRIMARY KEY, '
          'tipo TEXT, '
          'valor TEXT'
          ')'
        );
      }
    );

  }

  // INSERT
  // Metodo de insert con query
  nuevoScanRaw(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.rawInsert(
      "INSERT INTO SCANS(id, tipo, valor) "
      "VALUES( ${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}' )"
    );

    return res;
  }

  // Metodo de insert recomendado
  nuevoScan(ScanModel nuevoScan) async {
    final db  = await database;
    final res = await db.insert('SCANS', nuevoScan.toJson());
    return res;
  }

  // SELECT
  Future<ScanModel> getScanId(int id) async {
    final db  = await database;
    final res = await db.query('SCANS', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db  = await database;
    final res = await db.query('SCANS');

    List<ScanModel> list = res.isNotEmpty
          ? res.map( (c) => ScanModel.fromJson(c) ).toList()
          : [];

    return list;
  }

  Future<List<ScanModel>> getAllScansByTipo(String tipo) async {
    final db  = await database;
    final res = await db.rawQuery("SELECT * FROM SCANS WHERE tipo = '$tipo'");

    List<ScanModel> list = res.isNotEmpty
          ? res.map( (c) => ScanModel.fromJson(c) ).toList()
          : [];

    return list;
  }

  // UPDATE
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db  = await database;
    final res = await db.update('SCANS', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);
    return res;
  }

  // DELETE
  Future<int> deleteScan(int id) async {
    final db  = await database;
    final res = await db.delete('SCANS', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db  = await database;
    final res = await db.rawDelete("DELETE FROM SCANS");
    return res;
  }


}