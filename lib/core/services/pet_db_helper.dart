import 'package:velp_lite/core/models/pet_model.dart';
import 'package:velp_lite/core/services/database_helper.dart';

class PetDbHelper {
  PetDbHelper._init();

  static final PetDbHelper instance = PetDbHelper._init();

  Future<PetModel> createPet(PetModel pet) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final id = await db.insert('pets', pet.toMap());
      pet.id = id;
      return pet;
    } catch (e) {
      throw Exception('Failed to create pet: $e');
    }
  }

  Future<List<PetModel>> getPets() async {
    final db = await DatabaseHelper.instance.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('pets');
      return maps.map((m) => PetModel.fromMap(m)).toList();
    } catch (e) {
      throw Exception('Failed to get pets: $e');
    }
  }

  Future<PetModel> getPet(int id) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final maps = await db.query('pets', where: 'id = ?', whereArgs: [id]);
      if (maps.isNotEmpty) {
        return PetModel.fromMap(maps.first);
      } else {
        throw Exception('Pet not found');
      }
    } catch (e) {
      throw Exception('Failed to get pet: $e');
    }
  }

  Future<int> updatePet(PetModel pet) async {
    final db = await DatabaseHelper.instance.database;
    try {
      return await db.update(
        'pets',
        pet.toMap(),
        where: 'id = ?',
        whereArgs: [pet.id],
      );
    } catch (e) {
      throw Exception('Failed to update pet: $e');
    }
  }

  Future<int> deletePet(int id) async {
    final db = await DatabaseHelper.instance.database;
    try {
      return await db.delete('pets', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete pet: $e');
    }
  }
}
