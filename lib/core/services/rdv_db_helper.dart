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
    try {
      final id = await db.insert('rdvs', rdv.toMap());
      rdv.id = id;
      return rdv;
    } catch (e) {
      throw Exception('Failed to create rdv: $e');
    }
  }

  Future<List<RdvModel>> getRdvs(int petId) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('rdvs', where: 'animal_id = ?', whereArgs: [petId]);
      return maps.map((m) => RdvModel.fromMap(m)).toList();
    } catch (e) {
      throw Exception('Failed to get rdvs: $e');
    }
  }

  Future<List<RdvModel>> getRdvByAnimalId(int id) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final maps = await db.query(
        'rdvs',
        where: 'animal_id = ?',
        whereArgs: [id],
      );
      return maps.map((m) => RdvModel.fromMap(m)).toList();
    } catch (e) {
      throw Exception('Failed to get rdv by animal id: $e');
    }
  }

  Future<int> updateRdv(RdvModel rdv) async {
    final db = await DatabaseHelper.instance.database;
    try {
      return await db.update(
        'rdvs',
        rdv.toMap(),
        where: 'id = ?',
        whereArgs: [rdv.id],
      );
    } catch (e) {
      throw Exception('Failed to update rdv: $e');
    }
  }

  Future<int> deleteRdv(int id) async {
    final db = await DatabaseHelper.instance.database;
    try {
      return await db.delete('rdvs', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete rdv: $e');
    }
  }
}
