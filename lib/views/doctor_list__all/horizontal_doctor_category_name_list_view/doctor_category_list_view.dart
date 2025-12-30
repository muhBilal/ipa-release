import 'package:flutter/material.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';

class DoctorCategoryListView extends StatefulWidget {
  final List<dynamic> polis;

  final int? selectedPoliId;

  final ValueChanged<int?>? onPoliSelected;

  const DoctorCategoryListView({
    super.key,
    required this.polis,
    this.selectedPoliId,
    this.onPoliSelected,
  });

  @override
  State<DoctorCategoryListView> createState() => _DoctorCategoryListViewState();
}

class _DoctorCategoryListViewState extends State<DoctorCategoryListView> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _syncSelectedIndexWithId();
  }

  @override
  void didUpdateWidget(covariant DoctorCategoryListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedPoliId != widget.selectedPoliId ||
        oldWidget.polis.length != widget.polis.length) {
      _syncSelectedIndexWithId();
    }
  }

  void _syncSelectedIndexWithId() {
    if (widget.selectedPoliId == null) {
      selectedIndex = 0;
      return;
    }
    final idx =
        widget.polis.indexWhere((p) => (p.id as int) == widget.selectedPoliId);
    selectedIndex = idx == -1 ? 0 : (idx + 1);
  }

  @override
  Widget build(BuildContext context) {
    final labels = <String>[
      'All',
      ...widget.polis.map((p) => p.nama as String)
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          final label = labels[index];

          return GestureDetector(
            onTap: () {
              setState(() => selectedIndex = index);

              if (index == 0) {
                widget.onPoliSelected?.call(null);
              } else {
                final poli = widget.polis[index - 1];
                widget.onPoliSelected?.call(poli.id as int);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.mirageColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.mirageColor),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.mirageColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
