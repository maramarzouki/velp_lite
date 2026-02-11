class RdvEntity {
  final int? id;
  final int animalID;
  final String vet;
  final DateTime date;
  final int isConfirmed; 

  const RdvEntity({
    this.id,
    required this.animalID,
    required this.vet,
    required this.date,
    required this.isConfirmed,
  });

  @override
  String toString() {
    return 'RdvEntity(id: $id, animalID: $animalID, vet: $vet, date: $date, isConfirmed: $isConfirmed)';
  }

}
