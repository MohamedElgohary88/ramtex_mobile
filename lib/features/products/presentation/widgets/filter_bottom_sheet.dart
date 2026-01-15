import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/params/product_filter_params.dart';

class FilterBottomSheet extends StatefulWidget {
  final ProductFilterParams currentParams;
  final Function(ProductFilterParams) onApply;

  const FilterBottomSheet({
    super.key,
    required this.currentParams,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late double _priceMin;
  late double _priceMax;
  String? _sort;

  @override
  void initState() {
    super.initState();
    _priceMin = widget.currentParams.priceMin ?? 0;
    _priceMax = widget.currentParams.priceMax ?? 10000;
    _sort = widget.currentParams.sort;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  // Reset logic
                  setState(() {
                    _priceMin = 0;
                    _priceMax = 10000;
                    _sort = null;
                  });
                }, 
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sort Options
          const Text('Sort By', style: TextStyle(fontWeight: FontWeight.w600)),
          Wrap(
            spacing: 8,
            children: [
              _buildChoiceChip('Newest', 'newest'),
              _buildChoiceChip('Price: Low to High', 'price_asc'),
              _buildChoiceChip('Price: High to Low', 'price_desc'),
            ],
          ),
          const SizedBox(height: 24),
          // Price Range
          Text('Price Range: ${_priceMin.toInt()} - ${_priceMax.toInt()}', style: const TextStyle(fontWeight: FontWeight.w600)),
          RangeSlider(
            values: RangeValues(_priceMin, _priceMax),
            min: 0,
            max: 10000,
            divisions: 100,
            labels: RangeLabels(_priceMin.toStringAsFixed(0), _priceMax.toStringAsFixed(0)),
            onChanged: (values) {
              setState(() {
                _priceMin = values.start;
                _priceMax = values.end;
              });
            },
          ),
          const SizedBox(height: 32),
          // Apply Button
          ElevatedButton(
            onPressed: () {
              final newParams = widget.currentParams.copyWith(
                priceMin: _priceMin,
                priceMax: _priceMax,
                sort: _sort,
                // Keep query, category, etc.
              );
              widget.onApply(newParams);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label, String value) {
    final selected = _sort == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (bool selected) {
        setState(() {
          _sort = selected ? value : null;
        });
      },
      selectedColor: AppColors.accent.withValues(alpha: 0.1),
      labelStyle: TextStyle(
        color: selected ? AppColors.accent : AppColors.textSecondary,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: selected ? AppColors.accent : Colors.grey.shade300,
      ),
    );
  }
}
