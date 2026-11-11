{{flutter_js}}
{{flutter_build_config}}

// Sin serviceWorkerSettings: el service worker de Flutter está obsoleto y se da de baja solo,
// lo que borraría el nuestro (web/sw.js, registrado en index.html).
_flutter.loader.load();
