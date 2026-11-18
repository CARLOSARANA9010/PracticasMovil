# Calculadora de Consumo de Combustible

Aplicación móvil desarrollada en **Flutter y Dart** como parte de la **Práctica No. 2: Fundamentos de Dart, Widgets y Estado**.

La aplicación permite calcular el rendimiento de combustible de un vehículo a partir de los kilómetros recorridos y los litros de combustible utilizados. Además, valida los datos introducidos, permite limpiar los campos y clasifica el rendimiento obtenido en tres niveles.

---

## Objetivo

Aplicar los fundamentos del lenguaje **Dart** y el manejo de estado en **Flutter**, utilizando variables, funciones, conversión de tipos, validación de entradas y actualización de la interfaz mediante `setState()`.

La aplicación solicita al usuario:

* Kilómetros recorridos.
* Litros utilizados.

Con estos datos se calcula el rendimiento del vehículo mediante la fórmula:

**Rendimiento = Kilómetros recorridos / Litros utilizados**

El resultado se muestra en **km/L** y se clasifica de acuerdo con el valor obtenido.

### Clasificación del rendimiento

| Rendimiento              | Clasificación     |
| ------------------------ | ----------------- |
| Menor a 10 km/L          | Bajo rendimiento  |
| De 10 a menos de 15 km/L | Rendimiento medio |
| 15 km/L o mayor          | Buen rendimiento  |

---

## Requisitos

Para ejecutar el proyecto se requiere contar con:

* **Flutter SDK**
* **Dart SDK** incluido con Flutter
* **Visual Studio Code** o un IDE compatible con Flutter
* Un dispositivo Android, emulador o dispositivo de prueba compatible
* **Git** para el control de versiones
* Conexión a Internet para la instalación inicial de dependencias

Se recomienda tener correctamente configurada la variable de entorno de Flutter y verificar la instalación mediante:

```bash
flutter doctor
```

---

## Instalación

### 1. Clonar el repositorio

```bash
git clone URL_DEL_REPOSITORIO
```

### 2. Entrar al proyecto

```bash
cd calculadora
```

### 3. Instalar las dependencias

```bash
flutter pub get
```

### 4. Verificar el proyecto

```bash
flutter analyze
```

---

## Ejecución

Para ejecutar la aplicación se debe conectar un dispositivo físico o iniciar un emulador compatible.

Posteriormente ejecutar:

```bash
flutter run
```

La aplicación mostrará la pantalla principal **"Calculadora de rendimiento"**, donde el usuario podrá introducir los kilómetros recorridos y los litros utilizados.

### Ejemplo de uso

Si se introducen:

```text
Kilómetros recorridos: 300
Litros utilizados: 20
```

El cálculo realizado será:

```text
300 / 20 = 15 km/L
```

Por lo tanto, la aplicación mostrará:

```text
15.00 km/L
Buen rendimiento
```

---

## Validación de datos

La aplicación valida que los valores introducidos sean numéricos y mayores que cero.

En caso de introducir datos inválidos, por ejemplo letras, campos vacíos, cero o valores negativos, se muestra el siguiente mensaje:

```text
Ingresa kilómetros y litros válidos mayores que cero.
```

Esto evita realizar cálculos incorrectos y permite que la aplicación continúe funcionando sin cerrarse.

---

## Limpieza de campos

La aplicación cuenta con el botón **"Limpiar campos"**, que permite borrar los kilómetros y litros introducidos y restablecer el resultado mostrado.

---

## Pruebas

El proyecto incluye pruebas automatizadas mediante el framework de pruebas de Flutter.

Para ejecutar las pruebas:

```bash
flutter test
```

También se recomienda comprobar el análisis estático del proyecto mediante:

```bash
flutter analyze
```

Las pruebas contemplan situaciones como:

* Estado inicial de la aplicación.
* Cálculo correcto del rendimiento.
* Clasificación de rendimiento bajo.
* Clasificación de rendimiento medio.
* Clasificación de buen rendimiento.
* Validación de entradas no numéricas.
* Validación de valores cero o negativos.
* Limpieza de los campos y restablecimiento del resultado.

---

## Evidencias

Las evidencias de la práctica incluyen capturas de:

1. Interfaz principal de la aplicación.
2. Introducción de datos válidos.
3. Resultado correcto del cálculo.
4. Clasificación del rendimiento.
5. Validación al introducir datos no numéricos.
6. Limpieza de los campos.
7. Resultado de `flutter analyze`.
8. Resultado de `flutter test`.

Las evidencias correspondientes se encuentran dentro de la documentación de la práctica.

---

## Estructura principal del proyecto

```text
calculadora/
│
├── lib/
│   └── main.dart
│
├── test/
│   ├── combustible_app_test.dart
│   └── widget_test.dart
│
├── pubspec.yaml
└── README.md
```

---

## Tecnologías utilizadas

* **Flutter**
* **Dart**
* **Material Design 3**
* **Visual Studio Code**
* **Git / GitHub**

---

## Participantes

**Nombre del proyecto:** Calculadora de Consumo de Combustible

**Institución:** Instituto Tecnológico Superior de Calkiní (ITESCAM)

**Carrera:** Ingeniería en Sistemas Computacionales

**Materia:** Tópicos de Programación Móvil

**Práctica:** No. 2 — Fundamentos de Dart, Widgets y Estado

**Participantes:**

* CARLOS ADRIAN ARANA HERRERA
* CARLOS EDUARDO TUZ EUAN
* CARLOS RIVERA RODRIGUEZ
* ARMANDO JOSUE CAAMAL ROSADO

---

## Autoría y versión

**Versión:** 1.0

**Estado:** Práctica funcional con pruebas y evidencias.

**Repositorio:** https://github.com/CARLOSARANA9010/PracticasMovil.git

**Rama de trabajo:** `practica-02-dart-estado`
