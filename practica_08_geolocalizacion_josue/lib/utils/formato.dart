String formatearDistancia(double metros) {
  if (metros < 1000) return '${metros.round()} m';
  return '${(metros / 1000).toStringAsFixed(2)} km';
}

String formatearCoordenada(double valor) => valor.toStringAsFixed(5);
