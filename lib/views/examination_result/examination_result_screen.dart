import 'dart:developer';
import 'dart:io';
import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:Ngoerahsun/views/webview_screen.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';
import 'package:Ngoerahsun/model/examination_model.dart';
import 'package:Ngoerahsun/provider/examination/examination_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Ngoerahsun/widgets/gradient_background/gradient_background.dart';

class ExaminationResultPage extends StatefulWidget {
  const ExaminationResultPage({super.key});

  @override
  State<ExaminationResultPage> createState() => _ExaminationResultPageState();
}

class _ExaminationResultPageState extends State<ExaminationResultPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<ExaminationProvider>(context, listen: false);
      await provider.loadMenus();
      if (mounted && provider.menus.isNotEmpty) {
        _tabController = TabController(length: provider.menus.length, vsync: this);
        setState(() {});
      }
      provider.loadExaminations();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      var manage = await Permission.manageExternalStorage.status;
      var storage = await Permission.storage.status;
      if (manage.isGranted || storage.isGranted) return true;
      var reqManage = await Permission.manageExternalStorage.request();
      if (reqManage.isGranted) return true;
      var reqStorage = await Permission.storage.request();
      if (reqStorage.isGranted) return true;
      return false;
    }
    return true;
  }

  Future<void> _downloadAndOpenPdf(String url, String fileName) async {
    try {
      bool granted = await _requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.permission_denied_to_access_storage),),
          );
        }
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final dir = Directory("/storage/emulated/0/Download");
      if (!await dir.exists()) await dir.create(recursive: true);

      final savePath = "${dir.path}/${fileName.replaceAll(" ", "_")}.pdf";
      log("📥 Downloading to: $savePath");

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

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.file_saved_to_download_pdf(fileName)))
        );
      }

      await OpenFilex.open(savePath);
    } catch (e) {
      log("❌ Error downloading: $e");
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.failedToDownloadFile))
        );
      }
    }
  }

  void _openPdfViewer(String url, String fileName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url, title: fileName),
      ),
    );
  }

  Widget _buildResultCard(Examination result) {
    IconData icon =
        result.category == 'lab' ? Icons.science : Icons.medical_services;

    Color cardColor = result.category == 'lab'
        ? Colors.green.withOpacity(0.1)
        : Colors.blue.withOpacity(0.1);

    Color iconColor = result.category == 'lab' ? Colors.green : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (result.url.isNotEmpty) {
              if (result.category.toLowerCase() == "mcu") {
                _downloadAndOpenPdf(result.url, result.name);
              } else {
                _openPdfViewer(result.url, result.name);
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.no_pdf_available_for_this_result)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result.date,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    result.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList(List<Examination> results) {
    if (results.isEmpty) {
      return Center(
        child: Image.asset('assets/images/not_found1.png', width: 300, height: 250),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) => _buildResultCard(results[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExaminationProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingMenu || _tabController == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (provider.errorMenu != null) {
          return Scaffold(
            body: Center(child: Text(AppLocalizations.of(context)!.error_1(provider.errorMenu ?? ''))),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.examination_results,
              style: TextStyle(
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
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              tabs: provider.menus.map((m) => Tab(text: m)).toList(),
            ),
          ),
          body: GradientBackground(
            child: TabBarView(
              controller: _tabController,
              children: provider.menus
                  .map((menu) => _buildResultsList(provider.filterByType(menu.toLowerCase())))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
