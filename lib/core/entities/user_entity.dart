class UserEntity {
  int? id;
  String? firstName;
  String? lastName;
  String email;
  String password;

  UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    required this.email,
    required this.password,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}';
}
