class Usuario {
  final int id;
  final String nombre;
  final String correo;

  Usuario({required this.id, required this.nombre, required this.correo});

  factory Usuario.fromJson(Map<String, dynamic> j) =>
      Usuario(id: j['id'], nombre: j['name'], correo: j['email']);
}
