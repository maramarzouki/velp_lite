import 'package:velp_lite/features/home/data/entity/pet_entity.dart';
import 'package:velp_lite/features/home/data/models/pet_model.dart';
import 'package:velp_lite/core/services/pet_db_helper.dart';

class PetRepository {
  // final PetDbHelper db = PetDbHelper.instance;

  final PetDbHelper db;
  PetRepository({required this.db});

  Future<PetEntity> addPet(PetEntity pet) async {
    final petModel = PetModel.fromEntity(pet);
    final createdPet = await db.createPet(petModel);
    return createdPet.toEntity();
  }

  Future<List<PetEntity>> getPets(int ownerId) async {
    final pets = await db.getPets(ownerId);
    return pets.map((e) => e.toEntity()).toList();
  }

  Future<PetEntity> getPet(int id) async {
    final pet = await db.getPet(id);
    return pet.toEntity();
  }

  Future<int> updatePet(PetEntity pet) async {
    final petModel = PetModel.fromEntity(pet);
    return await db.updatePet(petModel);
  }

  Future<int> deletePet(int id) async {
    return await db.deletePet(id);
  }
}
