import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

enum EstadoCamara { ok, cancelado, sinPermiso, error }

class ResultadoFoto {
  final EstadoCamara estado;
  final Uint8List? bytes;
  final String? detalle;

  const ResultadoFoto(this.estado, {this.bytes, this.detalle});

  String get mensaje => switch (estado) {
    EstadoCamara.ok => 'Fotografía capturada',
    EstadoCamara.cancelado => 'Captura cancelada',
    EstadoCamara.sinPermiso =>
      'Sin permiso de cámara: habilítalo en los ajustes del dispositivo',
    EstadoCamara.error =>
      'No se pudo usar la cámara'
          '${detalle == null ? '' : ' ($detalle)'}',
  };
}

class CamaraService {
  CamaraService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<ResultadoFoto> tomarFoto() async {
    try {
      final f = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1024,
      );
      if (f == null) return const ResultadoFoto(EstadoCamara.cancelado);
      return ResultadoFoto(EstadoCamara.ok, bytes: await f.readAsBytes());
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied' || e.code == 'photo_access_denied') {
        return const ResultadoFoto(EstadoCamara.sinPermiso);
      }
      return ResultadoFoto(EstadoCamara.error, detalle: e.message ?? e.code);
    } catch (e) {
      return ResultadoFoto(EstadoCamara.error, detalle: '$e');
    }
  }
}
