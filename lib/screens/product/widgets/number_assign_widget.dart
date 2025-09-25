import 'package:active_ecommerce_cms_demo_app/custom/toast_component.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_dimensions.dart';

/// NumberAssignWidget — OTP-like slot containers with unique number assignment.
/// - No TextFields; slots are containers showing the number only.
/// - Tap a slot to focus it. Picking a number assigns/replaces in the focused slot,
///   otherwise it fills the first empty slot (no compacting on delete).
/// - Tap the same number again in the grid to remove it from its slot.
/// - Clear button wipes all slots.
/// - All visible strings use `'key'.tr(context: context, args: {...})`.
class NumberAssignWidget extends StatefulWidget {
  const NumberAssignWidget({
    super.key,
    this.maxNumber = 30, // inclusive: 0..maxNumber
    this.fieldCount = 5, // number of OTP-like slots in a single row
    required this.onChanged,
    this.initialSelection = const <int>[],
    this.titleKey,
    this.gridSpacing = AppDimensions.paddingSmallExtra,
    this.gridRunSpacing = AppDimensions.paddingSmallExtra,
    this.buttonSize = const Size(40, 40),
    this.gridMaxWidth = 520,
    this.selectedBgColor,
    this.unselectedBgColor,
    this.slotHeight = 56.0, // slot height; width is flexible (to fit 2 digits)
    this.slotRadius = 12.0,
    required this.fieldKey,
  })  : assert(maxNumber >= 0, 'maxNumber must be >= 0'),
        assert(fieldCount > 0, 'fieldCount must be > 0');

  final int maxNumber;
  final int fieldCount;
  final ValueChanged<List<int>> onChanged;
  final List<int> initialSelection;

  // Optional UI/strings
  final String? titleKey;
  final double gridSpacing;
  final double gridRunSpacing;
  final Size buttonSize;
  final double gridMaxWidth;
  final Color? selectedBgColor;
  final Color? unselectedBgColor;

  // Slot styling
  final double slotHeight;
  final double slotRadius;
  final GlobalKey<FormFieldState> fieldKey;

  @override
  State<NumberAssignWidget> createState() => _NumberAssignWidgetState();
}

class _NumberAssignWidgetState extends State<NumberAssignWidget> {
  // Fixed-order slots; null means empty (no compacting on delete).
  late List<int?> _slots;

  // number -> slot index (for O(1) uniqueness and toggling).
  final Map<int, int> _posByNumber = <int, int>{};

  // Focused slot index for replacement.
  int? _focusedIndex;

  // ---- Lifecycle ----
  @override
  void initState() {
    super.initState();
    _initSlotsFromInitial();
    WidgetsBinding.instance.addPostFrameCallback((_) => _notify());
  }

  void _initSlotsFromInitial() {
    _slots = List<int?>.filled(widget.fieldCount, null, growable: false);
    final seen = <int>{};
    var idx = 0;
    for (final n in widget.initialSelection) {
      if (idx >= widget.fieldCount) break;
      if (n < 0 || n > widget.maxNumber) continue;
      if (!seen.add(n)) continue;
      _slots[idx] = n;
      _posByNumber[n] = idx;
      idx++;
    }
  }

  // ---- Helpers ----
  bool _isSelected(int n) => _posByNumber.containsKey(n);

  void _notify() =>
      widget.onChanged(_slots.whereType<int>().toList(growable: false));

  void _setFocus(int index) => setState(() => _focusedIndex = index);

  int? _firstEmptyIndex() {
    for (var i = 0; i < _slots.length; i++) {
      if (_slots[i] == null) return i;
    }
    return null;
  }

  void _clearAll() {
    setState(() {
      for (var i = 0; i < _slots.length; i++) {
        _slots[i] = null;
      }
      _posByNumber.clear();
      _focusedIndex = 0;
      _notify();
    });
  }

  void _assignNumber(int n) {
    // Toggle off if the number is already selected.
    final existing = _posByNumber[n];
    if (existing != null) {
      setState(() {
        _slots[existing] = null; // keep position empty (no compact)
        _posByNumber.remove(n);
        _notify();
      });
      return;
    }

    // Pick target: focused slot if set, else first empty.
    final int? target = _focusedIndex ?? _firstEmptyIndex();
    if (target == null) {
      ToastComponent.showDialog(
        'all_fields_filled'.tr(context: context),
        isError: true,
      );
      return;
    }

    setState(() {
      // If target has a value, free it.
      final old = _slots[target];
      if (old != null) _posByNumber.remove(old);

      // Assign new number to target.
      _slots[target] = n;
      _posByNumber[n] = target;

      // Move focus to next empty if any; else keep on current.
      _focusedIndex = _firstEmptyIndex() ?? target;
      _notify();
    });
  }

