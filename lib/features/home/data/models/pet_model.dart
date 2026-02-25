import 'package:velp_lite/features/home/data/entity/pet_entity.dart';

class PetModel {
  int? id;
  String name;
  String species;
  String breed;
  DateTime birthDate;
  String gender;
  double weight;
  String color;
  String chipNumber;
  int userID;

  PetModel({
    this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.birthDate,
    required this.gender,
    required this.weight,
    required this.color,
    required this.chipNumber,
    required this.userID,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'breed': breed,
      'birth_date': birthDate.toIso8601String(),
      'gender': gender,
      'weight': weight,
      'color': color,
      'chip_number': chipNumber,
      'owner_id': userID,
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'],
      name: map['name'],
      species: map['species'],
      breed: map['breed'],
      birthDate: DateTime.parse(map['birth_date'] as String),
      gender: map['gender'],
      weight: map['weight'].toDouble() ?? 0.0,
      color: map['color'],
      chipNumber: map['chip_number'] ?? '',
      userID: map['owner_id'],
    );
  }

  PetEntity toEntity() {
    return PetEntity(
      id: id,
      name: name,
      species: species,
      breed: breed,
      birthDate: birthDate,
      gender: gender,
      weight: weight,
      color: color,
      chipNumber: chipNumber,
      userID: userID,
    );
  }

  factory PetModel.fromEntity(PetEntity entity) {
    return PetModel(
      id: entity.id,
      name: entity.name,
      species: entity.species,
      breed: entity.breed,
      birthDate: entity.birthDate,
      gender: entity.gender,
      weight: entity.weight,
      color: entity.color,
      chipNumber: entity.chipNumber,
      userID: entity.userID,
    );
  }

  PetModel copyWith({
    int? id,
    String? name,
    String? species,
    String? breed,
    DateTime? birthDate,
    String? gender,
    double? weight,
    String? color,
    String? chipNumber,
    int? userID,
  }) => PetModel(
    id: id ?? this.id,
    name: name ?? this.name,
    species: species ?? this.species,
    breed: breed ?? this.breed,
    birthDate: birthDate ?? this.birthDate,
    gender: gender ?? this.gender,
    weight: weight ?? this.weight,
    color: color ?? this.color,
    chipNumber: chipNumber ?? this.chipNumber,
    userID: userID ?? this.userID,
  );
}
