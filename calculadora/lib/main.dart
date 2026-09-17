import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const CombustiblePage(),
    );
  }
}

class CombustiblePage extends StatefulWidget {
  const CombustiblePage({super.key});

  @override
  State<CombustiblePage> createState() => _CombustiblePageState();
}

class _CombustiblePageState extends State<CombustiblePage> {
  final kilometrosController = TextEditingController();
  final litrosController = TextEditingController();

  double rendimiento = 0;
  String nivel = '';
  String mensaje = '';

  void calcularRendimiento() {
    final kilometros = double.tryParse(kilometrosController.text.trim());

    final litros = double.tryParse(litrosController.text.trim());

    if (kilometros == null ||
        litros == null ||
        kilometros <= 0 ||
        litros <= 0) {
      setState(() {
        mensaje = 'Ingresa kilómetros y litros válidos mayores que cero.';
        rendimiento = 0;
        nivel = '';
      });
      return;
    }

    final resultado = kilometros / litros;

    String clasificacion;

    if (resultado < 10) {
      clasificacion = 'Bajo rendimiento';
    } else if (resultado < 15) {
      clasificacion = 'Rendimiento medio';
    } else {
      clasificacion = 'Buen rendimiento';
    }

    setState(() {
      rendimiento = resultado;
      nivel = clasificacion;
      mensaje = '';
    });
  }

  void limpiarCampos() {
    kilometrosController.clear();
    litrosController.clear();

    setState(() {
      rendimiento = 0;
      nivel = '';
      mensaje = '';
    });
  }

  @override
  void dispose() {
    kilometrosController.dispose();
    litrosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consumo de combustible')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.local_gas_station, size: 70, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Calculadora de rendimiento',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: kilometrosController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Kilómetros recorridos',
                hintText: 'Ej. 300',
                prefixIcon: Icon(Icons.route),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: litrosController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Litros utilizados',
                hintText: 'Ej. 20',
                prefixIcon: Icon(Icons.local_gas_station),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: calcularRendimiento,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular rendimiento'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: limpiarCampos,
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar campos'),
            ),
            const SizedBox(height: 24),
            if (mensaje.isNotEmpty)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    mensaje,
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (nivel.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('Resultado', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(
                        '${rendimiento.toStringAsFixed(2)} km/L',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        nivel,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
