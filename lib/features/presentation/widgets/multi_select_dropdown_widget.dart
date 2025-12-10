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
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    selectedValues = List.from(widget.initialSelected);
  }

  @override
  void didUpdateWidget(MultiSelectDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelected != widget.initialSelected) {
      selectedValues = List.from(widget.initialSelected);
    }
  }

  void _safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) setState(fn);
  }

  void toggleDropdown() {
    if (_overlayEntry != null) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _safeSetState(() {});
  }

  void _closeDropdown({bool fromDispose = false}) {
    try {
      _overlayEntry?.remove();
    } catch (_) {}
    _overlayEntry = null;

    if (!fromDispose && mounted) {
      setState(() {});
    }
  }

  double _calculateDropdownHeight() {
    const double itemHeight = 48.0;
    final double totalHeight = widget.options.length * itemHeight;
    return totalHeight > 300 ? 300 : totalHeight;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox box = context.findRenderObject() as RenderBox;
    var size = box.size;
    final dropdownHeight = _calculateDropdownHeight();

    return OverlayEntry(
      builder: (_) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height + 6),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: dropdownHeight,
              decoration: BoxDecoration(
                color: context.themeWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.themeDivider),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: widget.options.length,
                  itemBuilder: (_, index) {
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
            ),
          ),
        ),
      ),
    );
  }

  void toggleSelection(String item) {
    _safeSetState(() {
      if (selectedValues.contains(item)) {
        selectedValues.remove(item);
      } else {
        selectedValues.add(item);
      }
    });
    
    _overlayEntry?.markNeedsBuild();
    
    widget.onChanged(selectedValues);
  }

  void removeItem(String item) {
    _safeSetState(() {
      selectedValues.remove(item);
    });
    
    _overlayEntry?.markNeedsBuild();
    
    widget.onChanged(selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = _overlayEntry != null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.themeDivider),
              color: context.themeWhite,
            ),
            child: Padding(
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
                                        onTap: () => removeItem(value),
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
                      isOpen
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey.shade700,
                      size: 16,
                    ),
                    onPressed: toggleDropdown,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _closeDropdown(fromDispose: true);
    super.dispose();
  }
}