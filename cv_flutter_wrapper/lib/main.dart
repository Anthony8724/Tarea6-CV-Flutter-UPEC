// Tarea 6 - Estudiante: Anthony Lopez
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const CvWrapperApp());
}

class CvWrapperApp extends StatefulWidget {
  const CvWrapperApp({super.key});

  @override
  State<CvWrapperApp> createState() => _CvWrapperAppState();
}

class _CvWrapperAppState extends State<CvWrapperApp> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV Flutter Wrapper',
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: CvWebViewPage(
        darkMode: _darkMode,
        onThemeChanged: (value) => setState(() => _darkMode = value),
      ),
    );
  }
}

class CvWebViewPage extends StatefulWidget {
  const CvWebViewPage({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<CvWebViewPage> createState() => _CvWebViewPageState();
}

class _CvWebViewPageState extends State<CvWebViewPage> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => setState(() => _progress = progress),
          onPageFinished: (_) => _syncWebTheme(),
        ),
      )
      ..loadFlutterAsset('assets/web/index.html');
  }

  Future<void> _syncWebTheme() async {
    await _controller.runJavaScript('window.setAppTheme(${widget.darkMode});');
  }

  Future<void> _toggleTheme() async {
    widget.onThemeChanged(!widget.darkMode);
    await _controller.runJavaScript('window.setAppTheme(${!widget.darkMode});');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Hoja de Vida'),
        actions: [
          IconButton(
            tooltip: 'Recargar',
            onPressed: _controller.reload,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: widget.darkMode ? 'Tema claro' : 'Tema oscuro',
            onPressed: _toggleTheme,
            icon: Icon(widget.darkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
        bottom: _progress < 100
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: LinearProgressIndicator(value: _progress / 100),
              )
            : null,
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
