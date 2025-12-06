
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class MultiSelectDropdownWidget extends StatefulWidget {
  final List<String> options;
  final List<String> initialSelected;
  final double height;
  final Function(List<String>) onChanged;

  const MultiSelectDropdownWidget({
    super.key,
    required this.options,
    this.initialSelected = const [],
    this.height = 40,
    required this.onChanged,
  });

  @override
  State<MultiSelectDropdownWidget> createState() =>
      _MultiSelectDropdownWidgetState();
}

class _MultiSelectDropdownWidgetState extends State<MultiSelectDropdownWidget> {
  late List<String> selectedValues;
  bool isDropdownOpen = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    selectedValues = List.from(widget.initialSelected);
  }

  @override
  void didUpdateWidget(MultiSelectDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isDisposed) return;
    if (oldWidget.initialSelected != widget.initialSelected) {
      selectedValues = List.from(widget.initialSelected);
    }
  }

  void _safeSetState(VoidCallback fn) {
    if (_isDisposed) {
      debugPrint('⚠️ Prevented setState after dispose in MultiSelectDropdown');
      return;
    }
    if (!mounted) {
      debugPrint('⚠️ Prevented setState on unmounted MultiSelectDropdown');
      return;
    }
    setState(fn);
  }

  void toggleDropdown() {
    _safeSetState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  void toggleSelection(String item) {
    if (_isDisposed || !mounted) return;

    _safeSetState(() {
      if (selectedValues.contains(item)) {
        selectedValues.remove(item);
      } else {
        selectedValues.add(item);
      }
    });
    if (!_isDisposed && mounted) {
      try {
        widget.onChanged(selectedValues);
      } catch (e) {
        debugPrint('⚠️ Error in onChanged callback: $e');
      }
    }
  }

  void _forceCloseDropdown() {
    isDropdownOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    final borderColor = context.themeDivider;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            color: context.themeWhite,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: selectedValues.isEmpty
                        ? [
                            CustomText(
                              text: "Select options",
                              color: context.themeGrey600,
                              fontSize: 13,
                            ),
                          ]
                        : selectedValues
                              .map(
                                (value) => Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: context.themeLightGrey3,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomText(
                                            text: value,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => toggleSelection(value),
                                      child: const Icon(
                                        Icons.close,
                                        size: 8,
                                        color: ColorConsts.textColorRed,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isDropdownOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade700,
                  size: 16,
                ),
                onPressed: _isDisposed ? null : toggleDropdown,
              ),
            ],
          ),
        ),

        if (isDropdownOpen && !_isDisposed)
          Container(
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: context.themeWhite,
              borderRadius: borderRadius,
              border: Border.all(color: borderColor),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final option = widget.options[index];
                final isSelected = selectedValues.contains(option);

                return InkWell(
                  onTap: () => toggleSelection(option),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: CustomText(text: option, fontSize: 14)),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _forceCloseDropdown();
    super.dispose();
  }
}
