
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class SingleSelectDropdownWidget extends StatefulWidget {
  final List<String> options;
  final String? initialSelected;
  final double height;
  final String hintText;
  final Function(String?) onChanged;
  final bool enabled;
  final Color? borderColor;
  final bool showBorder;
  final Widget? prefixIcon;
  final double hintFontSize;
  final bool borderOnlyBottom;
  final bool showShadow;
  final double borderRadius;
  final double dropdownBorderRadius; 

  const SingleSelectDropdownWidget({
    super.key,
    required this.options,
    this.initialSelected,
    this.height = 40,
    required this.hintText,
    required this.onChanged,
    this.enabled = true,
    this.borderColor,
    this.showBorder = true,
    this.prefixIcon,
    this.hintFontSize = 13,
    this.borderOnlyBottom = false,
    this.showShadow = true,
    this.borderRadius = 12,
    this.dropdownBorderRadius = 12, 
  });

  @override
  State<SingleSelectDropdownWidget> createState() =>
      _SingleSelectDropdownWidgetState();
}

class _SingleSelectDropdownWidgetState
    extends State<SingleSelectDropdownWidget> {
  String? selectedValue;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialSelected;
  }

  @override
  void didUpdateWidget(covariant SingleSelectDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelected != widget.initialSelected) {
      selectedValue = widget.initialSelected;
    }
  }

  void _safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) setState(fn);
  }

  void toggleDropdown() {
    if (!widget.enabled) return;
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
    return totalHeight > 200 ? 200 : totalHeight;
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
            borderRadius: BorderRadius.circular(widget.dropdownBorderRadius),
            child: Container(
              height: dropdownHeight,
              decoration: BoxDecoration(
                color: context.themeCardWhite,
                borderRadius: BorderRadius.circular(widget.dropdownBorderRadius),
                border: widget.showBorder
                    ? (widget.borderOnlyBottom
                          ? Border(
                              bottom: BorderSide(
                                color:
                                    widget.borderColor ?? context.themeDivider,
                                width: 1,
                              ),
                            )
                          : Border.all(
                              color: widget.borderColor ?? context.themeDivider,
                            ))
                    : null,
                boxShadow: widget.showShadow
                    ? const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.dropdownBorderRadius),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: widget.options.length,
                  itemBuilder: (_, index) {
                    final option = widget.options[index];
                    final isSelected = selectedValue == option;

                    return InkWell(
                      onTap: () => selectItem(option),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                text: option,
                                fontSize: 14,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
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

  void selectItem(String item) {
    _safeSetState(() => selectedValue = item);
    _closeDropdown();
    widget.onChanged(selectedValue);
  }

  void clearSelection() {
    _safeSetState(() => selectedValue = null);
    widget.onChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = _overlayEntry != null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: widget.showBorder
              ? (widget.borderOnlyBottom
                    ? Border(
                        bottom: BorderSide(
                          color: widget.borderColor ?? context.themeDivider,
                          width: 1,
                        ),
                      )
                    : Border.all(
                        color: widget.borderColor ?? context.themeDivider,
                      ))
              : null,
          boxShadow: widget.showShadow
              ? const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ]
              : [],
          color: widget.enabled ? context.themeWhite : Colors.grey.shade100,
        ),
        child: Row(
          children: [
            if (widget.prefixIcon != null) ...[
              widget.prefixIcon!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: GestureDetector(
                onTap: toggleDropdown,
                child: CustomText(
                  text: selectedValue ?? widget.hintText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: widget.hintFontSize,
                  color: selectedValue != null
                      ? context.themeDark
                      : context.themeIconGrey,
                ),
              ),
            ),
            if (selectedValue != null)
              GestureDetector(
                onTap: clearSelection,
                child: const Icon(Icons.close, size: 16, color: Colors.grey),
              ),
            IconButton(
              onPressed: toggleDropdown,
              icon: Icon(
                isOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
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