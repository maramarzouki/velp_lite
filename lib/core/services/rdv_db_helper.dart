import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/features/rdv/data/model/rdv_model.dart';
import 'package:velp_lite/core/services/database_helper.dart';

final rdvDbHelperProvider = Provider<RdvDbHelper>(
  (ref) => RdvDbHelper.instance,
);

class RdvDbHelper {
  static final RdvDbHelper instance = RdvDbHelper._init();
  RdvDbHelper._init();

  Future<RdvModel> createRdv(RdvModel rdv) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert('rdvs', rdv.toMap());
    rdv.id = id;
    return rdv;
  }

  Future<List<RdvModel>> getRdvs() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('rdvs');
    return maps.map((m) => RdvModel.fromMap(m)).toList();
  }

  Future<List<RdvModel>> getRdvByAnimalId(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('rdvs', where: 'animal_id = ?', whereArgs: [id]);

    return maps.map((m) => RdvModel.fromMap(m)).toList();
  }

  Future<int> updateRdv(RdvModel rdv) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'rdvs',
      rdv.toMap(),
      where: 'id = ?',
      whereArgs: [rdv.id],
    );
  }

  Future<int> deleteRdv(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete('rdvs', where: 'id = ?', whereArgs: [id]);
  }
}
