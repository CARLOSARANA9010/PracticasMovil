class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String image;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.image,
  });

  // Nombre completo del usuario.
  String get fullName => '$firstName $lastName';

  // Convierte un objeto JSON en un objeto User.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      image: json['image'] as String,
    );
  }
}
