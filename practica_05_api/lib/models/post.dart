class Post {
  final int id;
  final int userId;
  final String titulo;
  final String cuerpo;

  Post({
    required this.id,
    required this.userId,
    required this.titulo,
    required this.cuerpo,
  });

  factory Post.fromJson(Map<String, dynamic> j) => Post(
    id: j['id'],
    userId: j['userId'],
    titulo: j['title'],
    cuerpo: j['body'],
  );
}
