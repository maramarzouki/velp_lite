class RdvModel {
  int? id;
  String animalID;
  String vet;
  String date;
  bool isConfirmed;

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
      'animalID': animalID,
      'vet': vet,
      'date': date,
      'isConfirmed': isConfirmed,
    };
  }

  factory RdvModel.fromMap(Map<String, dynamic> map) {
    return RdvModel(
      id: map['id'],
      animalID: map['animalID'],
      vet: map['vet'],
      date: map['date'],
      isConfirmed: map['isConfirmed'],
    );
  }
}
