import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class RangeSliderWidget extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double initialMin;
  final double initialMax;
  final ValueChanged<RangeValues> onChanged;
  final String? label;
  final String currencySymbol;

  const RangeSliderWidget({
    super.key,
    this.minValue = 0,
    this.maxValue = 110000,
    required this.initialMin,
    required this.initialMax,
    required this.onChanged,
    this.label,
    this.currencySymbol = '\$',
  });

  @override
  State<RangeSliderWidget> createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(widget.initialMin, widget.initialMax);
  }

  String _formatCurrency(double value) {
    return '${widget.currencySymbol}${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: widget.label ?? '',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.themeDark,
            ),
            Row(
              children: [
                CustomText(
                  text: _formatCurrency(_currentRangeValues.start),
                  fontSize: 12,
                ),
                CustomText(text: '-', fontSize: 12),
                CustomText(
                  text: _formatCurrency(_currentRangeValues.end),
                  fontSize: 12,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            
            rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
            activeTrackColor: Colors.redAccent,
            inactiveTrackColor: Colors.grey.shade300,
            trackHeight: 6.0,
          ),
          child: RangeSlider(
            padding: EdgeInsets.all(0),
            values: _currentRangeValues,
            min: widget.minValue,
            max: widget.maxValue,
            activeColor: Colors.redAccent,
            inactiveColor: Colors.grey.shade300,
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
              widget.onChanged(values);
            },
          ),
        ),
        SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: _formatCurrency(widget.minValue),
              fontSize: 12,
              color: context.themeIconGrey,
            ),
            CustomText(
              text: _formatCurrency(widget.maxValue),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ],
    );
  }
}
