class VetEntity {
  int? id;
  String name;
  String email;
  String phone;
  String specialty;
  String clinic;

  VetEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialty,
    required this.clinic,
  });

  List<String> get availableTimes => [
    '09:00',
    '10:00',
    '13:00',
    '15:00',
  ];

  String get emoji => '🧑🏻‍⚕️';
}
