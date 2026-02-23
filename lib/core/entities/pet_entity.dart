class PetEntity {
  final int? id;
  final String name;
  final String species;
  final String breed;
  final DateTime birthDate;
  final String gender;
  final double weight;
  final String color;
  final String chipNumber;
  final int userID;
  
  const PetEntity({
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

  PetEntity copyWith({
    String? name,
    String? species,
    String? breed,
    DateTime? birthDate,
    String? gender,
    double? weight,
    String? color,
    String? chipNumber,
    int? userID,
  }) {
    return PetEntity(
      id: id,
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

  /// computed age (years)
  int get ageYears {
    final today = DateTime.now();
    int ageYears = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      ageYears--;
    }
    return ageYears;
  }

  int get ageMonths {
    final today = DateTime.now();
    int months =
        (today.year - birthDate.year) * 12 + (today.month - birthDate.month);
    if (today.day < birthDate.day) months--;
    return months;
  }

  /// label: "2 years" or "7 months" or "Less than 1 month"
  String get ageLabel {
    final years = ageYears;
    if (years >= 1) {
      return years == 1 ? '1 year' : '$years years';
    }

    final months = ageMonths;
    if (months <= 0) return 'Less than 1 month';
    return months == 1 ? '1 month' : '$months months';
  }

  String get emoji {
    switch (species) {
      case 'Dog':
        return '🐕';
      case 'Cat':
        return '🐱';
      case 'Bird':
        return '🐦‍⬛';
      case 'Fish':
        return '🐟';
      case 'Rabbit':
        return '🐰';
      case 'Other':
        return '🐾';
    }
    return '🐾';
  }

  @override
  String toString() {
    return 'PetEntity(id: $id, name: $name, species: $species, breed: $breed, birthDate: $birthDate, gender: $gender, weight: $weight, color: $color, chipNumber: $chipNumber, userID: $userID)';
  }
}