  // ---- UI ----
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color selectedColor =
        widget.selectedBgColor ?? theme.colorScheme.primary;
    final Color unselectedColor =
        widget.unselectedBgColor ?? theme.colorScheme.surfaceContainerHighest;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: FormField<List<int?>>(
          key: widget.fieldKey,
          initialValue: widget.initialSelection,
          autovalidateMode: AutovalidateMode.onUnfocus,
          validator: (value) {
            if ((value?.nonNulls.length ?? 0) < widget.fieldCount) {
              return 'fill_all_slots'.tr(context: context);
            }
            return null;
          },
          builder: (state) {
            void onChangeNumbers(void Function() anyChange) {
              anyChange();
              state.didChange(_slots);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.titleKey != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      widget.titleKey!.tr(context: context),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: state.hasError ? theme.colorScheme.error : null,
                      ),
                    ),
                  ),

                // OTP-like single row (Flexible slots; each can fit 2 digits).
                SizedBox(
                  height: widget.slotHeight,
                  child: Row(
                    spacing: 8,
                    textDirection: TextDirection.ltr,
                    children: [
                      // Slots
                      Expanded(
                        child: Row(
                          textDirection: TextDirection.ltr,
                          children: List.generate(widget.fieldCount, (index) {
                            final int? value = _slots[index];
                            final bool isFocused = _focusedIndex == index;
                            return Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: _SlotBox(
                                  height: widget.slotHeight,
                                  radius: widget.slotRadius,
                                  value: value,
                                  focused: isFocused,
                                  hasError: state.hasError && value == null,
                                  onTap: () => _setFocus(index),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      // Clear button
                      TextButton.icon(
                        onPressed: () => onChangeNumbers(_clearAll),
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text('clear_ucf'.tr(context: context)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Numbers grid
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: widget.gridMaxWidth),
                  child: Wrap(
                    spacing: widget.gridSpacing,
                    runSpacing: widget.gridRunSpacing,
                    textDirection: TextDirection.ltr,
                    children: List.generate(widget.maxNumber + 1, (i) {
                      final isSelected = _isSelected(i);
                      return _NumberChip(
                        label: i.toString(),
                        isSelected: isSelected,
                        selectedColor: selectedColor,
                        unselectedColor: unselectedColor,
                        disabledColor:
                            theme.disabledColor.withValues(alpha: 0.2),
                        size: widget.buttonSize,
                        onTap: () => onChangeNumbers(() => _assignNumber(i)),
                        onLongPress: () => onChangeNumbers(
                          () => _assignNumber(i),
                        ),
                      );
                    }),
                  ),
                ),

                if (state.hasError) ...[
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      state.errorText ?? '',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.error),
                    ),
                  ),
                ],
              ],
            );
          }),
    );
  }
}

class _SlotBox extends StatelessWidget {
  const _SlotBox({
    required this.value,
    required this.focused,
    required this.onTap,
    required this.height,
    required this.radius,
    required this.hasError,
  });

  final int? value;
  final bool focused;
  final VoidCallback onTap;
  final double height;
  final double radius;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: height,
      child: Material(
        borderRadius: BorderRadius.circular(radius),
        color: theme.colorScheme.surface,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: hasError
                    ? theme.colorScheme.error
                    : focused
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                width: focused ? 2 : 0.7,
              ),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            // FittedBox to ensure up to 2 digits fit nicely
            child: value == null
                ? const SizedBox.shrink()
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$value',
                      maxLines: 1,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _NumberChip extends StatelessWidget {
  const _NumberChip({
    required this.label,
    required this.isSelected,
    required this.size,
    required this.onTap,
    required this.onLongPress,
    required this.selectedColor,
    required this.unselectedColor,
    required this.disabledColor,
  });

  final String label;
  final bool isSelected;
  final Size size;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Color selectedColor;
  final Color unselectedColor;
  final Color disabledColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = isSelected ? selectedColor : unselectedColor;
    final fg = isSelected
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurfaceVariant;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
