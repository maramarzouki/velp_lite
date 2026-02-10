import 'package:velp_lite/core/models/pet_model.dart';
import 'package:velp_lite/core/services/database_helper.dart';

class PetDbHelper {
  
  PetDbHelper._init();

  static final PetDbHelper instance = PetDbHelper._init();

  Future<PetModel> createPet(PetModel pet) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert('pets', pet.toMap());
    pet.id = id;
    return pet;
  }

  Future<List<PetModel>> getPets() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('pets');
    return maps.map((m) => PetModel.fromMap(m)).toList();
  }

  Future<PetModel> getPet(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('pets', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return PetModel.fromMap(maps.first);
    } else {
      throw Exception('Pet not found');
    }
  }

  Future<int> updatePet(PetModel pet) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'pets',
      pet.toMap(),
      where: 'id = ?',
      whereArgs: [pet.id],
    );
  }

  Future<int> deletePet(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete('pets', where: 'id = ?', whereArgs: [id]);
  }
}
