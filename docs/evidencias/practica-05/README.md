# Evidencias · Práctica 05

## Resultados automáticos
```
$ flutter analyze
Analyzing practica_05_api...
No issues found!

$ flutter test
00:00 +1: Post.fromJson convierte el JSON
00:00 +2: Usuario.fromJson convierte el JSON
00:00 +3: muestra la lista y abre el detalle
00:00 +4: muestra error si el status no es 200
00:01 +5: muestra mensaje con lista vacía
00:01 +5: All tests passed!
```

## Casos manuales
| Caso | Pasos | Resultado esperado | Captura |
|------|-------|--------------------|---------|
| Carga | Abrir la app | Indicador circular | `01_carga.png` |
| Lista | Esperar respuesta | 100 publicaciones con título y cuerpo | `02_lista.png` |
| Detalle | Tocar una publicación | Título, usuario y cuerpo completo | `03_detalle.png` |
| Refresh | Deslizar hacia abajo | La lista se recarga | `04_refresh.png` |
| Error | Desactivar Internet y recargar | Mensaje de error y botón *Reintentar* | `05_error.png` |
| Ejemplo guiado | Botón 👥 | Lista de 10 usuarios | `06_usuarios.png` |
