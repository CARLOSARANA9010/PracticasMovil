/// Condiciones actuales devueltas por la API REST de Open-Meteo.
class Clima {
  final double temperatura;
  final double viento;
  final int codigo;
  final DateTime? hora;

  const Clima({
    required this.temperatura,
    required this.viento,
    required this.codigo,
    this.hora,
  });

  factory Clima.fromJson(Map<String, dynamic> j) {
    final c = j['current'] as Map<String, dynamic>;
    return Clima(
      temperatura: (c['temperature_2m'] as num).toDouble(),
      viento: (c['wind_speed_10m'] as num).toDouble(),
      codigo: (c['weather_code'] as num).toInt(),
      hora: DateTime.tryParse((c['time'] as String?) ?? ''),
    );
  }

  /// Traducción del código meteorológico WMO a texto.
  String get descripcion {
    if (codigo == 0) return 'Despejado';
    if (codigo <= 3) return 'Parcialmente nublado';
    if (codigo == 45 || codigo == 48) return 'Niebla';
    if (codigo >= 51 && codigo <= 57) return 'Llovizna';
    if (codigo >= 61 && codigo <= 67) return 'Lluvia';
    if (codigo >= 71 && codigo <= 77) return 'Nieve';
    if (codigo >= 80 && codigo <= 82) return 'Chubascos';
    if (codigo >= 95) return 'Tormenta';
    return 'Condición variable';
  }
}
