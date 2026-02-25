class RdvEntity {
  final int? id;
  final int animalID;
  final String vet;
  final DateTime date;
  final int isConfirmed;
  final int vetID;

  const RdvEntity({
    this.id,
    required this.animalID,
    required this.vet,
    required this.date,
    required this.isConfirmed,
    required this.vetID,
  });

  @override
  String toString() {
    return 'RdvEntity(id: $id, animalID: $animalID, vet: $vet, date: $date, isConfirmed: $isConfirmed, vetID: $vetID)';
  }
}
