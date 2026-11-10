class Post {
  final int id;
  final int userId;
  final String titulo;
  final String cuerpo;

  const Post({
    required this.id,
    required this.userId,
    required this.titulo,
    required this.cuerpo,
  });

  factory Post.fromJson(Map<String, dynamic> j) => Post(
    id: j['id'] as int,
    userId: j['userId'] as int,
    titulo: j['title'] as String,
    cuerpo: j['body'] as String,
  );
}
