import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Ngoerahsun/widgets/gradient_background/gradient_background.dart';
import 'package:Ngoerahsun/provider/radiology/radiology_provider.dart';
import 'package:Ngoerahsun/model/radiology_menu.dart';
import 'package:Ngoerahsun/views/doctor_booking/doctor_booking_screen.dart';

class RadiologyOrderPageView extends StatefulWidget {
  const RadiologyOrderPageView({super.key});

  @override
  State<RadiologyOrderPageView> createState() => _RadiologyOrderPageViewState();
}

class _RadiologyOrderPageViewState extends State<RadiologyOrderPageView> {
  final Set<int> _selectedIds = {};
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RadiologyProvider>().fetchMenus();
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value.trim().toLowerCase();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _query = '';
    });
  }

  void _toggleItem(RadiologyMenu item) {
    setState(() {
      final id = item.kdRad ?? item.hashCode;
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
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
    final prov = context.read<RadiologyProvider>();
    int sum = 0;
    for (final item in prov.menus) {
      final id = item.kdRad ?? item.hashCode;
      if (_selectedIds.contains(id)) {
        sum += _parsePrice(item.tarif?.toString());
      }
    }
    return sum;
  }

  String _formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.order_radiology,
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
      ),
      body: GradientBackground(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search_radiology,
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: _clearSearch,
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.2),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<RadiologyProvider>(
                builder: (context, prov, _) {
                  if (prov.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (prov.error != null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(AppLocalizations.of(context)!.error_3 + prov.error!),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () =>
                                prov.fetchMenus(forceRefresh: true),
                            child: Text(AppLocalizations.of(context)!.retry),
                          ),
                        ],
                      ),
                    );
                  }
                  if (prov.menus.isEmpty) {
                    return Center(
                      child: Text(AppLocalizations.of(context)!.no_radiology_items),
                    );
                  }
                  final filteredMenus = _query.isEmpty
                      ? prov.menus
                      : prov.menus.where((item) {
                          final name = item.namaRad?.toLowerCase() ?? '';
                          final code = item.kodeTarif?.toLowerCase() ?? '';
                          return name.contains(_query) || code.contains(_query);
                        }).toList();
                  if (filteredMenus.isEmpty) {
                    return Center(
                      child: Text(AppLocalizations.of(context)!.no_matching_results),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredMenus.length,
                    itemBuilder: (context, index) {
                      final item = filteredMenus[index];
                      final id = item.kdRad ?? item.hashCode;
                      final isSelected = _selectedIds.contains(id);
                      final displayPrice =
                          item.tarif != null && item.tarif! > 0
                              ? _formatPrice(item.tarif!)
                              : '-';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
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
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => _toggleItem(item),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
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
                                            : Colors.grey.shade400,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.namaRad ?? '-',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          displayPrice,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue.shade600,
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
                  );
                },
              ),
            ),
            if (_selectedIds.isNotEmpty)
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
                            AppLocalizations.of(context)!.selected_1(_selectedIds.length),
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
                            AppLocalizations.of(context)!.total_1(_formatPrice(_totalPrice)),
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
                                    title: Text(AppLocalizations.of(context)!.order_confirmation),
                                    content: Text(
                                      AppLocalizations.of(context)!.orderConfirmationBody(_selectedIds.length, _formatPrice(_totalPrice))),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(AppLocalizations.of(context)!.cancel),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          final selectedItems =
                                              _selectedIds.toList();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => DoctorBookingFlow(
                                                0,
                                                fromExamination: true,
                                                itemIds: selectedItems,
                                                category: 'Radiology',
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
                                        child: const Text('Confirm Order'),
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
