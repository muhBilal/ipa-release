import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    log("🔗 WebView init with URL: ${widget.url}");

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            log("➡️ Navigating to: $url");

            if (_isDownloadUrl(url)) {
              log("📥 Detected download link: $url");
              _downloadFile(url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
            log("▶️ Page started loading: $url");
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            log("✅ Page finished loading: $url");
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
            log("❌ Web resource error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  bool _isDownloadUrl(String url) {
    return url.contains("/download_result/") ||
        url.toLowerCase().endsWith(".pdf");
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      var manage = await Permission.manageExternalStorage.status;
      var storage = await Permission.storage.status;
      log("🔐 Status awal -> manage: $manage, storage: $storage");

      if (manage.isGranted || storage.isGranted) return true;

      var reqManage = await Permission.manageExternalStorage.request();
      if (reqManage.isGranted) return true;

      var reqStorage = await Permission.storage.request();
      if (reqStorage.isGranted) return true;

      log("❌ Semua izin storage ditolak");
      return false;
    }
    return true;
  }

  Future<void> _downloadFile(String url) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      bool granted = await _requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(l10n.storagePermissionDenied))
          );
        }
        return;
      }

      final dir = Directory("/storage/emulated/0/Download");
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final fileName =
          "downloaded_result_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final savePath = "${dir.path}/$fileName";


      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            log("Progress: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      log("✅ File berhasil di-download: $savePath");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.fileSavedToDownload(fileName)),),
        );
      }

      await OpenFilex.open(savePath);
    } catch (e) {
      log("❌ Error download: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToDownloadFile)),
        );
      }
    }
  }

  void _reloadPage() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (!_isLoading && !_hasError)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reloadPage,
            )
        ],
      ),
      body: Stack(
        children: [
          if (_hasError)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.failedToLoadPage),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _reloadPage,
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            )
          else
            WebViewWidget(controller: controller),
          if (_isLoading)
            Container(
              color: Colors.white, // biar ga nampak kosong hitam
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
