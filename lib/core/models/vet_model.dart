import 'package:velp_lite/core/entities/vet_entity.dart';

class VetModel {
  int? id;
  String name;
  String email;
  String phone;
  String specialty;
  String clinic;

  VetModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialty,
    required this.clinic,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'specialty': specialty,
      'clinic': clinic,
    };
  }

  factory VetModel.fromMap(Map<String, dynamic> map) {
    return VetModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      specialty: map['specialty'],
      clinic: map['clinic'],
    );
  }

  VetEntity toEntity() {
    return VetEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      specialty: specialty,
      clinic: clinic,
    );
  }

  factory VetModel.fromEntity(VetEntity entity) {
    return VetModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      specialty: entity.specialty,
      clinic: entity.clinic,
    );
  }
}
