import 'package:velp_lite/core/entities/rdv_entity.dart';

class RdvModel {
  int? id;
  int animalID;
  String vet;
  DateTime date;
  int isConfirmed;

  RdvModel({
    this.id,
    required this.animalID,
    required this.vet,
    required this.date,
    required this.isConfirmed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'animal_id': animalID,
      'vet': vet,
      'date': date.toIso8601String(),
      'is_confirmed': isConfirmed,
    };
  }

  factory RdvModel.fromMap(Map<String, dynamic> map) {
    return RdvModel(
      id: map['id'],
      animalID: map['animal_id'],
      vet: map['vet'],
      date: DateTime.parse(map['date'] as String),
      isConfirmed: map['is_confirmed'],
    );
  }

  RdvEntity toEntity() {
    return RdvEntity(
      id: id,
      animalID: animalID,
      vet: vet,
      date: date,
      isConfirmed: isConfirmed,
    );
  }

  factory RdvModel.fromEntity(RdvEntity entity) {
    return RdvModel(
      id: entity.id,
      animalID: entity.animalID,
      vet: entity.vet,
      date: entity.date,
      isConfirmed: entity.isConfirmed,
    );
  }
}
