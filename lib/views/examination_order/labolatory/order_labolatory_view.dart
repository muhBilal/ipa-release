import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:Ngoerahsun/widgets/gradient_background/gradient_background.dart';
import 'package:Ngoerahsun/provider/lab/lab_provider.dart';
import 'package:Ngoerahsun/model/lab_menu.dart';
import 'package:Ngoerahsun/views/doctor_booking/doctor_booking_screen.dart';

class LabOrderPageView extends StatefulWidget {
  const LabOrderPageView({super.key});

  @override
  State<LabOrderPageView> createState() => _LabOrderPageViewState();
}

class _LabOrderPageViewState extends State<LabOrderPageView> {
  final Set<int> _selectedContentIds = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LabProvider>().fetchMenus();
    });
  }

  void _toggleContent(LabContent c) {
    setState(() {
      final id = c.kodeJasa ?? c.hashCode;
      if (_selectedContentIds.contains(id)) {
        _selectedContentIds.remove(id);
      } else {
        _selectedContentIds.add(id);
      }
    });
  }

  int _parsePrice(String? raw) {
    if (raw == null || raw.isEmpty) return 0;
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0;
    return int.tryParse(digits) ?? 0;
  }

  int get _totalPrice {
    final prov = context.read<LabProvider>();
    int sum = 0;
    for (final menu in prov.menus) {
      for (final c in menu.content ?? []) {
        final id = c.kodeJasa ?? c.hashCode;
        if (_selectedContentIds.contains(id)) {
          sum += _parsePrice(c.tarifTindakan ?? c.hargaBPJS);
        }
      }
    }
    return sum;
  }

  String _formatPrice(int price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          AppLocalizations.of(context)!.laboratory_order,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GradientBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search_laboratory,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<LabProvider>(
                builder: (context, prov, _) {
                  if (prov.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (prov.error != null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.error_3 + (prov.error ?? ''),
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => prov.fetchMenus(forceRefresh: true),
                            child: Text(AppLocalizations.of(context)!.retry)
                          )
                        ],
                      ),
                    );
                  }
                  if (prov.menus.isEmpty) {
                    return Center(
                      child: Text(AppLocalizations.of(context)!.no_laboratory_data),
                    );
                  }

                  final filteredMenus = prov.menus
                      .map((menu) {
                        final filteredContent = (menu.content ?? [])
                            .where((c) =>
                                c.namaJasa
                                    ?.toLowerCase()
                                    .contains(_searchQuery) ??
                                false)
                            .toList();
                        if (filteredContent.isNotEmpty ||
                            (menu.title
                                    ?.toLowerCase()
                                    .contains(_searchQuery) ??
                                false) ||
                            _searchQuery.isEmpty) {
                          return LabMenu(
                            title: menu.title,
                            content: filteredContent.isNotEmpty
                                ? filteredContent
                                : menu.content,
                          );
                        }
                        return null;
                      })
                      .whereType<LabMenu>()
                      .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredMenus.length,
                    itemBuilder: (context, index) {
                      final menu = filteredMenus[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                menu.title ?? '-',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: List.generate(
                                  (menu.content ?? []).length,
                                  (cIndex) {
                                    final content = menu.content![cIndex];
                                    final id =
                                        content.kodeJasa ?? content.hashCode;
                                    final isSelected =
                                        _selectedContentIds.contains(id);
                                    final price = _parsePrice(
                                        content.tarifTindakan ??
                                            content.hargaUmum ??
                                            '0');
                                    final displayPrice = _formatPrice(price);
                                    return Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          onTap: () =>
                                              _toggleContent(content),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? Colors.blue
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                      color: isSelected
                                                          ? Colors.blue
                                                          : Colors
                                                              .grey.shade400,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: isSelected
                                                      ? const Icon(
                                                          Icons.check,
                                                          size: 16,
                                                          color: Colors.white,
                                                        )
                                                      : null,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        content.namaJasa ?? '-',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade800,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        displayPrice,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .blue.shade600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (_selectedContentIds.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.selected +
                            '${_selectedContentIds.length}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.total + _formatPrice(_totalPrice),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      AppLocalizations.of(context)!.order_confirmation,
                                    ),
                                    content: Text(
                                      AppLocalizations.of(context)!.orderConfirmationBody(_selectedContentIds.length, _formatPrice(_totalPrice)),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: Text(AppLocalizations.of(context)!.cancel),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          const int poliId = 0;
                                          final selectedItems =
                                              _selectedContentIds.toList();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => DoctorBookingFlow(
                                                poliId,
                                                fromExamination: true,
                                                itemIds: selectedItems,
                                                category: 'Laboratory',
                                              ),
                                            ),
                                          );
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(
                                          //    SnackBar(
                                          //     content: Text(
                                          //         AppLocalizations.of(context)!.orderSubmittedProceedToBooking), 
                                          //   ),
                                          // );
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.place_order,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.place_order,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
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
