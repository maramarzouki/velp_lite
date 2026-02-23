
import 'package:velp_lite/core/models/vet_model.dart';
import 'package:velp_lite/core/services/database_helper.dart';

class VetDbHelper {
  static final VetDbHelper instance = VetDbHelper._init();
  VetDbHelper._init();

  // get all vets
  Future<List<VetModel>> getVets() async {
    final db = await DatabaseHelper.instance.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('vets');
      return maps.map((m) => VetModel.fromMap(m)).toList();
    } catch (e) {
      throw Exception('Failed to get vets: $e');
    }
  } 

  // get vet by id
  Future<VetModel> getVet(int id) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final maps = await db.query('vets', where: 'id = ?', whereArgs: [id]);
      return VetModel.fromMap(maps.first);
    } catch (e) {
      throw Exception('Failed to get vet: $e');
    }
  }
}
