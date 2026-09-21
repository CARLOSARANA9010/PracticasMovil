# Práctica 03 — Formularios, Validación, Listas y Diseño Responsivo

## Objetivo

Desarrollar una aplicación móvil en Flutter que permita registrar productos mediante un formulario validado, administrar los registros mediante una lista interactiva y calcular el valor total del inventario.

La práctica permite aplicar conceptos de formularios, validaciones, eventos, listas dinámicas y diseño responsivo, los cuales podrán reutilizarse posteriormente en el proyecto integrador.

## Funcionalidades

La aplicación permite:

* Registrar productos mediante un formulario.
* Validar los campos obligatorios.
* Seleccionar una categoría mediante un `DropdownButtonFormField`.
* Validar nombre, precio y existencia.
* Mostrar los productos registrados en un `ListView`.
* Eliminar productos individualmente.
* Calcular automáticamente el valor del inventario.
* Adaptar la interfaz a diferentes tamaños de pantalla.
* Mostrar mensajes de confirmación al agregar o eliminar productos.

## Campos del formulario

Cada producto contiene:

* **Nombre:** mínimo 3 caracteres.
* **Categoría:** Tecnología, Accesorios, Papelería, Ropa u Otros.
* **Precio:** valor numérico mayor que cero.
* **Existencia:** número entero mayor o igual a cero.

## Requisitos

* Flutter 3.47.2
* Dart 3.13.2
* Windows 11
* Visual Studio Code
* Google Chrome para ejecución web

## Instalación

Clonar el repositorio:

```bash
git clone https://github.com/CARLOSARANA9010/PracticasMovil.git
```

Entrar al proyecto:

```bash
cd PracticasMovil/practica_03_registro
```

Instalar las dependencias:

```bash
flutter pub get
```

## Ejecución

Para ejecutar la aplicación en Chrome:

```bash
flutter run -d chrome
```

## Verificación del proyecto

Formatear el código:

```bash
dart format .
```

Analizar el proyecto:

```bash
flutter analyze
```

Ejecutar las pruebas:

```bash
flutter test
```

Las pruebas automatizadas verifican:

1. Validación del formulario vacío.
2. Registro de un producto y cálculo de su valor.
3. Eliminación de un producto.

## Pruebas funcionales realizadas

Se verificó manualmente:

* Envío del formulario vacío.
* Validación de datos incorrectos.
* Registro de cinco productos.
* Cálculo del valor total del inventario.
* Eliminación de un producto.
* Actualización del total después de eliminar.
* Visualización correcta en una ventana pequeña.
* Visualización correcta en una ventana grande.

## Evidencias

Las evidencias de la práctica se encuentran en:

```text
docs/evidencias/practica-03/
```

## Estructura principal

```text
practica_03_registro/
├── lib/
│   └── main.dart
├── test/
│   └── widget_test.dart
├── README.md
└── pubspec.yaml
```

## Participantes

* Carlos Arana
* Josué Caamal
* Carlos Eduardo
* Carlos Rivera

## Estado

Práctica 03 completada y validada mediante análisis estático y pruebas automatizadas.
