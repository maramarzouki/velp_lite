import 'package:velp_lite/core/entities/vet_entity.dart';
import 'package:velp_lite/core/services/vet_db_helper.dart';

class VetRepository {
  final VetDbHelper db;
  VetRepository({required this.db});

  Future<List<VetEntity>> getVets() async {
    final vets = await db.getVets();
    return vets.map((e) => e.toEntity()).toList();
  }

  Future<VetEntity> getVet(int id) async {
    final vet = await db.getVet(id);
    return vet.toEntity();
  }
}