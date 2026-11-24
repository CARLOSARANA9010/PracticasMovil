import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../widgets/estado_vista.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  final _apiService = ApiService();
  final _storageService = StorageService();

  bool _cargando = true;
  bool _sincronizando = false;
  String? _error;
  List<Map<String, dynamic>> _avisos = [];

  @override
  void initState() {
    super.initState();
    _cargarDatosRemotos();
  }

  Future<void> _cargarDatosRemotos() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final datos = await _apiService.obtenerAvisosRemotos();
      if (!mounted) return;
      setState(() {
        _avisos = datos
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _sincronizarLocales() async {
    setState(() => _sincronizando = true);
    try {
      final locales = await _storageService.obtenerReportes();
      if (locales.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay reportes locales para sincronizar.'),
          ),
        );
        return;
      }

      int enviados = 0;
      for (final item in locales) {
        final ok = await _apiService.sincronizarReporte(item);
        if (ok) enviados++;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sincronizados $enviados de ${locales.length} reportes.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fallo al sincronizar: $e')));
    } finally {
      if (mounted) setState(() => _sincronizando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronización y API REST'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargando ? null : _cargarDatosRemotos,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _sincronizando ? null : _sincronizarLocales,
                icon: _sincronizando
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud_upload),
                label: Text(
                  _sincronizando
                      ? 'Sincronizando reportes...'
                      : 'Sincronizar reportes locales con API',
                ),
              ),
            ),
          ),
          Expanded(child: _construirContenido()),
        ],
      ),
    );
  }

  Widget _construirContenido() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return EstadoVista(
        icono: Icons.cloud_off,
        titulo: 'Sin conexión con el servidor',
        mensaje: _error!,
        onReintentar: _cargarDatosRemotos,
      );
    }
    return ListView.builder(
      itemCount: _avisos.length,
      itemBuilder: (context, index) {
        final item = _avisos[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(child: Text('${item['id']}')),
            title: Text(
              item['title'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              item['body'] as String,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
