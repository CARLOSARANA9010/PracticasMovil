import 'package:flutter/foundation.dart';

import '../models/post.dart';
import '../services/api_service.dart';

enum EstadoCarga { inicial, cargando, listo, error }

/// Estado de la lista de publicaciones. La interfaz solo lee estas propiedades
/// y llama a [cargar]; no conoce HTTP ni JSON.
class PostsProvider extends ChangeNotifier {
  PostsProvider(this._api);

  final ApiService _api;

  EstadoCarga _estado = EstadoCarga.inicial;
  List<Post> _posts = const [];
  String? _error;
  DateTime? _actualizado;
  bool _disposed = false;

  EstadoCarga get estado => _estado;
  List<Post> get posts => _posts;
  String? get error => _error;
  DateTime? get actualizado => _actualizado;

  Future<void> cargar() async {
    _estado = EstadoCarga.cargando;
    _error = null;
    _notificar();
    try {
      _posts = await _api.obtenerPosts();
      _actualizado = DateTime.now();
      _estado = EstadoCarga.listo;
    } on ApiException catch (e) {
      _error = e.mensaje;
      _estado = EstadoCarga.error;
    }
    _notificar();
  }

  void _notificar() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
