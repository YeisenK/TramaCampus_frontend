import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../t_button.dart';
import '../t_text_field.dart';
import '../error_state.dart';
import '../empty_state.dart';
import '../skeleton_loader.dart';
import 'required_field_hint.dart';
import '../../../data/models/catalog/catalog.dart';
import '../../../data/models/catalog/catalog_item.dart';
import '../../../data/models/catalog/catalog_set.dart';
import '../../../data/repositories/catalog_repository.dart';

// Full-page modal picker for large catalogs (skills, hobbies, research, etc.).
// Opened via CatalogPickerSheet.show(). Returns the updated selection set.
class CatalogPickerSheet extends StatefulWidget {
  const CatalogPickerSheet({
    super.key,
    required this.catalogName,
    required this.initialSelected,
    this.title,
    this.min,
    this.max,
  });

  final String catalogName;
  final Set<String> initialSelected;
  final String? title;
  final int? min;
  final int? max;

  static Future<Set<String>?> show(
    BuildContext context, {
    required String catalogName,
    required Set<String> initialSelected,
    String? title,
    int? min,
    int? max,
  }) {
    return Navigator.of(context).push<Set<String>>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => CatalogPickerSheet(
          catalogName: catalogName,
          initialSelected: Set.from(initialSelected),
          title: title,
          min: min,
          max: max,
        ),
      ),
    );
  }

  @override
  State<CatalogPickerSheet> createState() => _CatalogPickerSheetState();
}

class _CatalogPickerSheetState extends State<CatalogPickerSheet> {
  late final Set<String> _selected;
  late final TextEditingController _searchCtrl;
  Catalog? _catalog;
  Object? _error;
  List<CatalogItem>? _searchResults;
  final Set<String> _expandedSets = {};

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initialSelected);
    _searchCtrl = TextEditingController();
    _searchCtrl.addListener(_onSearch);
    _loadCatalog();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCatalog() async {
    try {
      final catalog =
          await BundledCatalogRepository.instance.load(widget.catalogName);
      if (!mounted) return;
      setState(() {
        _catalog = catalog;
        // Expand all groups by default so items are immediately visible.
        _expandedSets.addAll(catalog.sets.map((s) => s.id));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  void _onSearch() {
    final q = _searchCtrl.text;
    if (_catalog == null) return;
    setState(() {
      _searchResults = q.trim().isEmpty ? null : _catalog!.search(q);
    });
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        final max = widget.max;
        if (max != null && _selected.length >= max) return;
        _selected.add(id);
      }
    });
  }

  bool get _canConfirm =>
      widget.min == null || _selected.length >= widget.min!;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Seleccionar',
            style: AppTextStyles.titleMd(cs.onSurface)),
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _error != null
          ? ErrorState(
              message: 'Error cargando catálogo.',
              onRetry: () {
                setState(() => _error = null);
                _loadCatalog();
              },
            )
          : _catalog == null
              ? const SkeletonLoader()
              : _buildContent(cs),
      bottomNavigationBar: _error == null && _catalog != null
          ? _ConfirmBar(
              selected: _selected.length,
              min: widget.min,
              max: widget.max,
              canConfirm: _canConfirm,
              onConfirm: () => Navigator.of(context).pop(Set<String>.from(_selected)),
            )
          : null,
    );
  }

  Widget _buildContent(ColorScheme cs) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space5,
            AppSpacing.space3,
            AppSpacing.space5,
            AppSpacing.space2,
          ),
          child: Column(
            children: [
              if (widget.min != null || widget.max != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: RequiredFieldHint(
                    current: _selected.length,
                    min: widget.min,
                    max: widget.max,
                  ),
                ),
              TTextField(
                controller: _searchCtrl,
                label: '',
                hint: 'Buscar...',
                prefixIcon: Icons.search,
              ),
            ],
          ),
        ),
        Expanded(
          child: _searchResults != null
              ? _buildFlatList(_searchResults!)
              : _buildGroupedList(),
        ),
      ],
    );
  }

  Widget _buildFlatList(List<CatalogItem> items) {
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'Sin resultados',
        subtitle: 'Intenta con otro término.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space5,
        vertical: AppSpacing.space2,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _ItemTile(
        item: items[i],
        selected: _selected.contains(items[i].id),
        onTap: () => _toggle(items[i].id),
      ),
    );
  }

  Widget _buildGroupedList() {
    final grouped = _catalog!.groupedBySet();
    final entries = grouped.entries.toList();
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSpacing.space10),
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final set = entries[i].key;
        final items = entries[i].value;
        if (items.isEmpty) return const SizedBox.shrink();
        final expanded = _expandedSets.contains(set.id);
        return _GroupSection(
          set: set,
          items: items,
          expanded: expanded,
          selected: _selected,
          onToggleGroup: () => setState(() {
            if (expanded) {
              _expandedSets.remove(set.id);
            } else {
              _expandedSets.add(set.id);
            }
          }),
          onToggleItem: _toggle,
        );
      },
    );
  }
}

class _GroupSection extends StatelessWidget {
  const _GroupSection({
    required this.set,
    required this.items,
    required this.expanded,
    required this.selected,
    required this.onToggleGroup,
    required this.onToggleItem,
  });

  final CatalogSet set;
  final List<CatalogItem> items;
  final bool expanded;
  final Set<String> selected;
  final VoidCallback onToggleGroup;
  final void Function(String) onToggleItem;

  int get _selectedCount => items.where((i) => selected.contains(i.id)).length;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        InkWell(
          onTap: onToggleGroup,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space5,
              vertical: AppSpacing.space3,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(set.label,
                      style: AppTextStyles.bodyMd(cs.onSurface)),
                ),
                if (_selectedCount > 0)
                  Container(
                    margin: const EdgeInsets.only(right: AppSpacing.space2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space2,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      '$_selectedCount',
                      style: AppTextStyles.labelSm(cs.primary),
                    ),
                  ),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: cs.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          ...items.map((item) => _ItemTile(
                item: item,
                selected: selected.contains(item.id),
                onTap: () => onToggleItem(item.id),
              )),
        Divider(height: 0, color: cs.outlineVariant.withValues(alpha: 0.3)),
      ],
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final CatalogItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space5,
        vertical: 0,
      ),
      title: Text(item.label, style: AppTextStyles.bodyMd(cs.onSurface)),
      trailing: selected
          ? Icon(Icons.check_circle, color: cs.primary)
          : Icon(Icons.circle_outlined,
              color: cs.onSurfaceVariant.withValues(alpha: 0.4)),
    );
  }
}

class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({
    required this.selected,
    required this.canConfirm,
    required this.onConfirm,
    this.min,
    this.max,
  });

  final int selected;
  final int? min;
  final int? max;
  final bool canConfirm;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final label = max != null
        ? 'Confirmar ($selected/$max)'
        : 'Confirmar ($selected)';
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space5,
          AppSpacing.space3,
          AppSpacing.space5,
          AppSpacing.space5,
        ),
        child: TButton(
          label: label,
          onPressed: canConfirm ? onConfirm : null,
        ),
      ),
    );
  }
}
