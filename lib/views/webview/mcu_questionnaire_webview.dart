import 'package:ngoerahsun/l10n/app_localizations.dart';
import 'package:ngoerahsun/utils/repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MCUQuestionnaireWebView extends StatefulWidget {
  final String bookingCode;
  const MCUQuestionnaireWebView({super.key, required this.bookingCode});

  @override
  State<MCUQuestionnaireWebView> createState() =>
      _MCUQuestionnaireWebViewState();
}

class _MCUQuestionnaireWebViewState extends State<MCUQuestionnaireWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  ResourceRepository repo = ResourceRepository();

  @override
  void initState() {
    super.initState();
    final url = '${repo.getWebViewBookCode}/${widget.bookingCode}';
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('MCU Questionnaire (${widget.bookingCode})'),
        title: Text(
          AppLocalizations.of(context)!.mcu_questionnaire,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
