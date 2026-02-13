import 'package:flutter/material.dart';
import 'package:velp_lite/core/entities/rdv_entity.dart';
import 'package:velp_lite/core/services/rdv_db_helper.dart';
import 'package:velp_lite/features/rdv/data/model/rdv_model.dart';

class RdvRepository {
  // final RdvDbHelper db = RdvDbHelper.instance;

  final RdvDbHelper db;
  RdvRepository({required this.db});

  Future<RdvEntity> createRdv(RdvEntity rdv) async {
    final rdvModel = RdvModel.fromEntity(rdv);
    final createdRdv = await db.createRdv(rdvModel);
    return createdRdv.toEntity();
  }

  Future<List<RdvEntity>> getRdvs() async {
    debugPrint('Getting Rdvs');
    final rdvs = await db.getRdvs();
    debugPrint('Rdvs: ${rdvs.length}');
    return rdvs.map((e)=>e.toEntity()).toList();
  }

  Future<List<RdvEntity>> getRdvByAnimalId(int id) async {
    final rdv = await db.getRdvByAnimalId(id);
    return rdv.map((e)=>e.toEntity()).toList();
  }

  Future<int> updateRdv(RdvEntity rdv) async {
    final updatedRdv = RdvModel.fromEntity(rdv);
    return await db.updateRdv(updatedRdv);
  }

  Future<int> deleteRdv(int id) async {
    return await db.deleteRdv(id);
  }
}
